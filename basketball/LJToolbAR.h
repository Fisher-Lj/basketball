//
//  LJToolbAR.h
//  basketball
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//
#define Time  0.25

#define  keyboardHeight 216
#define  toolBarHeight 45
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define  buttonWh 34
#import <UIKit/UIKit.h>
#import "UIExpandingTextView.h"
#import "StickerInputView.h"
#import "StickerImageView.h"
#import "EmojiInfo.h"
#import "StickerConfig.h"
#import "LXActivity.h"
@interface LJToolbAR : UIToolbar<UIExpandingTextViewDelegate,UIScrollViewDelegate,StickerInputViewDelegate,LXActivityDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIExpandingTextView *textView;
    UIButton *faceButton;
    UIButton *voiceButton;
    UIButton *sendButton;
    BOOL keyboardIsShow;
    BOOL isOpenVoide;
    StickerInputView *stickerInputView;//表情SDK输入界面
    void(^blockcb)(NSString *,NSString *);
}

@property(nonatomic,assign)UIViewController*vc;
@property(nonatomic,copy)NSString*path;
-(id)initWithFrame:(CGRect)frame voice:(UIButton*)voice ViewController:(UIViewController*)vc Block:(void(^)(NSString*,NSString*))cb;
-(void)dismissKeyBoard;
@end
