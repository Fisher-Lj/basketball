//
//  QFXMPPManager.m
//  basketball
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "QFXMPPManager.h"
#import "AppDelegate.h"
#import "coreData.h"
#import "registerModel.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
//断点续传
#import "XMPPReconnect.h"
#import "XMPPCapabilities.h"
//打印信息
#import "DDLog.h"
#import "DDTTYLogger.h"
//花名册
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
// 信息
#import "XMPPMessage.h"
//发送文件
#import "TURNSocket.h"
//名片模型
#import "XMPPvCardTempModule.h"
#import "XMPPvCardTempCoreDataStorageObject.h"
#import "XMPPvCardAvatarModule.h"
//聊天室
#import "XMPPRoom.h"

@implementation QFXMPPManager

- (id)init
{
    self = [super init];
    if (self) {
        _allFriends=[[NSMutableArray alloc]init];
        _currentUser=[[UserModel alloc]init];
        _xmppStream=[[XMPPStream alloc]init];
        [_xmppStream setHostName:IP];
        [_xmppStream setHostPort:5222];
       [ _xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self setupStream];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
    return self;
}
+(id)shareInstance
{
    static id s;
    if (s==nil) {
        s=[[self alloc]init];
    }
    return s;
}
-(void)setupStream
{
    _userDefaults=[NSUserDefaults standardUserDefaults];
    _xmppReconnect=[[XMPPReconnect alloc]init];
    _xmppRosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
    _xmppRoster=[[XMPPRoster alloc]initWithRosterStorage:_xmppRosterStorage];
    _xmppRoster.autoFetchRoster=YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests=YES;
    _xmppvCardStotage=[[XMPPvCardCoreDataStorage alloc]init];
    _xmppvCardTempModule=[[XMPPvCardTempModule alloc]initWithvCardStorage:_xmppvCardStotage];
    _xmppvCardAvatarModule=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_xmppvCardTempModule];
    [_xmppRoster activate:_xmppStream];
    [_xmppReconnect activate:_xmppStream];
    [_xmppvCardTempModule activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    _xmppMessageArchivingCoreDataStorage=[XMPPMessageArchivingCoreDataStorage sharedInstance];
    _xmppMessageArchivingModule=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [_xmppMessageArchivingModule activate:_xmppStream];
    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    _subscribeArray=[NSMutableArray arrayWithCapacity:0];
    //??
    [_xmppRosterStorage mainThreadManagedObjectContext];
}
#pragma mark 登录
-(void)loginUser:(void(^)(BOOL))cb{
    loginFinishedcb=[cb copy];
    isLogin=YES;
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
   NSString * username=[_userDefaults objectForKey:MYJID];
       XMPPJID *jid=[XMPPJID jidWithString:username];
    NSLog(@"%@",username);
    [_xmppStream setMyJID:jid];
    NSError *err=nil;
    BOOL ret=[_xmppStream connectWithTimeout:-1 error:&err];
    if (ret==NO) {
        loginFinishedcb(NO);
        NSLog(@"%@",err);
    }
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    loginFinishedcb(NO);
}
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    //线程3中也有代理xmppRoster???
//    if ([self autoFetchRoster])
//	{
//		[self fetchRoster];
//	}

    //[_xmppRoster fetchRoster];
    if (loginFinishedcb) {
        loginFinishedcb(YES);
    }
    [self online];
    
}
#pragma mark 退出登录
- (void)disconnect
{
    [_userDefaults removeObjectForKey:ISLOGIN];
    [_userDefaults removeObjectForKey:MYJID];
    [_userDefaults removeObjectForKey:PASSWORD];
    [_userDefaults synchronize];
    
    //发送离线消息
    [self goOffline];
    [_xmppStream disconnect];
}
- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:presence];
}

