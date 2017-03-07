//
//  rootViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "rootViewController.h"
#import "WeatherViewController.h"
#import "locationViewController.h"
#import "LJUIControl.h"
#import "QFXMPPManager.h"
#import "FriendViewController.h"
#import "firstViewController.h"
#import "BasketballViewController.h"
#import "MyViewController.h"
@interface rootViewController ()<UIAlertViewDelegate>

@end

@implementation rootViewController
{
    NSString *_path;
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
	// Do any additional setup after loading the view.
    
    [self customTapBar];
    NSArray *arr1=@[@"firstViewController",@"FriendViewController",@"BasketballViewController",@"MyViewController"];

    NSMutableArray *arr=[NSMutableArray array];
    for (NSInteger i=0; i<4; i++) {
        Class class=NSClassFromString(arr1[i]);
        UIViewController *tvc=[[class alloc]init];
       // UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:tvc];
       // navc.navigationBarHidden=YES;
        [self.navigationController addChildViewController:tvc];
        [arr addObject:tvc];
    }
    self.viewControllers=arr;
    [self customTabBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTabBar) name:THEME object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTapBar) name:THEME object:nil];
}
-(void)customTabBar
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    _path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    NSArray *arr2=@[@"消息",@"通讯录",@"球场",@"我"];
    NSArray*selectImageName=@[@"tab_recent_press.png",@"tab_buddy_press.png",@"tab_qworld_press.png",@"tab_me_press.png"];
    NSArray*unSelectImageName=@[@"tab_recent_nor.png",@"tab_buddy_nor.png",@"tab_qworld_nor.png",@"tab_me_nor.png"];
    int i=0;
    for (UINavigationController *navc in self.viewControllers) {
        if (IOS7) {
            UIImage*selectImage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",_path,selectImageName[i]]];
            selectImage=[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            UIImage*unSelectImage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",_path,unSelectImageName[i]]];
            
            unSelectImage=[unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navc.tabBarItem=[[UITabBarItem alloc]initWithTitle:arr2[i] image:unSelectImage selectedImage:selectImage];
        }
        else{
    navc.tabBarItem=[[UITabBarItem alloc]initWithTitle:arr2[i] image:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",_path,unSelectImageName[i]]] selectedImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",_path,selectImageName[i]]]];
            }
        i++;
    }
    
   
    [self.tabBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/tabbar_bg.png",_path]]];
    //去掉阴影线
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
}
-(void)customTapBar
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(0, 0, 30, 30);
    [button2 setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_icon_add@2x.png",path]] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn2=[[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem=barBtn2;
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(0, 0, 30, 30);
    [button1 setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_icon_lbs@2x.png",path]] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(onBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem=barBtn1;
}
-(void)onBtn1Click:(UIButton *)sender
{
    locationViewController *lvc=[[locationViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:YES];
}
-(void)onAddClick
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请输入对方账号" message:Nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *text=(UITextField *)[alertView textFieldAtIndex:0];
        [[QFXMPPManager shareInstance]addFriend:text.text withMessage:Nil];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
