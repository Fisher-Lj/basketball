//
//  loginViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "loginViewController.h"
#import "registerViewController.h"
#import "QFXMPPManager.h"
#import "rootViewController.h"
#import "LJUIControl.h"
@interface loginViewController ()

@end

@implementation loginViewController
{
    MBProgressHUD *_hud;
    NSUserDefaults *_userDefaults;
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
    _userDefaults=[NSUserDefaults standardUserDefaults];
    self.userName.text=@"jiange";
    self.passWord.secureTextEntry=YES;
    self.passWord.text=@"123456";
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
- (IBAction)onLoginClick:(id)sender {
    if (self.userName.text.length>0&&self.passWord.text.length>0) {
    NSString *userName=[NSString stringWithFormat:@"%@%@",self.userName.text,HOSTNAME];
        [_userDefaults setObject:userName forKey:MYJID];
        [_userDefaults setObject:_passWord.text forKey:PASSWORD];
        [_userDefaults synchronize];
    _hud=[LJUIControl createProgerssHUD:@"登录中" withView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
        NSThread *currentThread = [NSThread currentThread];
        NSLog(@"currentThread1: %p", currentThread);
    __weak typeof(self) weakSelf = self;
    [[QFXMPPManager shareInstance]loginUser:^(BOOL ret){
        if (ret==YES) {
            NSThread *currentThread = [NSThread currentThread];
             NSLog(@"currentThread2: %p", currentThread);
            [_hud removeFromSuperview];
            rootViewController *rvc=[[rootViewController alloc]init];
            UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:rvc];
            NSString *path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[[NSUserDefaults standardUserDefaults] objectForKey:THEME]];
            [[NSUserDefaults standardUserDefaults] setObject:@"islogin" forKey:ISLOGIN];
            [navc.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_bg.png",path]] forBarMetrics:UIBarMetricsDefault];
            [weakSelf presentViewController:navc animated:YES completion:nil];
        }
        else{
            [_hud removeFromSuperview];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不存在或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }];}
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写用户名和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)onRegiserClick:(id)sender {
    registerViewController *rvc=[[registerViewController alloc]init];
    UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:rvc];
    [self presentViewController:navc animated:YES completion:nil];
}

@end
