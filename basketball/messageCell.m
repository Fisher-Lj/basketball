//
//  messageCell.m
//  basketball
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "messageCell.h"
#import "LJUIControl.h"
#import "Photo.h"
#import "StickerImageView.h"
#import "FriendvCardViewController.h"
@implementation messageCell
{
    NSString *_message;
    NSString *_path;
    UIImageView *_leftHeaderImageView;
    UIImageView *_rightHeaderImageView;
    UIImageView *_leftBubbleImageView;
    UIImageView *_rightBubbleImageView;
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UIButton *_leftVoiceButton;
    UIButton *_rightVoiceButton;
    StickerImageView *_rightBigImageView;
    StickerImageView *_leftBigImageView;
    UIViewController *_viewController;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withViewController:(UIViewController *)viewConctroller
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewController=viewConctroller;
        // Initialization code
        [self customUI];
    }
    return self;
}
-(void)customUI
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *theme=[user objectForKey:THEME];
    _path=[NSString stringWithFormat:@"%@%@/",LIBPATH,theme];
    _leftHeaderImageView=[LJUIControl createImageViewWithFrame:CGRectMake(10, 5, 30, 30) imageName:nil];
    _leftHeaderImageView.layer.cornerRadius=15;
    _leftHeaderImageView.layer.masksToBounds=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick)];
    tap.delegate=self;
    [_leftHeaderImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_leftHeaderImageView];
    //左气泡
    _leftBubbleImageView=[LJUIControl createImageViewWithFrame:CGRectZero imageName:nil];
    UIImage *leftimage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_recive_nor.png",_path]];
    //leftimage=[UIImage imageWithCGImage:leftimage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];//scale   放大倍数  第二个参数  图像翻转
    leftimage=[leftimage stretchableImageWithLeftCapWidth:40 topCapHeight:28];
    _leftBubbleImageView.image=leftimage;
    [self.contentView addSubview:_leftBubbleImageView];
    //左内容
    _leftLabel=[LJUIControl createLabelWithFrame:CGRectZero Font:14 Text:nil];
    [_leftBubbleImageView addSubview:_leftLabel];
    //左图片
    _leftImageView=[LJUIControl createImageViewWithFrame:CGRectZero imageName:nil];
    [_leftBubbleImageView addSubview:_leftImageView];
    //左语音
    _leftVoiceButton=[LJUIControl createButtonWithFrame:CGRectMake(20, 20, 30, 30) imageName:nil title:nil target:self action:@selector(voiceButtonClick)];
    UIImage *leftVoiceImage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bottom_voice_nor.png",_path]];
    [_leftVoiceButton setImage:leftVoiceImage forState:UIControlStateNormal];
    [_leftBubbleImageView addSubview:_leftVoiceButton];
    //左大表情
    _leftBigImageView=[[StickerImageView alloc]initWithFrame:CGRectMake(20, 20, 160, 160)];
    [_leftBubbleImageView addSubview:_leftBigImageView];
    int x=[UIScreen mainScreen].bounds.size.width;
    _rightHeaderImageView=[LJUIControl createImageViewWithFrame:CGRectMake(x-40, 5, 30, 30) imageName:nil];
    _rightHeaderImageView.layer.cornerRadius=15;
    _rightHeaderImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:_rightHeaderImageView];
    //左气泡
    _rightBubbleImageView=[LJUIControl createImageViewWithFrame:CGRectZero imageName:nil];
    UIImage *rightimage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_send_nor.png",_path]];
    //rightimage=[UIImage imageWithCGImage:rightimage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];//scale   放大倍数  第二个参数  图像翻转
    rightimage=[rightimage stretchableImageWithLeftCapWidth:40 topCapHeight:28];
    _rightBubbleImageView.image=rightimage;
    [self.contentView addSubview:_rightBubbleImageView];

    _rightLabel=[LJUIControl createLabelWithFrame:CGRectZero Font:14 Text:nil];
    [_rightBubbleImageView addSubview:_rightLabel];
    
    _rightImageView=[LJUIControl createImageViewWithFrame:CGRectZero imageName:nil];
    [_rightBubbleImageView addSubview:_rightImageView];
    
    _rightVoiceButton=[LJUIControl createButtonWithFrame:CGRectMake(20, 20, 30, 30) imageName:nil title:nil target:self action:@selector(voiceButtonClick)];
    UIImage *rightVoiceImage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bottom_voice_nor.png",_path]];
    [_rightVoiceButton setImage:rightVoiceImage forState:UIControlStateNormal];
    [_rightBubbleImageView addSubview:_rightVoiceButton];
    _rightBigImageView=[[StickerImageView alloc]initWithFrame:CGRectMake(20, 20, 160, 160)];
    [_rightBubbleImageView addSubview:_rightBigImageView];
}
-(void)onTapClick
{
    FriendvCardViewController *fvc=[[FriendvCardViewController alloc]init];
    
    [_viewController.navigationController pushViewController:fvc animated:YES];

}
-(void)voiceButtonClick{

}
-(void)customCell:(XMPPMessageArchiving_Message_CoreDataObject *)object
        leftImage:(UIImage *)leftImage right:(UIImage *)rightImage
{
    NSLog(@"%@",object.outgoing);
    _rightHeaderImageView.image=rightImage;
    _leftHeaderImageView.image=leftImage;
    NSString *str=object.body;
    if (str.length>3) {
        _message=[str substringFromIndex:3];
    }
    int x=[UIScreen mainScreen].bounds.size.width;
        if ([object isOutgoing]) {
            //自己fsdf
            _rightHeaderImageView.hidden=NO;
            _rightBubbleImageView.hidden=NO;
            _leftHeaderImageView.hidden=YES;
            _leftBubbleImageView.hidden=YES;
             if([str hasPrefix:MESSAGE_IMAGESTR])
            {
                _rightImageView.hidden=NO;
                _rightVoiceButton.hidden=YES;
                _rightBigImageView.hidden=YES;
                _rightLabel.hidden=YES;
                UIImage *image=[Photo string2Image:_message];
                float width=image.size.width>160?160:image.size.width;
                float height=image.size.height>160?160:image.size.height;
                NSLog(@"%f",height);
                _rightImageView.frame=CGRectMake(20, 15, width, height);
                _rightBubbleImageView.frame=CGRectMake(x-50-width-40, 5, width+37, height+30);
                _rightImageView.image=image;
            }
            else if([str hasPrefix:MESSAGE_BIGIMAGESTR])
            {
                _rightImageView.hidden=YES;
                _rightVoiceButton.hidden=YES;
                _rightLabel.hidden=YES;
                _rightBigImageView.hidden=NO;
                _rightBigImageView.sticker=[StickerInfo stickerWithID:_message];
                _rightBubbleImageView.frame=CGRectMake(x-50-200, 5, 200, 200);
            }
            else if([str hasPrefix:MESSAGE_VOICE])
            {
                _rightImageView.hidden=YES;
                _rightVoiceButton.hidden=NO;
                _rightLabel.hidden=YES;
                _rightBubbleImageView.frame=CGRectMake(x-50-70, 5, 70, 70);
            }
           else  if([str hasPrefix:MESSAGE_STR]){
                _rightBigImageView.hidden=YES;
                _rightVoiceButton.hidden=YES;
                _rightImageView.hidden=YES;
                _rightLabel.hidden=NO;
                CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000)];
                _rightLabel.frame=CGRectMake(20, 15, size.width, size.height);
                _rightLabel.text=_message;
                _rightBubbleImageView.frame=CGRectMake(x-50-size.width-40, 5, size.width+30, size.height+30);
            }
            else
            {
                _rightBigImageView.hidden=YES;
                _rightVoiceButton.hidden=YES;
                _rightImageView.hidden=YES;
                _rightLabel.hidden=NO;
                CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000)];
                _rightLabel.frame=CGRectMake(20, 15, size.width, size.height);
                _rightLabel.text=str;
                _rightBubbleImageView.frame=CGRectMake(x-50-size.width-40, 5, size.width+30, size.height+30);
            }
        }
        else{
            _rightHeaderImageView.hidden=YES;
            _rightBubbleImageView.hidden=YES;
            _leftHeaderImageView.hidden=NO;
            _leftBubbleImageView.hidden=NO;
            if([str hasPrefix:MESSAGE_IMAGESTR])
            {
                _leftLabel.hidden=YES;
                _leftBigImageView.hidden=YES;
                _leftImageView.hidden=NO;
                _leftVoiceButton.hidden=YES;
                
                UIImage*image=[Photo string2Image:_message];
                float width=image.size.width>160?160:image.size.width;
                float height=image.size.height>160?160:image.size.height;
                _leftImageView.frame=CGRectMake(20, 15, width, height);
                _leftBubbleImageView.frame=CGRectMake(50,5, width+30, height+30);
                _leftImageView.image=image;
            }
            else if([str hasPrefix:MESSAGE_BIGIMAGESTR])
            {
                _leftLabel.hidden=YES;
                _leftBigImageView.hidden=NO;
                _leftImageView.hidden=YES;
                _leftVoiceButton.hidden=YES;
                _leftBigImageView.sticker=[StickerInfo stickerWithID:_message];
                _leftBubbleImageView.frame=CGRectMake(50, 5, 200, 200);
            
            }
            else if ([str hasPrefix:MESSAGE_VOICE])
            {
                _leftLabel.hidden=YES;
                _leftBigImageView.hidden=YES;
                _leftImageView.hidden=YES;
                _leftVoiceButton.hidden=NO;
                _leftBubbleImageView.frame=CGRectMake(50, 5, 70, 70);
            }
            else  if([str hasPrefix:MESSAGE_STR]){
                _leftLabel.hidden=NO;
                _leftBigImageView.hidden=YES;
                _leftImageView.hidden=YES;
                _leftVoiceButton.hidden=YES;
                //计算文字大小
                CGSize size=[_message sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000)];
                
                _leftLabel.frame=CGRectMake(20, 15, size.width, size.height);
                _leftBubbleImageView.frame=CGRectMake(50, 5, size.width+40, size.height+30);
                _leftLabel.text=_message;
            }
            else {
                _leftLabel.hidden=NO;
                _leftBigImageView.hidden=YES;
                _leftImageView.hidden=YES;
                _leftVoiceButton.hidden=YES;
                //计算文字大小
                CGSize size=[str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 1000)];
                
                _leftLabel.frame=CGRectMake(20, 15, size.width, size.height);
                _leftBubbleImageView.frame=CGRectMake(50, 5, size.width+40, size.height+30);
                _leftLabel.text=str;
            }
            
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
