//
//  registerModel.h
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface registerModel : NSObject
@property(nonatomic,copy)NSString*userName;
@property(nonatomic,copy)NSString*passWord;
@property(nonatomic,copy)NSString*nickName;
@property(nonatomic,copy)NSString*birthday;
@property(nonatomic,copy)NSString*sex;
@property(nonatomic,copy)NSString*phoneNum;
@property(nonatomic,copy)NSString*qmd;
@property(nonatomic,copy)NSString*address;
@property(nonatomic,retain)UIImage*headerImage;
+(id)shareManager;
@end
