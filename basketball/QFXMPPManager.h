//
//  QFXMPPManager.h
//  basketball
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "chatModel.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "Manage.h"
#import "coreData.h"
typedef  enum
{
    kMessageText=1,
    kMessagePic=2,
    kMessageVoi=3
}MessageType;
@class XMPPMessage,XMPPRoster,XMPPRosterCoreDataStorage,XMPPvCardAvatarModule,XMPPvCardTempModule,XMPPvCardAvatarCoreDataStorageObject;
@interface QFXMPPManager : NSObject<XMPPStreamDelegate>
{
    XMPPStream *_xmppStream;
    XMPPReconnect *_xmppReconnect;
    XMPPRoster *_xmppRoster;
    XMPPRosterCoreDataStorage *_xmppRosterStorage;
    XMPPMessageArchivingCoreDataStorage *_xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *_xmppMessageArchivingModule;
    XMPPvCardTempModule *_xmppvCardTempModule;//与名片有关
    XMPPvCardAvatarModule *_xmppvCardAvatarModule;
    XMPPvCardCoreDataStorage *_xmppvCardStotage;
    UserModel *_currentUser;
    NSMutableArray *_allFriends;
    BOOL isLogin;
    NSUserDefaults *_userDefaults;
    NSString *_chatPerson;
//代码块变量
    void(^loginFinishedcb)(BOOL);
    void(^registerFinishedcb)(BOOL);
    void(^getAllFriendscb)(NSArray*);
    void(^getMessagecb)(chatModel*);
    void(^sendMessagecb)(BOOL);
    void(^getMyCardcb)(BOOL);
    void(^friendsListcb)(BOOL);
    void(^friendvCardcb)(BOOL,XMPPvCardTemp*);
    void(^valuationChatPersoncb)(Manage*);
    void (^getMyVCardcb)(BOOL,XMPPvCardTemp*);
}
@property(nonatomic,retain)NSMutableArray *subscribeArray;
@property(nonatomic,retain)NSMutableDictionary *weiduxiaoxi;
+(id)shareInstance;
-(void)loginUser:(void(^)(BOOL))cb;
-(void)registerUser:(NSString *)username withPassword:(NSString *)passWord completion:(void(^)(BOOL))cb;
-(void)getAllFriends:(void(^)(NSArray *))cb;
-(void)getMessage:(void(^)(chatModel *))cb;
-(void)sendMessage:(NSString *)message withType:(NSString *)type withTojid:(NSString *)jid completion:(void(^)(BOOL))cb;
-(void)getMyCard:(void(^)(BOOL))cb;
-(NSArray *)friendsList:(void(^)(BOOL))cb;
-(UIImage *)avatarForUser:(XMPPUserCoreDataStorageObject*)user;
-(void)friendvCard:(NSString *)jid completion:(void(^)(BOOL,XMPPvCardTemp*))cb;
-(void)addFriend:(NSString *)username withMessage:(NSString *)message;
-(void)removeFriend:(NSString *)username;
-(void)valuationChatPersonName:(NSString*)name IsPush:(BOOL)isPush MessageBlock:(void(^)(Manage*))a;
-(NSArray *)messageRecord;
-(void)getMyVCard:(void (^)(BOOL,XMPPvCardTemp*))cb;
-(void)agreeRequest:(NSString*)name;
-(void)reject:(NSString*)name;
-(BOOL)isFriend:(NSString *)jid;
-(void)disconnect;
@end
