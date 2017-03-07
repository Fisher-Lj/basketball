//
//  VerifyViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VerifyViewController.h"
#import "QFXMPPManager.h"
#import "LJUIControl.h"
@interface VerifyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation VerifyViewController
{
    UITableView *_tableView;
    QFXMPPManager *_manager;
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
	// Do any additional setup after loading the view.
    _manager=[QFXMPPManager shareInstance];
    [self createLeftNav];
    [self createTableView];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-[LJUIControl isIOS7]) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
        UIButton *agreeButton=[LJUIControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-120, 0, 60, 30) imageName:nil title:@"同意" target:self action:@selector(agreeButtonClick:)];
        [cell.contentView addSubview:agreeButton];
        UIButton*rejectButton=[LJUIControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 30) imageName:nil title:@"拒绝" target:self action:@selector(rejectButtonClick:)];
        [cell.contentView addSubview:rejectButton];
        
    }
    //显示请求人账号 数组内保存的是每一个出席的节点，里面有请求的账号
    XMPPPresence*presence=self.dataArray[indexPath.row];
    cell.textLabel.text=presence.from.user;
    
    //设置tag值
    cell.contentView.tag=indexPath.row;
    return cell;
}
//同意
-(void)agreeButtonClick:(UIButton*)button{
    //获取是哪一行的
    XMPPPresence*presence=self.dataArray[button.superview.tag];
    
    [_manager agreeRequest:presence.from.user];
    //刷新列表
    [self loadData];
}
//拒绝
-(void)rejectButtonClick:(UIButton*)button{
    XMPPPresence*presence=self.dataArray[button.superview.tag];
    [_manager reject:presence.from.user];
    //刷新列表
    [self loadData];
    
}
-(void)loadData{
    self.dataArray=_manager.subscribeArray;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createLeftNav{
    
    UIButton *button=[LJUIControl createButtonWithFrame:CGRectMake(0, 0, 15, 20) imageName:@"fts_search_backicon_ios7@2x" title:nil target:self action:@selector(onBackClick)];
    [button setImage:[UIImage imageNamed:@"fts_search_backicon"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)onBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
