//
//  BasketballViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "BasketballViewController.h"
#import "WeatherViewController.h"
#import "LJZBarViewController.h"
#import "RadarViewController.h"
#import "YaoyiyaoViewController.h"
@interface BasketballViewController ()

@end

@implementation BasketballViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onWeatherClick:(id)sender {
    WeatherViewController *wvc=[[WeatherViewController alloc]init];
   
    [self.navigationController pushViewController:wvc animated:YES];
}
- (IBAction)onSaoyisaoClick:(id)sender {
    LJZBarViewController *lvc=[[LJZBarViewController alloc]initWithBlock:^(NSString *str, BOOL ret) {
        NSLog(@"%@",str);
    }];
    [self presentViewController:lvc animated:YES completion:nil];
    
}
- (IBAction)onLeidaClick:(id)sender {
    RadarViewController *rvc=[[RadarViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)onYaoyiyaoClick:(id)sender {
    YaoyiyaoViewController *yvc=[[YaoyiyaoViewController alloc]init];
    [self.navigationController pushViewController:yvc animated:YES];
}

@end
