//
//  FriendvCardViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FriendvCardViewController.h"
#import "QFXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "messageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
@interface FriendvCardViewController ()

@end

@implementation FriendvCardViewController
{
    QFXMPPManager *_xmppManager;
    BOOL isFriend;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@""];
    _xmppManager=[QFXMPPManager shareInstance];
    if (self.dict) {
        [self customyaoyiyaoUI];
        isFriend=[_xmppManager isFriend:_dict[@"jid"]];
    }
    else {
        isFriend=YES;
        [self customUI];}
}
-(void)customyaoyiyaoUI
{
    NSString *str=_dict[@"nickName"];
    if (str.length!=0) {
        _nikeName.text=_dict[@"nickName"];
    }
    else {
        _nikeName.text=_dict[@"username"];
    }
    if (_dict[@"headImageURL"]) {
        [_headImage setImageWithURL:[NSURL URLWithString:_dict[@"headImageURL"]] placeholderImage:
        [UIImage imageNamed:@"ali00.png"]];
    }
    NSString *str1=_dict[@"address"];
    if (str1.length!=0) {
        _adress.text=_dict[@"address"];
    }
    NSString *str2=_dict[@"qmd"];
    if (str2.length!=0) {
        _qmd.text=_dict[@"qmd"];
    }
    if (!isFriend) {
        [_sendButton setTitle:@"加为好友" forState:UIControlStateNormal];
        _delButton.hidden=YES;
    }
    
}
-(void)customUI
{
[_xmppManager friendvCard:_jid completion:^(BOOL ret, XMPPvCardTemp *temp) {
    
    _headImage.image=[UIImage imageWithData:temp.photo];
    if (temp.nickname) {
        _nikeName.text=temp.nickname;
    }
    if (temp.addresses[0]) {
        _adress.text=[[temp elementForName:ADDRESS]stringValue];
    }
    if([temp elementForName:QMD]){
    _qmd.text=[[temp elementForName:QMD]stringValue];
    }
    if ([temp elementForName:PHONENUM]) {
    _phongNem.text=[[temp elementForName:PHONENUM]stringValue];
    }
}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendClick:(id)sender {
    if (isFriend) {
    messageViewController *mvc=[[messageViewController alloc]init];
        [self presentViewController:mvc  animated:YES completion:nil];}
    else {
        [_xmppManager addFriend:_dict[@"jid"] withMessage:nil];
        MBProgressHUD *_hud=[[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode=MBProgressHUDModeText;
        _hud.labelText=@"请求已发出";
        [self.view addSubview:_hud];
        [_hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [_hud removeFromSuperview];
        }];
         }
}

- (IBAction)onDeleteClick:(id)sender {
    [_xmppManager removeFriend:_jid];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
