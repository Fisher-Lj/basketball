//
//  messageViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "messageViewController.h"
#import "QFXMPPManager.h"
#import "LJUIControl.h"
#import "LJToolbAR.h"
#import "XMPPvCardTemp.h"
#import "messageCell.h"
#import "Photo.h"
@interface messageViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation messageViewController
{
    QFXMPPManager *_xmppManager;
    UITableView *_tableView;
    LJToolbAR *_toolBar;
    NSMutableArray *_dataMessage;
    UIImage *_leftImage;
    UIImage *_rightImage;
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
    _xmppManager=[QFXMPPManager shareInstance];
    [self createLeftNav];
    [self createRightNav];
    [self loadHeaderImage];
    [self customTableView];
    [self customToolBar];
    
    [_toolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    [_xmppManager valuationChatPersonName:_jid IsPush:YES MessageBlock:^(Manage*model){
        
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    }];
    [self reloadData];
}
-(void)loadHeaderImage
{
    [_xmppManager getMyVCard:^(BOOL isFinish,XMPPvCardTemp *model){
        if (isFinish) {
            if (model.photo) {
                _rightImage=[UIImage imageWithData:model.photo];
            }
            else{
                _rightImage=[UIImage imageNamed:@"IMG_1473.JPG"];
            }
            [_tableView reloadData];
        }
    
    }];
    [_xmppManager friendvCard:_jid completion:^(BOOL isFinish, XMPPvCardTemp *model) {
        if (isFinish) {
            if (model.photo) {
                _leftImage=[UIImage imageWithData:model.photo];
            }
            else {
                _leftImage=[UIImage imageNamed:@"snow1"];
            }
            [_tableView reloadData];
        }
    }];
}
-(void)reloadData
{
    NSArray *array=[_xmppManager messageRecord];
    _dataMessage=[NSMutableArray arrayWithArray:array];
    NSLog(@"%d",array.count);
    [_tableView reloadData];
    if (_dataMessage.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataMessage.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _tableView.frame=CGRectMake(0, 0, self.view.frame.size.width, _toolBar.frame.origin.y);
    
    if (_dataMessage.count) {
        //在此一定要判断
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataMessage.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)customToolBar
{
    _toolBar=[[LJToolbAR alloc]initWithFrame:CGRectMake(0, 0, 0, 0) voice:nil ViewController:self Block:^(NSString *sign,NSString *message){
        [_xmppManager sendMessage:message withType:sign withTojid:_jid completion:^(BOOL ret){
        
        }];
        //相隔0.1秒刷新数据
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    }];
NSLog(@"%f,%f,%f,%f",_toolBar.bounds.size.height,_toolBar.bounds.size.width,_toolBar.frame.origin.x,_toolBar.frame.origin.y);
    [self.view addSubview:_toolBar];
}
-(void)customTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    //cell的背景颜色为透明色，cell的阴影线取消，cell的选择为没有颜色
    //取消阴影线
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //对tableView添加手势
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(tap)];
    [_tableView addGestureRecognizer:tap];
}
-(void)tap
{
    [_toolBar dismissKeyBoard];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_toolBar dismissKeyBoard];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMessage.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *CellIdentifier=@"cell";
    messageCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[messageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withViewController:self];
        cell.backgroundColor=[UIColor clearColor];
    }
    XMPPMessageArchiving_Message_CoreDataObject *object=_dataMessage[indexPath.row];
    [cell customCell:object leftImage:_leftImage right:_rightImage];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     XMPPMessageArchiving_Message_CoreDataObject *object=_dataMessage[indexPath.row];
    NSString *message=object.body;
    if ([message hasPrefix:MESSAGE_STR]) {
        //计算大小
        CGSize size=[message sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 1000)];
        return size.height+55;
    }
    else if ([message hasPrefix:MESSAGE_IMAGESTR])
    {
        NSString *str=[message substringFromIndex:3];
        UIImage *image=[Photo string2Image:str];
        float height=image.size.height>160?160:image.size.height;
        return height+30;
    
    }
    else if ([message hasPrefix:MESSAGE_BIGIMAGESTR])
    {
        return 200;
    }
    return 50;
}
-(void)createLeftNav{    
    UIButton *button=[LJUIControl createButtonWithFrame:CGRectMake(0, 0, 15, 20) imageName:@"fts_search_backicon_ios7@2x" title:nil target:self action:@selector(onBackClick)];
    [button setImage:[UIImage imageNamed:@"fts_search_backicon"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)createRightNav{
    UIButton*button=[LJUIControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) imageName:@"header_icon_single.png" title:nil target:self action:@selector(onClickRight)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)onClickRight
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除此人" otherButtonTitles: nil];
    [self.view addSubview:sheet];
    [sheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [_xmppManager removeFriend:self.jid];
    }
}
-(void)onBackClick{
    //这里也是为记录未读消息做数据记录
    [_xmppManager valuationChatPersonName:nil IsPush:NO MessageBlock:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
