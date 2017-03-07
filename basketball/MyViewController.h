//
//  MyViewController.h
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "fatherViewController.h"

@interface MyViewController : fatherViewController
- (IBAction)onClickTheme:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
- (IBAction)onClickBack:(id)sender;



@end
