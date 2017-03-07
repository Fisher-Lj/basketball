//
//  registerViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "registerViewController.h"
#import "registerModel.h"
#import "LJUIControl.h"
#import "registerViewController2.h"
@interface registerViewController ()

@end

@implementation registerViewController
{
    UITextField *_textField;
    BOOL isUp;
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
    [self customNavigation];
}
-(void)customNavigation
{
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"fts_search_backicon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=btn;
    UIBarButtonItem *button1=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(onBtnClick)];
    self.navigationItem.rightBarButtonItem=button1;
}
-(BOOL)isEmail
{
    NSArray *arr=[_text3.text componentsSeparatedByString:@"@"];
    if (arr.count==2) {
        return YES;
    }
    return NO;
}
-(void)onBtnClick
{
    BOOL ret=[self isEmail];
    if (_text1.text.length>0&&_text2.text.length==11&&ret&&_text4.text.length>0) {
       registerModel *model=[registerModel shareManager];
        model.nickName=_text1.text;
        model.phoneNum=_text2.text;
        model.qmd=_text4.text;
        registerViewController2 *regvc=[[registerViewController2 alloc]init];
        UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:regvc];
        [self presentViewController:navc animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }

}
-(void)onBarBtnClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
