//
//  MyViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyViewController.h"
#import "themeViewController.h"
#import "QFXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "FriendvCardViewController.h"
#import "loginViewController.h"
#import "BodyViewController.h"
@interface MyViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MyViewController
{
    QFXMPPManager *_xmppManager;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _xmppManager=[QFXMPPManager shareInstance];
    [self getMyHeadImage];
}
-(void)getMyHeadImage
{
[_xmppManager getMyVCard:^(BOOL ret, XMPPvCardTemp * temp) {
    if (ret) {
        if (temp.photo){
            _headImage.image=[UIImage imageWithData:temp.photo];
        }
        else {
            _headImage.image=[UIImage imageNamed:@"ali00.png"];
        }
    }
}];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTap)];
    tap.delegate=self;
    _headImage.userInteractionEnabled=YES;
    [_headImage addGestureRecognizer:tap];
}
-(void)onClickTap
{
    BodyViewController *bvc=[[BodyViewController alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickTheme:(id)sender {
    themeViewController *tvc=[[themeViewController alloc]init];
    UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:tvc];
    [self presentViewController:navc animated:YES completion:nil];
}
- (IBAction)onClickBack:(id)sender {
    [_xmppManager disconnect];
    loginViewController *lvc=[[loginViewController alloc]init];
    [self presentViewController:lvc animated:YES completion:nil];
}
@end
