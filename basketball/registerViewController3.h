//
//  registerViewController3.h
//  basketball
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController3 : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UITextField *password1;
- (IBAction)onRsgiserClick:(id)sender;

@end
