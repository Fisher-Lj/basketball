//
//  RadarViewController.m
//  weichat_1418
//
//  Created by 逯常松 on 14-10-10.
//  Copyright (c) 2014年 changsong. All rights reserved.
//

#import "RadarViewController.h"
#import "LJUIControl.h"
@interface RadarViewController ()
{
//2个imageView
    UIImageView*bgImageView;
    UIImageView*radarImageView;
}
@end

@implementation RadarViewController

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
    [self createImageView];
    //[self createLeftNav];
    
    //发现对方需要使用iBeacon
    //获取账号
    NSString*userName=[[NSUserDefaults standardUserDefaults]objectForKey:MYJID];
    //需要数字账号
    //获取账号后开始分解，已知我们账号都是数字账号
    NSInteger num=[userName integerValue];
    //iBeacon 有主频和副频 值的范围不能超过65535
    //8000000
    
    int max=num/65535;
    int min=num%65535;
    //把主频和辅频发送出去即可
    
    //收到iBeacon 通过主频和副频还原回账号
    NSInteger num1=max*65535+min;
    NSString*userName1=[NSString stringWithFormat:@"%d",num1];
    //通过还原的账号，添加好友
    
    
    

    // Do any additional setup after loading the view.
}
-(void)leftNavClick{
    //删除动画 rotationAnimation的来源于添加时候设置的key，也可以设置删除全部的key  [radarImageView .layer removeAllAnimations];
    [radarImageView.layer removeAnimationForKey:@"rotationAnimation"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createImageView{
    int x=self.view.frame.size.width;
    bgImageView=[LJUIControl createImageViewWithFrame:CGRectMake(0, 0, x,x) imageName:@"radarBg.png"];
    CGPoint point=self.view.center;
    point=CGPointMake(point.x, point.y-40);
    bgImageView.center=point;
    [self.view addSubview:bgImageView];
    radarImageView=[LJUIControl createImageViewWithFrame:bgImageView.frame imageName:@"radarDiscoverLayer.png"];
    radarImageView.center=point;
    [self.view addSubview:radarImageView];
    

    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    //旋转次数
    rotationAnimation.repeatCount =10000;
    
    [radarImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
