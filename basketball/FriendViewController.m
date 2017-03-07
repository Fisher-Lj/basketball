//
//  FriendViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-12.


//

#import "FriendViewController.h"
#import "QFXMPPManager.h"
#import "messageViewController.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "FriendCell.h"
#import "XMPPvCardTemp.h"
#import "LJUIControl.h"
#import "VerifyViewController.h"
@interface FriendViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FriendViewController
{
    NSMutableArray *_allFriend;
    QFXMPPManager *_xmppManager;
    NSArray *_headName;
    NSString *_path;
    UITableView *_tableView;
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customUI) name:THEME object:nil];
    _xmppManager=[QFXMPPManager shareInstance];
    [self customTableView];
    [self customUI];
    _allFriend=[[NSMutableArray alloc]init];
    _headName=@[@"好友",@"关注",@"被关注",@"单恋中"];
    [self loadData];
}


-(void)customTableView
{
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
}
-(void)customUI
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    _path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bg_default.jpg",_path]]];
    UIButton *button=[LJUIControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) imageName:nil title:@"提醒消息" target:self action:@selector(onTableHeaderView)];
    _tableView.tableHeaderView=button;
}
-(void)onTableHeaderView
{
    VerifyViewController *vvc=[[VerifyViewController alloc]init];
    //vvc.hidesBottomBarWhenPushed=YES;
    UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:vvc];
    [self presentViewController:navc animated:YES completion:nil];
}
-(void)loadData
{
    NSArray *array=[_xmppManager friendsList:^(BOOL isFinish){
        if (isFinish==NO) {
            [self loadData];
        }
        [_tableView reloadData];
    
    }];
    if (_xmppManager.subscribeArray.count>0) {
        
    }else {
    
    }

    [_allFriend removeAllObjects];
    [_allFriend addObjectsFromArray:array];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return _allFriend.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headName[section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSArray *arr=_allFriend[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCellID";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendCell" owner:self options:Nil]lastObject];
    }
    NSArray *arr=_allFriend[indexPath.section];
    XMPPUserCoreDataStorageObject *model=arr[indexPath.row];
    NSArray *name=[model.jidStr componentsSeparatedByString:@"@"];
    cell.nikeName.text=name[0];
    UIImage *image=[_xmppManager avatarForUser:model];
    cell.headImage.image=image;
    [_xmppManager friendvCard:name[0] completion:^(BOOL ret,XMPPvCardTemp *friend){
        if (friend.nickname) {
            cell.nikeName.text=friend.nickname;
            NSString *qmd=[[friend elementForName:QMD]stringValue];
            cell.qmd.text=UNQRCODE(qmd);
        }
    }];
    
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *model=_allFriend[indexPath.section][indexPath.row];
    messageViewController *mvc=[[messageViewController alloc]init];
    mvc.jid=model.jidStr;
    UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:mvc];
   // mvc.hidesBottomBarWhenPushed=YES;
    [self presentViewController:navc animated:YES completion:nil];
    //[self.navigationController pushViewController:mvc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;

}

@end
