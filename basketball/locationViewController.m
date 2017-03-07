//
//  locationViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "locationViewController.h"
//#import <MAMapKit/MAMapKit.h>
//#import <AMapSearchKit/AMapSearchAPI.h>
#import "searchViewController.h"
@interface locationViewController ()
//<MAMapViewDelegate,AMapSearchDelegate,UISearchBarDelegate>

@end

@implementation locationViewController
//{
//    MAMapView *_map;
//    AMapSearchAPI *_searchAPI;
//    UISearchBar *_searchBar;
//    UISearchDisplayController *_searchDisplay;
//    searchViewController *_searchVC;
//    NSMutableArray *_pins;
//}
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
//    _pins=[[NSMutableArray alloc]init];
//    [self prepareMap];
//    [self prepareSearch];
        //暂时不用
//    _searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:_searchVC];
//    _searchDisplay.searchResultsDataSource=_searchVC;
//    _searchDisplay.searchResultsDelegate=_searchVC;
}
//-(void)prepareSearch
//{
//_searchAPI=[[AMapSearchAPI alloc]initWithSearchKey:@"e218bb0be65ea25873af5431241c3456" Delegate:self];
//    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    _searchBar.delegate=self;
//    [_searchBar setShowsCancelButton:YES];
//    [_map addSubview:_searchBar];
//
//}
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [_map removeAnnotations:_pins];
//    [_pins removeAllObjects];
//    AMapPlaceSearchRequest *request=[[AMapPlaceSearchRequest alloc]init];
//    request.searchType=AMapSearchType_PlaceKeyword;
//    request.keywords=searchBar.text;
//    request.city=@[@"北京"];
//    [_searchAPI AMapPlaceSearch:request];
//    [searchBar resignFirstResponder];
//}
//
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//}
//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    searchBar.text=nil;
//    [searchBar resignFirstResponder];
//}
//
//
//-(void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
//{
//    //response.pois是表示搜索结果的数组，因为同一个关键字可能搜索到多个地点，所以要用数组表示
//    for (AMapPOI *poi in response.pois) {
//        NSLog(@"%@ dd %@ latitude:%f longtitude:%f",poi.name,poi.address,poi.location.latitude,poi.location.longitude);
//        MAPointAnnotation *pin=[[MAPointAnnotation alloc]init];
//        pin.coordinate=CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
//        pin.title=poi.name;
//        pin.subtitle=poi.address;
//        [_pins addObject:pin];
//    }
//    MACoordinateSpan span=MACoordinateSpanMake(.01, .01);
//    AMapPOI *poi1=response.pois[0];
//    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(poi1.location.latitude, poi1.location.longitude);
//    MACoordinateRegion region=MACoordinateRegionMake(coordinate, span);
//    [_map setRegion:region];
//    //大头针定在地图上
//    [_map addAnnotations:_pins];
//}
//
//-(void)prepareMap
//{
//    [[MAMapServices sharedServices]setApiKey:@"e218bb0be65ea25873af5431241c3456"];
//    _map=[[MAMapView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:_map];
//    _map.delegate=self;
//    _map.showsUserLocation=YES;
//   // CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(_map.userLocation.coordinate.latitude, _map.userLocation.coordinate.longitude);
//    CLLocationCoordinate2D  coordinate=CLLocationCoordinate2DMake(40.035139,116.311655);
//    MACoordinateSpan span=MACoordinateSpanMake(0.01,0.01);
//    MACoordinateRegion region=MACoordinateRegionMake(coordinate, span);
//    [_map setRegion:region];
//    MAPointAnnotation *pin=[[MAPointAnnotation alloc]init];
//    pin.coordinate=coordinate;
//    [_map addAnnotation:pin];
//}
////定位函数，，模拟器不能用
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    if (updatingLocation) {
//        NSLog(@"dddd");
//    }
//}
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
@end
