//
//  registerViewController2.m
//  basketball
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "registerViewController2.h"
#import "registerModel.h"
#import "registerViewController3.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface registerViewController2 ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>

@end

@implementation registerViewController2
{
    UIDatePicker *_datePicker;
    UIImagePickerController *_picker;
    registerModel *_model;
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
    _model=[registerModel shareManager];
    [self customNavigation];
}
-(void)customNavigation
{
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"fts_search_backicon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=btn;
    UIBarButtonItem *button1=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(onBtnClick)];
    self.navigationItem.rightBarButtonItem=button1;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    tap.delegate=self;
    self.sexText.userInteractionEnabled=YES;
    //[self.view addGestureRecognizer:tap];
    [self.sexText addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap1)];
    tap1.numberOfTouchesRequired=1;
    tap1.numberOfTapsRequired=1;
    tap1.delegate=self;
    self.birthdayText.userInteractionEnabled=YES;
    [self.birthdayText addGestureRecognizer:tap1];
}
-(void)onTap1
{
    if (_datePicker) {
        return;
    }
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-216, 0, 0)];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"CCT"]];
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //日期模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    //定义最小日期
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter_minDate dateFromString:@"1920-01-01"];
    
    NSDate *maxDate = [NSDate date];
    [_datePicker setDate:[formatter_minDate dateFromString:@"1993-3-27"]];
    [_datePicker setMinimumDate:minDate];
    [_datePicker setMaximumDate:maxDate];
    [_datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    
    [UIView animateWithDuration:1 animations:^{
        _datePicker.frame=CGRectMake(0, self.view.frame.size.height-216, 0, 0);
    }];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
if (_datePicker) {
    [UIView animateWithDuration:0.3 animations:^{
        _datePicker.frame=CGRectMake(0, self.view.frame.size.height, 0, 0);
        
    }completion:^(BOOL finished) {
        //ARC如果全局指针指向nil，自动释放
        _datePicker=nil;
    }];
}
}
- (void) dataValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *dataPicker_one = (UIDatePicker *)sender;
    NSDate *date_one = dataPicker_one.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    _birthdayText.text = [formatter stringFromDate:date_one];
    
    
}

-(void)onTap
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"性别" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"取消",nil];
    sheet.tag=1000;
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1000) {
    if (buttonIndex==0) {
        self.sexText.text=@"男";
    }
    else if(buttonIndex==1){
        self.sexText.text=@"女";
    }}
    else if (actionSheet.tag==2000)
    {
        _picker=[[UIImagePickerController alloc]init];
        if (buttonIndex==0) {
            _picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.delegate=self;
            [self presentViewController:_picker animated:YES completion:nil];
        }else if(buttonIndex==1){
            _picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _picker.delegate=self;
            [self presentViewController:_picker animated:YES completion:nil];
        }
    
    }
}

-(void)onBarBtnClick
{
[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)onBtnClick
{
    if (_birthdayText.text.length>0&&_sexText.text.length>0&&_model.headerImage!=nil) {
    _model.birthday=_birthdayText.text;
        _model.sex=_sexText.text;

        registerViewController3 *regvc=[[registerViewController3 alloc]init];
        [self.navigationController pushViewController:regvc animated:YES];
    
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnImageClick:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"选取头像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机",@"取消", nil];
    sheet.tag=2000;
    [sheet showInView:self.view];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *media=info[UIImagePickerControllerMediaType];
    if ([media isEqualToString:(NSString *)kUTTypeImage]) {
        [_onBtnImage setImage:info[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        _model.headerImage=info[UIImagePickerControllerOriginalImage];
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_picker dismissViewControllerAnimated:YES completion:nil];

}
@end
