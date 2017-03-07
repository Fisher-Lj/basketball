//
//  LJToolbAR.m
//  basketball
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LJToolbAR.h"
#import "Photo.h"
#import "LJUIControl.h"
#import "ZCChatAVAdioPlay.h"
@implementation LJToolbAR

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//读出表情的文件
-(NSArray *)weimiEmojis
{
    NSMutableArray *emojis=[NSMutableArray array];
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"emojo" ofType:@"plist"];
    NSArray *arr=[NSArray arrayWithContentsOfFile:plistPath];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *dic=[arr objectAtIndex:i];
        EmojiInfo *emoji=[[EmojiInfo alloc]init];
        emoji.emojiValue=[dic objectForKey:@"key"];
        emoji.emojiThumbName=[dic objectForKey:@"picture"];
        [emojis addObject:emoji];
    }
    return emojis;
}
-(void)themeNotification{
}
-(UIImage*)imageConfig:(NSString*)pathName{
    
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.path,pathName]];
}
- (id)initWithFrame:(CGRect)frame voice:(UIButton *)voice ViewController:(UIViewController *)vc Block:(void (^)(NSString*,NSString*))cb
{
    blockcb=[cb copy];
    NSLog(@"%f,%f,%f,%f",vc.view.bounds.size.height,vc.view.bounds.size.width,vc.view.bounds.origin.x,vc.view.bounds.origin.y);
    self = [super initWithFrame:CGRectMake(0, vc.view.bounds.size.height-toolBarHeight, vc.view.bounds.size.width, toolBarHeight)];
    if (self) {
        keyboardIsShow=NO;
        self.vc=vc;
        self.path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[[NSUserDefaults standardUserDefaults] objectForKey:THEME]];
        //配置音频按钮
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 12, 210, 30)];
        imageView.image=[self imageConfig:@"chat_bottom_textfield@2x.png"];
        imageView.userInteractionEnabled=YES;
        imageView.tag=3981;
        imageView.hidden=YES;
        [self addSubview:imageView];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, -7, 210, 45)];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:15];
        label.text=@"按住说话";
        label.textColor=[UIColor blueColor];
        label.tag=98;
        [imageView  addSubview:label];
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [imageView addGestureRecognizer:longPress];
            
            
        }else {
        }
          
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
        [self setBackgroundImage:[[self imageConfig:@"chat_bottom_bg@2x.png"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
        //设置阴影
        //[self setShadowImage:[self imageConfig:@"chat_bottom_shadow@2x.png"] forToolbarPosition:UIBarPositionAny];
        [self setBarStyle:UIBarStyleBlack];
        
        //可以自适应高度的文本输入框
        textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 12, 210,45)];
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        [textView.internalTextView setReturnKeyType:UIReturnKeySend];
        textView.delegate = self;
        textView.tag=4798;
        textView.font=[UIFont systemFontOfSize:15];
        textView.autoresizingMask= UIViewAutoresizingNone;
        textView.maximumNumberOfLines=5;
        textView.internalTextView.autocapitalizationType=UITextAutocapitalizationTypeNone ;
        //chat_bottom_textfield@2x.png
        textView.textViewBackgroundImage.image=[self imageConfig:@"chat_bottom_textfield@2x.png"];
        [self addSubview:textView];
        //音频按钮
        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_voice_nor@2x.png"] forState:UIControlStateNormal];
        [voiceButton addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
        voiceButton.frame = CGRectMake(5,self.bounds.size.height-38.0f,buttonWh+2,buttonWh+2);
        [self addSubview:voiceButton];
        
        //表情按钮
        faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
        faceButton.tag=6590;
        [faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        faceButton.frame = CGRectMake(self.bounds.size.width - 70.0f,self.bounds.size.height-38.0f,buttonWh,buttonWh);
        [self addSubview:faceButton];
        
        //表情按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // [sendButton setTitle:@"图片" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[self imageConfig:@"chat_bottom_up_nor@2x.png"] forState:UIControlStateNormal];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame = CGRectMake(self.bounds.size.width - 40.0f,self.bounds.size.height-38.0f,buttonWh+4,buttonWh);
        [self addSubview:sendButton];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //创建表情SDK
        //初始化
        [StickerConfig registerApp:@"45309e3410d69d7d" withSecret:@"534f62d20a540a95e2456aea9b9adbfc"];
        
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObjectsFromArray:[self weimiEmojis]];
        [arr addObjectsFromArray:[EmojiInfo defualtEmojis]];
        stickerInputView = [[StickerInputView alloc] initWithEmoji:arr] ;
        stickerInputView.delegate = self;
    
    }
    return self;
}
-(void)voiceChange
{
    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        if (!isOpenVoide) {
            UIImageView *imageView=(UIImageView *)[self viewWithTag:3981];
            [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
            imageView.hidden=NO;
            textView.hidden=YES;
            [self dismissKeyBoard];
        }
        else
        {
            UIImageView *imageView=(UIImageView *)[self viewWithTag:3981];
            imageView.hidden=YES;
        [voiceButton setBackgroundImage:[self imageConfig:@"chat_bottom_voice_nor@2x.png"] forState:UIControlStateNormal];
            textView.hidden=NO;
        }
       
    }else {
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前麦克风不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
    }
    isOpenVoide=!isOpenVoide;
}
-(void)longPress:(UILongPressGestureRecognizer*)sender
{
    if (sender.state==UIGestureRecognizerStateBegan) {
        UILabel *label=(UILabel*)[sender.view viewWithTag:98];
        label.text=@"松开发送";
        label.textColor=[UIColor redColor];
        [[ZCChatAVAdioPlay sharedInstance]startRecording];
    }
    if (sender.state==UIGestureRecognizerStateEnded) {
        UILabel *label=(UILabel*)[sender.view viewWithTag:98];
        label.text=@"按住说话";
        label.textColor=[UIColor blueColor];
        [[ZCChatAVAdioPlay sharedInstance]endRecordingWithBlock:^(NSString *message) {
            blockcb(MESSAGE_VOICE,message);
        }];
    }
}
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
    if (expandingTextView.text.length>2) {
        NSLog(@"最后输入的是表情%@",[textView.text substringFromIndex:textView.text.length-2]);
        textView.internalTextView.contentOffset=CGPointMake(0,textView.internalTextView.contentSize.height-textView.internalTextView.frame.size.height );
    }
    
}
//清空输入框里的内容
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    if (textView.text.length>0) {
        //block  穿过去   发消息
        blockcb(MESSAGE_STR,textView.text);
        [textView clearText];
    }
    return YES;
}
#pragma mark 选择相册相机
-(void)sendAction{
    [self dismissKeyBoard];
    //发送图片
    LXActivity*lx=[[LXActivity alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" ShareButtonTitles:@[@"相机",@"相册"] withShareButtonImagesName:@[@"icon_code.png",@"icon_phone.png"]];
    // [lx showInView:self.vc.view];
    [self.vc.view addSubview:lx];
    
}
#pragma mark 按钮点击事件
-(void)disFaceKeyboard
{
    //判断输入框在原位置
    if (self.frame.origin.y== self.vc.view.bounds.size.height - toolBarHeight&&self.frame.size.height==toolBarHeight) {
        //在下面时候上来
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(0, self.vc.view.frame.size.height-keyboardHeight-toolBarHeight,  self.vc.view.bounds.size.width,toolBarHeight);
        }];
        [UIView animateWithDuration:Time animations:^{
            [stickerInputView showInView:self.vc.view emojiReceiver:textView.internalTextView viewController:self.vc animated:YES];
        }];
        [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
        return;
    }
//键盘没显示的时候
    if (!keyboardIsShow) {
        //如果键盘没有显示，把表情隐藏掉
        [UIView animateWithDuration:Time animations:^{
            
            [stickerInputView showInView:self.vc.view emojiReceiver:textView.internalTextView viewController:self.vc animated:YES];
        }];
        [textView becomeFirstResponder];
        
    }else{
        [textView resignFirstResponder];
        self.frame = CGRectMake(0, self.vc.view.frame.size.height-keyboardHeight-self.frame.size.height,  self.vc.view.bounds.size.width,self.frame.size.height);
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            [stickerInputView showInView:self.vc.view emojiReceiver:textView.internalTextView viewController:self.vc animated:YES];
        }];
        
    }
}
#pragma mark    LXActivity的代理方法
- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    NSLog(@"%d",(int)imageIndex);
    
    UIImagePickerController*picker=[[UIImagePickerController alloc]init];
    if (imageIndex) {
        BOOL isOpen=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (isOpen) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
    }
    picker.delegate=self;
    [self.vc presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //图片转文字
    NSString*str=[Photo image2String:image];
    blockcb(MESSAGE_IMAGESTR,str);
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyBoard{
    //键盘消失的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.frame = CGRectMake(0, self.vc.view.frame.size.height-self.frame.size.height,  self.vc.view.bounds.size.width,self.frame.size.height);
    }];
    
    [textView resignFirstResponder];
    [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
    
    [stickerInputView dismiss];
    keyboardIsShow=NO;
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame=[UIScreen mainScreen].bounds;
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (self.frame.size.height>45) {
            self.frame = CGRectMake(0, frame.size.height-keyBoardFrame.size.height-20-self.frame.size.height,  self.vc.view.bounds.size.width,self.frame.size.height);
        }else{
            self.frame = CGRectMake(0, frame.size.height-keyBoardFrame.size.height-45-64,  self.vc.view.bounds.size.width,toolBarHeight);
            NSLog(@"%f",keyBoardFrame.size.height);
            NSLog(@"%f",self.frame.origin.y);
        }
    }];
    [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_smile_nor@2x.png"] forState:UIControlStateNormal];
    keyboardIsShow=YES;
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    [faceButton setBackgroundImage:[self imageConfig:@"chat_bottom_keyboard_nor@2x.png"] forState:UIControlStateNormal];
    keyboardIsShow=NO;
}
-(void)stickerInputView:(StickerInputView *)inputView didSelectSticker:(StickerInfo *)stickerInfo
{
    blockcb(MESSAGE_BIGIMAGESTR,[stickerInfo stickerID]);
}
-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
