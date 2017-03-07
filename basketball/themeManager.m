//
//  themeManager.m
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "themeManager.h"
#import "AFNetworking.h"
@implementation themeManager
{
}
static themeManager *manager=nil;
+(id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager=[[themeManager alloc]init];
    });
    return manager;
}
- (id)init
{
    self = [super init];
    if (self) {
        _themeArray=[NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@%@.plist",LIBPATH,THEME]];
        if (_themeArray==nil) {
            _themeArray=[NSMutableArray arrayWithCapacity:0];
        }
    }
    return self;
}
-(BOOL)DownLoadBlock:(NSDictionary *)dic block:(void (^)(BOOL))a
{
    self.downLoadBlock=a;
    //判断是否已经下载
    if ([self.themeArray containsObject:dic[@"name"]]) {
        //已经下载
        //name读取的是主题名
        NSLog(@"%@",LIBPATH);
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        [user setObject:dic[@"name"] forKey:THEME];
        [user synchronize];
        
        
        //解压缩完成后 发送通知，然后回调
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
        _downLoadBlock(YES);
        return YES;
    }
    
    //如果没有下载需要执行下载任务，并且在下载完成后，执行解压缩任务，保存主题名称
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dic[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data=[NSData dataWithData:responseObject];
        //保存数据
        [data writeToFile:[NSString stringWithFormat:@"%@com.zip",LIBPATH] atomically:YES];
        //执行解压缩
        ZipArchive*zip=[[ZipArchive alloc]init];
        [zip UnzipOpenFile:[NSString stringWithFormat:@"%@com.zip",LIBPATH]];
        
        NSLog(@"%@",dic);
        [zip UnzipFileTo:[NSString stringWithFormat:@"%@%@",LIBPATH,dic[@"name"]] overWrite:YES];
        [zip UnzipCloseFile];
        
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        [user setObject:dic[@"name"] forKey:THEME];
        [user synchronize];
        
        //解压缩完成后 发送通知，然后回调
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
        if (self.downLoadBlock) {
            self.downLoadBlock(YES);
        }
        
        //当下载成功需要更新本地已下载的目录
        [self.themeArray addObject:dic[@"name"]];
        //把数组写入文件内
        [self.themeArray writeToFile:[NSString stringWithFormat:@"%@%@.plist",LIBPATH,THEME] atomically:YES];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.downLoadBlock) {
            self.downLoadBlock(NO);
        }
    }];
    return NO;
}

@end