#pragma mark 注册
-(void)registerUser:(NSString *)username withPassword:(NSString *)passWord completion:(void (^)(BOOL))cb
{
    registerFinishedcb=[cb copy];
    isLogin=NO;
    _currentUser.jid=username;
    _currentUser.password=passWord;
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    XMPPJID *myjid=[XMPPJID jidWithString:username];
    [_xmppStream setMyJID:myjid];
    NSError *error=nil;
    BOOL ret=[_xmppStream connectWithTimeout:1 error:&error];
    if (ret==NO) {
        registerFinishedcb(NO);
    }
}
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (registerFinishedcb) {
        registerFinishedcb(YES);
    }
}
#pragma mark xmppStream delegate

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (isLogin) {
        loginFinishedcb(NO);
    }else {
        registerFinishedcb(NO);
    }
}
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSString *password=[_userDefaults objectForKey:PASSWORD];
    NSError *err=nil;
    if (isLogin==YES) {
        [_xmppStream authenticateWithPassword:password error:&err];
         }
    else{
        [_xmppStream registerWithPassword:password error:&err];
    }
}
#pragma mark   上线   获取好友
-(void)online
{
    XMPPPresence *pre=[XMPPPresence presence];
    [_xmppStream sendElement:pre];
}
-(void)getAllFriend
{
    NSXMLElement *query=[NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq=[NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [_xmppStream sendElement:iq];
}
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    NSXMLElement *query=iq.childElement;
    for (NSXMLElement *item in query.children) {
        NSString *jid=[item attributeStringValueForName:@"jid"];
     
       // [self add:jid];
    }

    return YES;
    }
//func xmppStream:didReceiveIQ:
//<iq xmlns="jabber:client" type="result" to="jiange@1000phone.net/47256bcf">
//<query xmlns="jabber:iq:roster">
//<item jid="jiange4@1000phone.net" name="jiange4" subscription="both"><group>?????</group><group>??</group>
//</item><item jid="jiange2@1000phone.net" name="jiange2" subscription="to"><group>?????</group></item>
//</query></iq>
#pragma mark 别人是否同意好友请求以及上线下线更新
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
//    NSString *jid1=[presence attributeStringValueForName:@"from"];
//    NSString *jid2=[presence attributeStringValueForName:@"to"];
//    NSMutableString*str=[[NSMutableString alloc]initWithString:jid1];
//    NSString *jid=[str componentsSeparatedByString:@"/"][0];
//    NSString *status=@"online";
//    for (NSXMLElement *oneChild in presence.children) {
//        if ([oneChild.name isEqualToString:@"show"]) {
//            status=@"away";
//        }
//    }
//    if (![jid1 isEqualToString:jid2]) {
//        [self addOrUpdate:jid withStatu:status];
//    }
    NSString *presenceType = [presence type];
    XMPPJID *jid = [XMPPJID jidWithUser:[presence from].user domain:IP resource:@"IOS"];
    if ([presenceType isEqualToString:@"subscribe"]) {
        if (_subscribeArray.count==0) {
            [self.subscribeArray addObject:presence];
        }else{
            BOOL isExist=NO;
            for (XMPPPresence*pre in _subscribeArray)
            {
                if ([pre.from.user isEqualToString:presence.from.user])
                {
                    isExist=YES;
                }
            }
            if (!isExist) {
                [self.subscribeArray addObject:presence];
            }}
    }
    if ([presenceType isEqualToString:@"unsubscribed"]) {
        //拒绝
        [_xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
    }
    if ([presenceType isEqualToString:@"unsubscribe"]) {
        [_xmppRoster unsubscribePresenceFromUser:jid];//遇到对方拒绝我的请求，我也拒绝他，然后从列表中删除这个人
    }
    if ([presenceType isEqualToString:@"subscribed"]) {
        //取得状态 subscribed同意后   subscribe 同意前
        //别人添加你，状态为subscribe为同意前，然后发送同意给对方 ，对方收到后为subscribed
        //你添加别人，状态为subscribed为同意前，然后发送状态，刷新列表
        //双向关注后为好友
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];//同意
    }
    
}
#pragma mark 同意好友请求
//同意
-(void)agreeRequest:(NSString*)name
{
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:IP resource:@"IOS"];
    [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    XMPPPresence*temp=nil;
    for (XMPPPresence*pre in _subscribeArray)
    {
        if ([pre.from.user isEqualToString:name])
        {
            temp=pre;
        }
    }
    
    if (temp) {
        [self.subscribeArray removeObject:temp];
        
    }
}
#pragma mark 拒绝好友请求
//拒绝
-(void)reject:(NSString*)name{
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:IP resource:@"IOS"];
    [_xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
    XMPPPresence*temp=nil;
    for (XMPPPresence*pre in _subscribeArray)
    {
        if ([pre.from.user isEqualToString:name])
        {
            temp=pre;
        }
    }
    
    if (temp) {
        [self.subscribeArray removeObject:temp];
        
    }
    
}

