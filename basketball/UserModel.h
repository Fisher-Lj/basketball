//
//  UserModel.h
//  basketball
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PROPERTY(s) @property(nonatomic,copy)NSString*s
@interface UserModel : NSObject
PROPERTY(jid);
PROPERTY(password);
PROPERTY(name);
PROPERTY(status);
@end
