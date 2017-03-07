//
//  FriendCell.h
//  basketball
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;
@property (weak, nonatomic) IBOutlet UILabel *qmd;

@end
