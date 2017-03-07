//
//  NSFileManager+Method.m
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NSFileManager+Method.h"

@implementation NSFileManager (Method)
-(BOOL)timeOutWithPath:(NSString *)path timeOut:(NSTimeInterval)time
{
    //传递进来是一个经过MD5加密过的文件名称，我们需要拼接路径
    NSString*_path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    //获得文件的详细信息
    NSDictionary*dic=[[NSFileManager defaultManager]attributesOfItemAtPath:_path error:nil];
    //获取文件创建的时间
    NSDate*createDate= [dic objectForKey:NSFileCreationDate];
    
    //获得当前的时间
    NSDate*date=[NSDate date];
    
    //时间进行差值比较
    NSTimeInterval isTime=[date timeIntervalSinceDate:createDate];
    
    if (isTime>time) {
        //过期
        return YES;
    }else{
        //没过期
        return NO;
        
    }
}
-(void)cacheCear{

    NSString *path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    NSArray *fileNameArr=[[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileNameArr) {
        [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@%@",path,fileName] error:nil];
    }

}
@end
