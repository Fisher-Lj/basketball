//
//  loginViewController.h
//  basketball
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)onLoginClick:(id)sender;
- (IBAction)onRegiserClick:(id)sender;

@end
