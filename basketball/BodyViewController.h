//
//  BodyViewController.h
//  basketball
//
//  Created by qianfeng on 15/5/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "fatherViewController.h"

@interface BodyViewController : fatherViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *qmd;
- (IBAction)onClickUp:(id)sender;

@end
