//
//  themeManager.h
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"
@interface themeManager : NSObject

//下载方法的回调block
@property(nonatomic,copy)void(^downLoadBlock)(BOOL);
//所有已经下载过的主题
@property(nonatomic,strong)NSMutableArray*themeArray;


+(id)shareManager;
//下载方法
-(BOOL)DownLoadBlock:(NSDictionary*)dic block:(void(^)(BOOL))a;
@end
