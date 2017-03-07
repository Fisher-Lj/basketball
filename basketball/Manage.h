//
//  Manage.h
//  basketball
//
//  Created by qianfeng on 15-4-20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Manage : NSManagedObject
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *jid;
@property(nonatomic,copy)NSString *isSelf;
@property(nonatomic,assign)NSDate *date;
@property(nonatomic,copy)NSString *type;
@end
