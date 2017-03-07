//
//  WeatherViewController.m
//  basketball
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WeatherViewController.h"
#import "weatherModel.h"
#import "CitysViewController.h"
#define NOTIFICATION1 @"mytification"
@interface WeatherViewController ()

@end

@implementation WeatherViewController
{
    HttpConnection *_connection;
    NSMutableArray *_resourceData;
    NSMutableArray *_citys;
    NSString *_city;
    
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
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _citys=[[NSMutableArray alloc]init];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [_citys addObjectsFromArray:[user objectForKey:@"weather"]];
   // _citys=[[NSMutableArray alloc]initWithObjects:@"北京",@"上海",@"日照", nil];
    if (_citys.count==0) {
        _city=@"北京";
    }
    else
    {
        _city=_citys[0];}
    _resourceData=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onClick:) name:NOTIFICATION1 object:Nil];
    
    [self start];
    [self customScroll];
}
-(void)onClick:(NSNotification *)sender
{
    [_citys insertObject:sender.object atIndex:0];
    _city=_citys[0];
    [self start];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"weather"];
    [userDefaults synchronize];
    [userDefaults setObject:_citys forKey:@"weather"];
    [userDefaults synchronize];
    for (UIView *view in self.imageview4.subviews) {
        if ([view isKindOfClass:UIScrollView.class]||[view isKindOfClass:UIPageControl.class]) {
            [view removeFromSuperview];
            }
        }
    [self customScroll];
}
-(void)start
{
    NSString *str=[[NSString alloc]init];
    NSUserDefaults *users=[NSUserDefaults standardUserDefaults];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"YY-MM-dd";
    NSString *str2=[formatter stringFromDate:[NSDate date]];
    NSString *str3=[users objectForKey:@"date"];
    NSString *str4=[users objectForKey:@"bool"];
    if (![str2 isEqualToString:str3]) {
        if ([str4 isEqualToString:@"1"]) {
            str4=@"0";
        }
        else{
        str4=@"1";
        }
    }
    if ([str4 isEqualToString:@"1"]) {
            str=[NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&mcode=qianfeng.basketball&ak=U0A5XpKDGZVmpy3FoW16f96p",_city];
    }
    else{
        str=[NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&mcode=com.ZhouSuo.weikecheng&ak=X67XuvKdyTpeas6wsl1QKEA1",_city];}
    NSString *str1=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _connection=[[HttpConnection alloc]initWithUrl:str1 andDelegate:self];
    [users setObject:str4 forKey:@"bool"];
    [users setObject:str2 forKey:@"date"];
    [users synchronize];
    
}
-(void)requestFinished:(HttpConnection *)httpConnection
{
    [_resourceData removeAllObjects];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:httpConnection.data options:NSJSONReadingMutableContainers error:Nil];
    
    for (NSDictionary *dict1 in dict[@"results"][0][@"weather_data"]) {
        weatherModel *model=[[weatherModel alloc]init];
        [model setValuesForKeysWithDictionary:dict1];
        [_resourceData addObject:model];
    }
    [self getData];
}
-(void)getData
{
    weatherModel *model1=_resourceData[0];
    NSString *str=model1.date;
    if ([_city isEqualToString:@"澳门"]||[_city isEqualToString:@"台北"]||[_city isEqualToString:@"高雄"]||[_city isEqualToString:@"香港"]) {
        self.label1.text=model1.temperature;
        self.label5.text=[NSString stringWithFormat:@"%@发布",model1.date];
    }
    else{
    NSString *str1=[str substringWithRange:NSMakeRange(14, 3)];
    NSString *str2=[str substringWithRange:NSMakeRange(0, 9)];
    self.imageView.backgroundColor=[UIColor grayColor];
    self.label1.text=str1;
        self.label5.text=[NSString stringWithFormat:@"%@发布",str2];}
    self.label2.text=model1.weather;
    self.label3.text=model1.wind;
    self.label6.text=_city;
    NSRange range=[model1.weather rangeOfString:@"雨"];
    NSRange range1=[model1.weather rangeOfString:@"雪"];
    NSRange range2=[model1.weather rangeOfString:@"云"];
    if ([model1.weather isEqualToString:@"霾"]) {
        self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGHaze@2x.jpg"];
    }
    else if([model1.weather isEqualToString:@"晴"]){
        self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGSunny@2x.jpg"];
    }
    else if([model1.weather isEqualToString:@"阴"])
    {
        self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGOvercast@2x.jpg"];
    }
    else if([model1.weather isEqualToString:@"晴转阴"]||[model1.weather isEqualToString:@"阴转晴"])
    {self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGCloudy@2x.jpg"];}
    
    else if(range.location!=NSNotFound){
        self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGRain@2x.jpg"];
    }
    else if(range1.location!=NSNotFound){
        self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGSnow@2x.jpg"];
    }
    else if (range2.location!=NSNotFound){
    
        self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGCloudy@2x.jpg"];
    }
    else
    {
     self.imageView.image=[UIImage imageNamed:@"TQTPWeatherBGSunny@2x.jpg"];
    }
    weatherModel *model2=_resourceData[1];
    self.label21.text=model2.date;
    self.label22.text=model2.temperature;
    self.label23.text=model2.weather;
    weatherModel *model3=_resourceData[2];
    self.label31.text=model3.date;
    self.label32.text=model3.temperature;
    self.label33.text=model3.weather;
    weatherModel *model4=_resourceData[3];
    self.label41.text=model4.date;
    self.label42.text=model4.temperature;
    self.label43.text=model4.weather;
    
}
-(void)customScroll
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *_path=[NSString stringWithFormat:@"%@%@/",LIBPATH,[user objectForKey:THEME]];
    self.imageview4.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bg_default.jpg",_path]]];
    [self.addCity setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bottom_up_nor@2x.png",_path]] forState:UIControlStateNormal];
    [self.delCity setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@history_del@2x.png",_path]] forState:UIControlStateNormal];
    for (NSInteger i=0; i<_citys.count; i++) {
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(80*i, 0, 80, 30)];
        imageview.image=[UIImage imageNamed:@""];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.backgroundColor=[UIColor colorWithRed:0.6 green:.9 blue:0.6 alpha:0.8];
        label.text=_citys[i];
        label.textAlignment=NSTextAlignmentCenter;
        [imageview addSubview:label];
        [self._scroll addSubview:imageview];
    }
    self._scroll.contentSize=CGSizeMake(80*_citys.count, 30);
    self._scroll.pagingEnabled=YES;
    self._scroll.delegate=self;
    
    _pageControl.numberOfPages=_citys.count;
    _pageControl.currentPage=0;
    _pageControl.userInteractionEnabled=NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage=self._scroll.contentOffset.x/self._scroll.frame.size.width;
    
    _city=_citys[_pageControl.currentPage];
   
    [self start];
}
-(void)requestFailed:(HttpConnection *)httpConnection
{
    NSLog(@"%@",httpConnection.error);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnClick:(id)sender {
    CitysViewController *cvc=[[CitysViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
    
}
- (IBAction)onDeleteClick:(id)sender {
    [_citys removeObjectAtIndex:_pageControl.currentPage];
    if (_citys.count==0) {
        _city=@"北京";
    }
    else{
        _city=_citys[0];}
    [self start];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"weather"];
    [userDefaults synchronize];
    [userDefaults setObject:_citys forKey:@"weather"];
    [userDefaults synchronize];
    for (UIView *view in self.imageview4.subviews) {
        if ([view isKindOfClass:UIScrollView.class]||[view isKindOfClass:UIPageControl.class]) {
            [view removeFromSuperview];
        }
    }
    [self customScroll];
    
}
@end
