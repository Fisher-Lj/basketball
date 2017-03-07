//
//  BodyViewController.m
//  basketball
//
//  Created by qianfeng on 15/5/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BodyViewController.h"
#import "QFXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "registerModel.h"
#import "MBProgressHUD.h"
@interface BodyViewController ()

@end

@implementation BodyViewController
{
    QFXMPPManager *_xmppManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _xmppManager=[QFXMPPManager shareInstance];
    [self getMyCard];
}
-(void)getMyCard
{
[_xmppManager getMyVCard:^(BOOL ret, XMPPvCardTemp *temp) {
    if (temp) {
        if (temp) {
            if (temp.photo) {
                _headImage.image=[UIImage imageWithData:temp.photo];
            }
            if (temp.nickname) {
                _username.text=temp.nickname;
            }
            if([temp elementForName:QMD]){
                _qmd.text=[[temp elementForName:QMD]stringValue];
            }
            if ([temp elementForName:PHONENUM]) {
                _phoneNum.text=[[temp elementForName:PHONENUM]stringValue];
            }
        }
    }
}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickUp:(id)sender {
    registerModel *model=[registerModel shareManager];
    model.address=_email.text;
    model.nickName=_username.text;
    model.phoneNum=_phoneNum.text;
    model.qmd=_qmd.text;
    [_xmppManager getMyCard:^(BOOL ret) {
        MBProgressHUD *_hud=[[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode=MBProgressHUDModeText;
        _hud.labelText=@"修改成功";
        [_hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
