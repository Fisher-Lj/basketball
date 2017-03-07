//
//  FriendvCardViewController.h
//  basketball
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "fatherViewController.h"

@interface FriendvCardViewController : fatherViewController

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *qmd;
@property (weak, nonatomic) IBOutlet UILabel *phongNem;
- (IBAction)onSendClick:(id)sender;
- (IBAction)onDeleteClick:(id)sender;
@property(nonatomic,copy)NSString *jid;
@property(nonatomic,retain)NSDictionary *dict;
@property(nonatomic,assign)BOOL isSelf;
@end
