//
//  DEFINE.h
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#ifndef basketball_DEFINE_h
#define basketball_DEFINE_h

#define DATETIME (long)[[NSDate date]timeIntervalSince1970]-1404218190

#endif
#define RESOURCE @"IOS"
#define IP @"121.40.97.146"
#define ISLOGIN @"isLogin"
#define MYJID @"myjid"
#define PASSWORD @"password"
//个人名片
#define BYD @"birthday"
#define SEX @"SEX"
#define QMD @"QMD"
#define ADDRESS @"DQ"
#define PHONENUM @"phoneNum"
//消息类型
#define MESSAGE_STR @"[1]"
#define MESSAGE_VOICE @"[2]"
#define MESSAGE_IMAGESTR @"[3]"
#define MESSAGE_BIGIMAGESTR @"[4]"
//单聊和群聊
#define SOLECHAT @"[1]"
#define GROUPCHAT @"[2]"
//
#define QRCODE(str) [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define UNQRCODE(str)\
[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