//2015-04-15 10:54:44.918 xmpp[558:70b] pre<presence xmlns="jabber:client" from="jiange@1000phone.net/efc71fcf" to="jiange@1000phone.net/efc71fcf"/>
//2015-04-15 10:54:44.951 xmpp[558:70b] pre<presence xmlns="jabber:client" from="jiange4@1000phone.net/L" to="jiange@1000phone.net/efc71fcf"><c xmlns="http://jabber.org/protocol/caps" node="http://pidgin.im/" hash="sha-1" ver="DdnydQG7RGhP9E3k9Sf+b+bF0zo="/><x xmlns="vcard-temp:x:update"><photo>67755e42a2178a09456cc84a9f8c398ea2b290c2</photo></x></presence>
//2015-04-15 10:54:44.952 xmpp[558:70b] pre<presence xmlns="jabber:client" from="jiange2@1000phone.net" to="jiange@1000phone.net" type="subscribe"/>
#pragma mark 接受消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if ([[message elementForName:@"body"]stringValue]) {
        [self receiveMessage:message];
    }
}
#pragma mark  处理接收到的单聊消息
-(void)receiveMessage:(XMPPMessage *)message
{
    if (![_chatPerson isEqualToString:@"none"]) {
        valuationChatPersoncb(nil);
    }
    NSString *fromjid=[[[[message from]bare]componentsSeparatedByString:@"@"]objectAtIndex:0];
    NSString *type=[[[[message from]bare]componentsSeparatedByString:@"@"]objectAtIndex:1];
    chatModel *model=[[chatModel alloc]init];
    model.message=[NSString stringWithFormat:@"%@",[message body]];
    model.date=[NSDate date];
    model.jid=fromjid;
    model.isSelf=[_userDefaults objectForKey:MYJID];
    model.type=[type hasPrefix:IP]?SOLECHAT:GROUPCHAT;
    [[coreData shareIntance]update:model];
    
}
//<message xmlns="jabber:client" type="chat" id="purple27bdda7" to="jiange@1000phone.net" from="jiange2@1000phone.net/L">
//<paused xmlns="http://jabber.org/protocol/chatstates"/></message>
//2015-04-16 19:24:55.751 basketball[2168:70b] <message xmlns="jabber:client" type="chat" id="purple27bdda8" to="jiange@1000phone.net" from="jiange2@1000phone.net/L">
//<active xmlns="http://jabber.org/protocol/chatstates"/>
//<body>kk</body></message>
//2015-04-16 19:24:55.800 basketball[2168:70b] <message xmlns="jabber:client" type="chat" id="purple27bdda9" to="jiange@1000phone.net" from="jiange2@1000phone.net/L"><active xmlns="http://jabber.org/protocol/chatstates"/></message>


