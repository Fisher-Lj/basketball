//
//  LJUIControl.h
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface LJUIControl : NSObject
#pragma mark --判断设备型号
+(NSString *)platFormString;
#pragma mark --创建label
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString *)text;
#pragma mark --创建button
+(UIButton *)createButtonWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;
#pragma mark --创建imageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;
+(float)isIOS7;
+(MBProgressHUD *)createProgerssHUD:(NSString *)text withView:(UIView *)view;
@end
