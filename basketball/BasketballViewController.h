//
//  BasketballViewController.h
//  basketball
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "fatherViewController.h"

@interface BasketballViewController : fatherViewController
- (IBAction)onLeidaClick:(id)sender;
- (IBAction)onYaoyiyaoClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *onWeatherClick;
- (IBAction)onWeatherClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *onSAOYISAOClick;
- (IBAction)onSaoyisaoClick:(id)sender;

@end
