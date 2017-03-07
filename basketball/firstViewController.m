//
//  firstViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-12.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "firstViewController.h"
#import "QFXMPPManager.h"
#import "coreData.h"
#import "chatModel.h"
#import "FriendCell.h"
#import "XMPPvCardTemp.h"
#import "messageViewController.h"
#import "LJUIControl.h"
@interface firstViewController ()

@end

@implementation firstViewController
{
    QFXMPPManager *_xmppManager;
    NSMutableArray *_recentFriends;
    NSMutableArray *_headImage;
    int *heads;
    NSString *_path;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customUI) name:THEME object:nil];
    _xmppManager=[QFXMPPManager shareInstance];
    [self login];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}
-(void)customUI
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    _path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bg_default.jpg",_path]]];
}
-(void)loadData
{
    NSUserDefaults *_user=[NSUserDefaults standardUserDefaults];
   
  NSArray *arr=[[coreData shareIntance]check:[_user objectForKey:MYJID] with:20];
    _headImage=[NSMutableArray arrayWithCapacity:0];
    _recentFriends=[NSMutableArray arrayWithArray:arr];
    heads=0;
    for (chatModel *model in _recentFriends) {
        NSString *jid=[NSString stringWithFormat:@"%@@%@",model.jid,IP];
        [_xmppManager friendvCard:jid completion:^(BOOL ret, XMPPvCardTemp *temp) {
            heads++;
            if (temp.photo) {
                model.headimage=[UIImage imageWithData:temp.photo
            ];
            }
            else{
                model.headimage=[UIImage imageNamed:@"bierde24.png"];
            }
            if (temp.nickname) {
                model.nickname=temp.nickname;
            }
            if (heads==_recentFriends.count) {
                [self.tableView reloadData];
            }
        }];
    }
    [self.tableView reloadData];
}
-(void)login
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:ISLOGIN]) {
        [_xmppManager loginUser:^(BOOL ret){
            if (ret==NO) {
                //[self login];
            }
        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _recentFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendCell" owner:self options:nil]lastObject];
    }
    chatModel *model=_recentFriends[_recentFriends.count- indexPath.row-1];
    cell.headImage.image=model.headimage;
    if (model.nickname) {
        cell.nikeName.text=model.nickname;
    }else{
        cell.nikeName.text=model.jid;}
    cell.qmd.text=model.message;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageViewController *mc=[[messageViewController alloc]init];
    chatModel *model=_recentFriends[_recentFriends.count- indexPath.row-1];
    NSString *str=[NSString stringWithFormat:@"%@@%@",model.jid,IP];
    mc.jid=str;
    UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:mc];
    [self presentViewController:navc animated:YES completion:nil];
}
@end
