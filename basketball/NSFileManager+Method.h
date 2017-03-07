//
//  NSFileManager+Method.h
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Method)
-(BOOL)timeOutWithPath:(NSString *)path timeOut:(NSTimeInterval)time;
-(void)cacheCear;
@end
