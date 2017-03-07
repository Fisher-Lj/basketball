//
//  fatherViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "fatherViewController.h"

@interface fatherViewController ()

@end

@implementation fatherViewController
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
    //没有navibar时    autorize＝w＋h；
    //self.navigationController.navigationBar.translucent =   YES;
    
    [self createNav];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createNav) name:THEME object:nil];
}
-(void)createNav
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    _path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    NSLog(@"%@",_path);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_bg.png",_path]] forBarMetrics:UIBarMetricsDefault];
    //修改背景色
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bg_default.jpg",_path]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
