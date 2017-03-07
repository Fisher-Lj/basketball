//
//  themeViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "themeViewController.h"
#import "httpDownLoad.h"
#import "themeManager.h"
#import "LJUIControl.h"
@interface themeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation themeViewController
{
    NSMutableArray *dataArray;
    UITableView *_tableView;
    MBProgressHUD *_hud;
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
    [self customTableView];
    [self loadData];
    [self createLeftNav];
}
-(void)customTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];

}
-(void)loadData
{
    httpDownLoad *httpDown=[[httpDownLoad alloc]initWithUrl:@"http://imgcache.qq.com/club/item/theme/json/data_4.6+_3.json?callback=jsonp2" withBlock:^(BOOL ret, httpDownLoad *downLoad) {
       if (ret) {
           NSString *str=[[NSString alloc]initWithData:downLoad.data encoding:NSUTF8StringEncoding];
           [self jsonValue:str];
       }
       else
       {
           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"网络不好，请稍后再试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
           [self.view addSubview:alert];
           [alert show];
       }
}];

}
-(void)jsonValue:(NSString *)json
{
    NSRange range1=[json rangeOfString:@"("];
    NSRange range2=[json rangeOfString:@")"];
    json=[json substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    dataArray=[NSMutableArray arrayWithArray:[dict[@"detailList"]allValues]];
    [_tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *CellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict=dataArray[indexPath.row];
    cell.textLabel.text=dict[@"name"];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=dataArray[indexPath.row];
    themeManager *theme=[themeManager shareManager];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    _hud=[LJUIControl createProgerssHUD:@"正在下载" withView:_tableView];
    [self.view addSubview:_hud];
    if ([cell.textLabel.text isEqualToString:@"黑色简约"]) {
        _hud.labelText=@"此主题有些问题";
        [_hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [_hud removeFromSuperview];
        }];
        return;
    }
    [_hud show:YES];
    BOOL isfinished=[theme DownLoadBlock:dict block:^(BOOL ret){
        if (YES) {
            [_hud removeFromSuperview];
        }else
        {
        _hud.labelText=@"下载失败";
            [self performSelectorOnMainThread:@selector(hudDismiss) withObject:nil waitUntilDone:1];
        }
    
    }];
    
}
-(void)createLeftNav{
    
    UIButton *button=[LJUIControl createButtonWithFrame:CGRectMake(0, 0, 15, 20) imageName:@"fts_search_backicon_ios7@2x" title:nil target:self action:@selector(onBackClick)];
    [button setImage:[UIImage imageNamed:@"fts_search_backicon"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)onBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)hudDismiss
{
    _hud=nil;
    [_hud show:NO];
}
@end
