//
//  messageCell.h
//  basketball
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
@interface messageCell : UITableViewCell<UIGestureRecognizerDelegate>
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withViewController:(UIViewController *)viewConctroller;
-(void)customCell:(XMPPMessageArchiving_Message_CoreDataObject *)object
        leftImage:(UIImage *)leftImage right:(UIImage *)rightImage;
@end