#pragma mark   发送消息
-(void)sendMessage:(NSString *)message withType:(NSString *)type withTojid:(NSString *)jid completion:(void (^)(BOOL))cb
{
    sendMessagecb=[cb copy];
    
        XMPPJID *xjid=[XMPPJID jidWithString:jid];
    XMPPMessage *xmppMessage=[[XMPPMessage alloc]initWithType:@"chat" to:xjid];
        NSString *messg=[NSString stringWithFormat:@"%@%@",type,message];
        [xmppMessage addBody:messg];
        [_xmppStream sendElement:xmppMessage];
       //数据库会自己记录聊天记录
    //自己只需要记录最近一条的聊天记录
    
    NSArray *arr=[jid componentsSeparatedByString:@"@"];
    chatModel *model=[[chatModel alloc]init];
    if ([type isEqualToString:MESSAGE_IMAGESTR]||[type isEqualToString:MESSAGE_BIGIMAGESTR]) {
        model.message=@"图片";
    }
    else if ([type isEqualToString:MESSAGE_VOICE]){
    
    model.message=@"语音";
    }
    else{
        model.message=[NSString stringWithFormat:@"%@",message];}
    model.jid=arr[0];
    model.type=SOLECHAT;
    model.date=[NSDate date];
    model.isSelf=[_userDefaults objectForKey:MYJID];
    [[coreData shareIntance]update:model];
    }
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    sendMessagecb(YES);
}
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{

    sendMessagecb(NO);
}
#pragma mark  上传名片
-(void)getMyCard:(void (^)(BOOL))cb
{
    getMyCardcb=[cb copy];
    XMPPvCardTemp *temp=[_xmppvCardTempModule myvCardTemp];
    registerModel *model=[registerModel shareManager];
    if (temp) {
        temp.photo=UIImageJPEGRepresentation(model.headerImage, 0.01);
        if (model.nickName.length!=0) {
            [self customCardXML:QRCODE(model.nickName) Name:@"nikename" withXMPPvCardTemp:temp];}
        if (model.birthday.length!=0) {
            [self customCardXML:QRCODE(model.birthday) Name:BYD withXMPPvCardTemp:temp];}
        if (model.sex.length!=0) {
            [self customCardXML:QRCODE(model.sex) Name:SEX withXMPPvCardTemp:temp];
        }
        if (model.phoneNum.length!=0) {
            [self customCardXML:QRCODE(model.phoneNum) Name:PHONENUM withXMPPvCardTemp:temp];
        }
        if (model.address.length!=0) {
        [self customCardXML:QRCODE(model.address) Name:ADDRESS withXMPPvCardTemp:temp];
        }
        if (model.qmd.length!=0) {
            [self customCardXML:QRCODE(model.qmd) Name:QMD
              withXMPPvCardTemp:temp];
        }
        [_xmppvCardTempModule updateMyvCardTemp:temp];
    }
    getMyCardcb(YES);
}
-(void)customCardXML:(NSString *)value Name:(NSString *)name withXMPPvCardTemp:(XMPPvCardTemp *)temp
{
    NSXMLElement *elem=[temp elementsForName:name][0];
    if (elem==nil) {
        elem=[NSXMLElement elementWithName:name];
        [temp addChild:elem];
    }
    [elem setStringValue:value];
}
#pragma mark 好友列表
-(NSArray *)friendsList:(void (^)(BOOL))cb
{
    friendsListcb=[cb copy];
    NSManagedObjectContext *context=[_xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSString *currentJid=[_userDefaults objectForKey:MYJID];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"streamBareJidStr==%@",currentJid];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];//摔选条件
    NSError *error=nil;
    NSArray *friends=[context executeFetchRequest:request error:&error];
    NSMutableArray*guanzhu=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*beiguanzhu=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*duifang=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*haoyou=[NSMutableArray arrayWithCapacity:0];
    for (XMPPUserCoreDataStorageObject *object in friends) {
        if ([object.subscription isEqualToString:@"to"]) {
            [guanzhu addObject:object];
        }
        else if([object.subscription isEqualToString:@"from"])
        {
            [beiguanzhu addObject:object];
        }
        else if([object.subscription isEqualToString:@"none"])
        {
            [duifang addObject:object];
        }
        else if ([object.subscription isEqualToString:@"both"])
        {
            [haoyou addObject:object];
        }
    }
    NSArray *list=@[haoyou,guanzhu,beiguanzhu,duifang];
    return  list;
    friendsListcb(YES);
}
-(BOOL)isFriend:(NSString *)jid
{
    NSManagedObjectContext *context=[_xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSString *currentJid=[_userDefaults objectForKey:MYJID];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"streamBareJidStr==%@",currentJid];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];//摔选条件
    NSError *error=nil;
    NSArray *friends=[context executeFetchRequest:request error:&error];
    for (XMPPUserCoreDataStorageObject *object in friends) {
        if ([object.jidStr isEqualToString:jid]) {
            return YES;
        }
    }
    return NO;
}
-(UIImage *)avatarForUser:(XMPPUserCoreDataStorageObject*)user
{
    UIImage *photo;
    if (user.photo) {
        photo=user.photo;
    }
    else
    {
        NSData *photoData=[_xmppvCardAvatarModule photoDataForJID:user.jid];
        XMPPvCardTemp *myVcard1=[_xmppvCardTempModule vCardTempForJID:user.jid shouldFetch:YES];
        if (photoData!=nil) {
            photo=[UIImage imageWithData:[myVcard1 photo]];
        }
        else
        {
            photo=[UIImage imageNamed:@"IMG_1473.JPG"];
        }
            }
    return photo;
}
-(void)friendvCard:(NSString *)jid completion:(void (^)(BOOL, XMPPvCardTemp *))cb
{
    friendvCardcb=[cb copy];
    //XMPPvCardTemp *temp=[_xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithUser:jid domain:IP resource:RESOURCE] shouldFetch:YES];
    if (jid==nil) {
        jid=_chatPerson;
    }
    XMPPvCardTemp *temp=[_xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:jid] shouldFetch:YES];
    if (temp) {
        friendvCardcb(YES,temp);
    }
    else {
        friendvCardcb(NO,temp);
    }
}
#pragma 添加好友
-(void)addFriend:(NSString *)username withMessage:(NSString *)message
{
    if (message) {
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:username domain:IP resource:RESOURCE]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];
        [_xmppStream sendElement:mes];
    }
    [_xmppRoster subscribePresenceToUser:[XMPPJID jidWithUser:username domain:IP resource:RESOURCE]];
}
#pragma mark 删除好友
-(void)removeFriend:(NSString *)username
{
    [_xmppRoster removeUser:[XMPPJID jidWithString:username resource:RESOURCE]];
}
#pragma mark 确定聊天人
-(void)valuationChatPersonName:(NSString *)name IsPush:(BOOL)isPush MessageBlock:(void (^)(Manage *))a
{
    valuationChatPersoncb=[a copy];
    if (isPush) {
        _chatPerson=name;
    }else
    {
        _chatPerson=@"none";
    }
}
#pragma mark 聊天记录
-(NSArray *)messageRecord
{
    NSManagedObjectContext *context=[_xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    if ([_chatPerson isEqualToString:@"none"]) {
        return nil;
    }
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bareJidStr==%@",_chatPerson];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *messages=[context executeFetchRequest:request error:&error];
    return messages;
}
-(void)getMyVCard:(void (^)(BOOL, XMPPvCardTemp *))cb
{
    getMyVCardcb=[cb copy];
    XMPPvCardTemp *temp=[_xmppvCardTempModule myvCardTemp];
    if (temp) {
        if (getMyVCardcb) {
            getMyVCardcb(YES,temp);
        }
    }
}
@end
