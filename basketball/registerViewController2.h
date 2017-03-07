//
//  registerViewController2.h
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController2 : UIViewController
- (IBAction)onBtnImageClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *onBtnImage;
@property (weak, nonatomic) IBOutlet UILabel *sexText;
@property (weak, nonatomic) IBOutlet UILabel *birthdayText;


@end
