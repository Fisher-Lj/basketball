//
//  httpDownLoad.m
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "httpDownLoad.h"
#import "MyMD5.h"
#import "NSFileManager+Method.h"
#import "AFNetworking.h"
@implementation httpDownLoad
{
    NSString *_path;
    
}
- (id)initWithUrl:(NSString *)url withBlock:(void(^)(BOOL,httpDownLoad *))a
{
    self = [super init];
    if (self) {
        httpDownLoadcb=[a copy];
        if (url==nil) {
            return self;}
        
            _path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[MyMD5 md5:url]];
        NSLog(@"dd%@",_path);
            NSFileManager *manager=[NSFileManager defaultManager];
            if ([manager fileExistsAtPath:_path]&&![manager timeOutWithPath:_path timeOut:60*60]) {
                _data=[NSData dataWithContentsOfFile:_path];
                httpDownLoadcb(YES,self);
            }
            else{
                [self requestDownLoad:url];
            }
            
        
    }
    return self;
}
-(void)requestDownLoad:(NSString *)strUrl
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        _data=[NSMutableData dataWithData:responseObject];
        [_data writeToFile:_path atomically:YES];
        httpDownLoadcb(YES,self);
    } failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
         [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
         UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的网络有问题，请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alertView show];
         if (httpDownLoadcb) {
             httpDownLoadcb(NO,self);
         }

     }];
}

@end
