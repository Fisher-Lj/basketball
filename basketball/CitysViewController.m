//
//  CitysViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CitysViewController.h"
#import "WeatherViewController.h"
#define NOTIFICATION1 @"mytification"
@interface CitysViewController ()

@end

@implementation CitysViewController
{
    NSMutableArray *_provinces;
    NSMutableArray *_citys;
    NSMutableArray *_state;
    UISearchBar *_search;
    UISearchDisplayController *_searchDis;
    NSMutableArray *_searchData;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _provinces=[[NSMutableArray alloc]init];
    _citys=[[NSMutableArray alloc]init];
    _state=[[NSMutableArray alloc]init];
    _searchData=[[NSMutableArray alloc]init];
    _search=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,320, 50)];
    self.tableView.tableHeaderView=_search;
    _searchDis=[[UISearchDisplayController alloc]initWithSearchBar:_search contentsController:self];
    _searchDis.searchResultsDataSource=self;
    _searchDis.searchResultsDelegate=self;
    [self getData];
    
}
-(void)getData
{
    NSString *path1=[[NSBundle mainBundle]pathForResource:@"city1" ofType:@"plist"];
    NSDictionary *dict1=[[NSDictionary alloc]initWithContentsOfFile:path1];
    NSArray *arr=[dict1 allKeys];
    NSMutableArray *arr3=[[NSMutableArray alloc]init];
    for (NSString *province in arr) {
         NSString *str=dict1[province];
        if ([str length]>5) {
            [_provinces addObject:province];
        }
        else{
            
        NSString *path=[[NSBundle mainBundle]pathForResource:str ofType:@"plist"];
        NSDictionary *dict2=[[NSDictionary alloc]initWithContentsOfFile:path];
        NSArray *arr1=[dict2 allKeys];
        [_citys addObject:arr1];
            [arr3 addObject:province];
        }
        [_state addObject:@"0"];
    }
    [_provinces addObjectsFromArray:arr3];
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
    if (tableView!=self.tableView) {
        [_searchData removeAllObjects];
        for (NSInteger i=0; i<6; i++) {
            NSString *str=_provinces[i];
            NSRange range=[str rangeOfString:_search.text];
            if (range.location!=NSNotFound) {
                [_searchData addObject:str];
            }
        }
        for (NSArray *arr in _citys) {
            for (NSString *str in arr) {
                NSRange range=[str rangeOfString:_search.text];
                if (range.location!=NSNotFound) {
                    [_searchData addObject:str];
                }
            }
        }
        return 1;
    }
    else
    return _provinces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (tableView!=self.tableView) {
        return _searchData.count;
    }
    else{
    if (section>5) {
        if ([_state[section]isEqualToString:@"0"]) {
            return 0;
        }else{
        NSArray *arr=_citys[section-6];
            return arr.count;}
    }
    else{
        return 0;
    }}
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView!=self.tableView) {
        return nil;
    }
    CGRect frame=[UIScreen mainScreen].bounds;
    NSLog(@"%f",self.view.frame.size.width);
    NSLog(@"%f",frame.size.width);
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0,frame.size.width , 40);
   
    [button setImage:[UIImage imageNamed:@"topic_Cell_Bg.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"topic_Cell_Bg.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=10+section;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    label.text=_provinces[section];
    
    [button addSubview:label];
    if ([[_state objectAtIndex:section]isEqualToString:@"0"]) {
        [button setSelected:NO];
    }
    else
    {
        [button setSelected:YES];
    }
    return button;
}
-(void)onBtnClick:(UIButton *)sender
{
    if ((sender.tag-10<6)) {
        NSString *str3=[[NSString alloc]init];
        for (UIView*view in sender.subviews) {
            if ([view isKindOfClass:UILabel.class]) {
                UILabel *label=(UILabel *)view;
                str3=label.text;
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION1 object:str3];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([sender isSelected]) {
        [sender setSelected:NO];
        [_state replaceObjectAtIndex:sender.tag-10 withObject:@"0"];
    }
    else
    {
        [sender setSelected:YES];
        [_state replaceObjectAtIndex:sender.tag-10 withObject:@"1"];
    }
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView!=self.tableView){
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION1 object:_searchData[indexPath.row]];

}
else{
[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION1 object:_citys[indexPath.section-6][indexPath.row]];
}
    [self.navigationController popViewControllerAnimated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView!=self.tableView) {
        cell.textLabel.text=_searchData[indexPath.row];
    }else
    {
    NSArray *arr=_citys[indexPath.section-6];
        cell.textLabel.text=arr[indexPath.row];}
    // Configure the cell...
    
    return cell;
}
@end
