//
//  AppDelegate.m
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "loginViewController.h"
#import "rootViewController.h"
#import "ZipArchive.h"
@implementation AppDelegate
{
    UINavigationController *_navc;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //进入程序，统一修改的地方
    //设置cell为半透明色
    [[UITableViewCell appearance]setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]];
    //设置tableView为透明色
    [[UITableView appearance]setBackgroundColor:[UIColor clearColor]];
    
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheme) name:THEME object:nil];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if ([user objectForKey:ISLOGIN]) {
        rootViewController* rvc=[[rootViewController alloc]init];
        NSString *path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
        _navc=[[UINavigationController alloc]initWithRootViewController:rvc];
//        [_navc.navigationBar setBarStyle:UIBarStyleDefault];
//        [_navc.navigationBar setBackgroundColor:[UIColor redColor]];
//        _navc.navigationBar.barTintColor=[UIColor blueColor];
//        _navc.navigationBar.translucent=NO;
//        [_navc.navigationBar setBarStyle:UIBarStyleBlack];
                [_navc.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_bg.png",path]] forBarMetrics:UIBarMetricsDefault];
        _navc.automaticallyAdjustsScrollViewInsets=NO;
        self.window.rootViewController=_navc;
    }
    else{
    loginViewController *rvc=[[loginViewController alloc]init];
        UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:rvc];
        self.window.rootViewController=navc   ;}
    //第一次安装时需要把主题包压缩到沙盒目录中，但是需要注意的是不要放在Documents中，因为这样苹果审核无法通过，根据苹果审核指南，你需要存储在lib文件夹下，在lib文件夹下我们需要创建一个文件夹才可以,我们解压缩的时候，解压缩会自动帮我们创建一个文件夹
    NSString*first=[user objectForKey:@"appfirst"];
    if (first==nil) {
        //程序第一次进入，我们需要把主题包压缩到沙盒目录中，但是需要注意的是不要放在Documents中，因为这样苹果审核无法通过，根据苹果审核指南，你需要存储在lib文件夹下，在lib文件夹下我们需要创建一个文件夹才可以,我们解压缩的时候，解压缩会自动帮我们创建一个文件夹
        NSString*filePath=[[NSBundle mainBundle]pathForResource:@"com" ofType:@"zip"];
        NSData*data=[NSData dataWithContentsOfFile:filePath];
        //把com.zip文件夹写入到lib文件夹下
        [data writeToFile:[NSString stringWithFormat:@"%@com.zip",LIBPATH] atomically:YES];
        
        //解压缩
        ZipArchive*zip=[[ZipArchive alloc]init];
        //这里绿色简约是解压缩后的文件夹名称
        NSString*unZipPath=[NSString stringWithFormat:@"%@绿色简约",LIBPATH];
        //打开文件
        [zip UnzipOpenFile:[NSString stringWithFormat:@"%@com.zip",LIBPATH]];
        //解压缩到指定路径
        [zip UnzipFileTo:unZipPath overWrite:YES];
        //关闭解压缩  需要注意的是只有执行关闭的时候，才能真正执行解压缩
        [zip UnzipCloseFile];
        
        //记录当前主题
        [user setObject:@"绿色简约" forKey:THEME];
        [user synchronize];
        //appfirst这个值可以是任意值，只是记录一下，表示程序不在是第一次进入了
        [user setObject:@"appfirst" forKey:@"appfirst"];
        [user synchronize];
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)changeTheme
{
 NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    [_navc.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_bg.png",path]] forBarMetrics:UIBarMetricsDefault];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
