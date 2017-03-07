//
//  weatherModel.h
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "commonModel.h"

@interface weatherModel : commonModel
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *temperature;
@property(nonatomic,copy)NSString *weather;
@property(nonatomic,copy)NSString *wind;
@property(nonatomic,copy)NSString *dayPictureUrl;
@property(nonatomic,copy)NSString *nightPictureUrl;

@end
