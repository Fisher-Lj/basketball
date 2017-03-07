//
//  searchViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "searchViewController.h"
//#import <AMapSearchKit/AMapSearchAPI.h>
//#import "searchModel.h"
@interface searchViewController ()
//<AMapSearchDelegate>

@end

@implementation searchViewController
//{
//    AMapSearchAPI *_searchAPI;
//    NSMutableArray *_searchData;
//}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    _searchData=[[NSMutableArray alloc]init];
//    [self searchMap];
//}
//-(void)searchMap
//{
//    _searchAPI=[[AMapSearchAPI alloc]initWithSearchKey:@"e218bb0be65ea25873af5431241c3456" Delegate:self];
//}
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (_searchData.count==0) {
//    NSLog(@"%@",self.searchDisplayController.searchBar.text);
//    AMapPlaceSearchRequest *request=[[AMapPlaceSearchRequest alloc]init];
//    request.searchType=AMapSearchType_PlaceKeyword;
//    request.keywords=self.searchDisplayController.searchBar.text;
//    request.city=@[@"北京"];
//    [_searchAPI AMapPlaceSearch:request];
//    }
//    return 1;
//}
//-(void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
//{
//    NSLog(@"fff");
//    [_searchData removeAllObjects];
//    for (AMapPOI *poi in response.pois) {
//        
//        searchModel *model=[[searchModel alloc]init];
//        model.name=poi.name;
//        model.adress=poi.address;
//        model.Latitude=poi.location.latitude;
//        model.Longitude=poi.location.longitude;
//        [_searchData addObject:model];
//    }
//    [self.tableView reloadData];
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    NSLog(@"%d",_searchData.count);
//    return _searchData.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    searchModel *model=_searchData[indexPath.row];
//    cell.textLabel.text=model.name;
//    NSLog(@"%@",cell.textLabel.text);
//    return cell;
//}


@end
