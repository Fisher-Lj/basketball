//
//  chatModel.h
//  basketball
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatModel : NSObject
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *jid;
@property(nonatomic,copy)NSString *isSelf;
@property(nonatomic,assign)NSDate *date;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,retain)UIImage *headimage;
@property(nonatomic,retain)NSString *nickname;
@end
