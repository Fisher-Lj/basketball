//
//  YaoyiyaoViewController.m
//  basketball
//
//  Created by qianfeng on 15/5/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "YaoyiyaoViewController.h"
#import "AFNetworking.h"
#import "FriendCell.h"
#import "UIImageView+AFNetworking.h"
#import "FriendvCardViewController.h"
@interface YaoyiyaoViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation YaoyiyaoViewController
{
    NSMutableArray *_dataResouce;
    UITableView*_tableView;
    UIImageView *_imageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    _imageView.image=[UIImage imageNamed:@"IMG_1473.JPG"];
    [self.view addSubview:_imageView];
    [self createTableView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=2;
    [self.view addGestureRecognizer:tap];
}
-(void)tapClick
{
    [self loadData];
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self loadData];
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataResouce.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FriendCellID"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic=_dataResouce[indexPath.row];
    [cell.headImage setImageWithURL:[NSURL URLWithString:dic[@"headImageURL"]] placeholderImage:[UIImage imageNamed:@"ali00.png"]];
    if (dic[@"nickname"]) {
        cell.nikeName.text=dic[@"username"];
    }else {
        cell.nikeName.text=dic[@"username"];
    }
    cell.qmd.text=dic[@"qmd"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
-(void)loadData
{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manage GET:@"http://1000phone.net:8088/app/openfire/api/user/near.php?latitude=39.896304&longitude=116.410103&radius=100" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        _dataResouce=[NSMutableArray arrayWithArray:dict[@"users"]];
        [_tableView reloadData];
        [self animation1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)animation1
{
    if (_imageView) {
    NSArray*array=@[@"cube", @"moveIn", @"reveal",@"pageCurl",@"pageUnCurl", @"suckEffect",@"rippleEffect",@"oglFlip"];
    //CATransaction 这个是错误的
    CATransition*ani=[CATransition animation];
    //设置动画时间
    ani.duration=1;
    //设置动画的类型，随机从数据中抽取一种
    int num=arc4random()%6;
    ani.type=array[num];
    //动画从哪个方向来开始，有些动画设置无效
    ani.subtype=kCATransitionFromLeft;
    //把动画添加到view上  key值可以设置，以后方便删除使用
    [self.view.layer addAnimation:ani forKey:@"key"];
    
    [self.view bringSubviewToFront:_tableView];
        _imageView.hidden=YES;}
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendvCardViewController *svc=[[FriendvCardViewController alloc]init];
    NSDictionary *dict=_dataResouce[indexPath.row];
    svc.dict=dict;
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
