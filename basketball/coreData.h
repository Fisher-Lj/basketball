//
//  coreData.h
//  basketball
//
//  Created by qianfeng on 15-4-20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "chatModel.h"
@interface coreData : NSObject
+(id)shareIntance;
-(void)insert:(chatModel*)model;
-(NSArray *)check:(NSString*)myjid with:(int)page;
-(void)delete:(id)sender;
-(void)update:(chatModel *)model;
@end
