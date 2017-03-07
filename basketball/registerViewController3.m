//
//  registerViewController3.m
//  basketball
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "registerViewController3.h"
#import "registerModel.h"
#import "QFXMPPManager.h"
#import "rootViewController.h"
@interface registerViewController3 ()<UIAlertViewDelegate>

@end

@implementation registerViewController3
{
    registerModel *_model;
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
    _model=[registerModel shareManager];
    NSString *str1=[NSString stringWithFormat:@"%ld",DATETIME];
    NSString *str=[NSString stringWithFormat:@"您的数字账号是%@，如果不满意请点击重置",str1];
    _model.userName=str1;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"数字账号" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"重置",@"确定", nil];
    alert.tag=1001;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{if(alertView.tag==1001){
    if (buttonIndex==0) {
        NSString *str1=[NSString stringWithFormat:@"%ld",DATETIME];
        NSString *str=[NSString stringWithFormat:@"您的数字账号是%@，如果不满意请点击重置",str1];
        _model.userName=str1;
        alertView.message=str;
    }}
    else if (alertView.tag==1003)
    {
        if (buttonIndex==0) {
            [self startRegister];
        }
    
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)onRsgiserClick:(id)sender {
    if (_password1.text.length>=8&&_password1.text.length<16&&[_password1.text isEqualToString:_password2.text]) {
        NSString *jid=[NSString stringWithFormat:@"%@%@",_username.text,HOSTNAME];
        _model.userName=jid;
        _model.passWord=_password1.text;
        [self startRegister];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码为8-16位密码或两次输入密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag=1002;
        [alert show];
    }
}
-(void)startRegister
{
    
    [[QFXMPPManager shareInstance]registerUser:_model.userName withPassword:_model.passWord completion:^(BOOL ret){
        if (ret==YES) {
            [[QFXMPPManager shareInstance]getMyCard:^(BOOL ret){
                if (ret==YES) {
                    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                    [user setObject:_model.userName forKey:MYJID];
                    [user setObject:_model.passWord forKey:PASSWORD];
                    [[QFXMPPManager shareInstance]loginUser:^(BOOL ret){
                        if (ret==YES) {
                            rootViewController *rvc=[[rootViewController alloc]init];
                            UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:rvc];
                            [self presentViewController:navc animated:YES completion:^{
                                [user setObject:ISLOGIN forKey:ISLOGIN];
                            }];
                        }
                        
                    }];
                }
            
            }];
        }
        else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败，换个账号试试？网络不好请点击重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试",@"取消",nil];
            alert.tag=1003;
            [alert show];
        }
    
    }];

}
@end
