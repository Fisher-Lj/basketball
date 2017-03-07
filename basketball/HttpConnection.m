//
//  HttpConnection.m
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HttpConnection.h"

@implementation HttpConnection
{
    NSURLConnection*_connection;
    id<httpConnectionDelegate>_delegate;
}
-(id)initWithUrl:(NSString *)url andDelegate:(id<httpConnectionDelegate>)delegate
{
    self=[super init];
    if (self) {
        NSURL *url1=[NSURL URLWithString:url];
        _connection=[[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:url1] delegate:self];
        _delegate=delegate;
        _data=[[NSMutableData alloc]init];
        //NSLog(@"%@",_data);
    }
    return self;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (_delegate) {
        [_delegate requestFinished:self];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error=error;
    if (_delegate) {
        [_delegate requestFailed:self];
    }
}
@end
