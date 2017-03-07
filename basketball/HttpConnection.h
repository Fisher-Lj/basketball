//
//  HttpConnection.h
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HttpConnection;
@protocol httpConnectionDelegate <NSObject>

-(void)requestFinished:(HttpConnection *)httpConnection;
-(void)requestFailed:(HttpConnection *)httpConnection;

@end
@interface HttpConnection : NSObject<NSURLConnectionDataDelegate>
@property(nonatomic,retain)NSMutableData*data;
@property(nonatomic,retain)NSError *error;
-(id)initWithUrl:(NSString *)url andDelegate:(id<httpConnectionDelegate>)delegate;

@end
