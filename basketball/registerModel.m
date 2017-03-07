//
//  registerModel.m
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "registerModel.h"

@implementation registerModel
+(id)shareManager
{
    static id s;
    if (s==nil) {
        s=[[self alloc]init];
    }
    return s;
}
@end
