//
//  httpDownLoad.h
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface httpDownLoad : NSObject
{
    void(^httpDownLoadcb)(BOOL,httpDownLoad *);

}
@property(nonatomic,copy)NSMutableData *data;
- (id)initWithUrl:(NSString *)url withBlock:(void(^)(BOOL,httpDownLoad *))a;
@end
