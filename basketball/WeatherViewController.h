//
//  WeatherViewController.h
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpConnection.h"
@interface WeatherViewController : UIViewController<httpConnectionDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label31;
@property (weak, nonatomic) IBOutlet UILabel *label32;
@property (weak, nonatomic) IBOutlet UILabel *label33;
@property (weak, nonatomic) IBOutlet UILabel *label41;
@property (weak, nonatomic) IBOutlet UILabel *label42;
@property (weak, nonatomic) IBOutlet UILabel *label43;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)onBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageview4;
- (IBAction)onDeleteClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label23;

@property (weak, nonatomic) IBOutlet UILabel *label21;

@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UIButton *addCity;
@property (weak, nonatomic) IBOutlet UIScrollView *_scroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *delCity;

@end
