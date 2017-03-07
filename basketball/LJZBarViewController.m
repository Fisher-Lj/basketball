//
//  LJZBarViewController.m
//  erweima
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "LJZBarViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZBarSymbol.h"
@interface LJZBarViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation LJZBarViewController
{
    UIImageView *_line;
    NSTimer *_timer;
    int num;
    BOOL upOrDown;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithBlock:(void(^)(NSString *,BOOL))a{
    if(self=[super init]){
        self.ScanResult=[a copy];
    
    }
    return self;
}
-(void)createView
{
    UIImageView *bgImageView;
  //  if (self.view.frame.size.height<500) {
        UIImage *image=[UIImage imageNamed:@"qrcode_scan_bg_Green.png"];
        bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-100)];
        bgImageView.contentMode=UIViewContentModeTop;//
        bgImageView.clipsToBounds=YES;
        bgImageView.image=image;
        bgImageView.userInteractionEnabled=YES;
//    }else
//    {
//        UIImage *image=[UIImage imageNamed:@"qrode_scan_bg_Green_iphone5"];
//        bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64-100)];
//        bgImageView.contentMode=UIViewContentModeTop;
//        bgImageView.clipsToBounds=YES;
//        bgImageView.image=image;
//        bgImageView.userInteractionEnabled=YES;
//    }
    [self.view addSubview:bgImageView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 280, 320, 40)];
    label.text=@"将取景框对准二维码，即可自动扫描。";
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.lineBreakMode=NSLineBreakByCharWrapping;
    label.numberOfLines=2;
    label.font=[UIFont systemFontOfSize:12];
    label.backgroundColor=[UIColor clearColor];
    [bgImageView addSubview:label];
    _line=[[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 220, 2)];
    _line.image=[UIImage imageNamed:@"qrcode_scan_light_green.png"];
    [bgImageView addSubview:_line];
    //下方相册
    UIImageView *scanImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, bgImageView.frame.size.height+64, 320, 100)];
    scanImageView.image=[UIImage imageNamed:@"qrcode_scan_bar.png"];
    scanImageView.userInteractionEnabled=YES;
    [self.view addSubview:scanImageView];
    NSArray*unSelectImageNames=@[@"qrcode_scan_btn_photo_nor.png",@"qrcode_scan_btn_flash_nor.png",@"qrcode_scan_btn_myqrcode_nor.png"];
    NSArray*selectImageNames=@[@"qrcode_scan_btn_photo_down.png",@"qrcode_scan_btn_flash_down.png",@"qrcode_scan_btn_myqrcode_down.png"];
    
    for (int i=0; i<unSelectImageNames.count; i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:unSelectImageNames[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImageNames[i]] forState:UIControlStateHighlighted];
        button.frame=CGRectMake(320/3*i, 0, 320/3, 100);
        [scanImageView addSubview:button];
        if (i==0) {
            [button addTarget:self action:@selector(pressPhotoLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==1) {
            [button addTarget:self action:@selector(flashLightClick) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i==2) {
            button.hidden=YES;
        }
        
    }
    //导航栏的定制
    UIImageView*navImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    navImageView.image=[UIImage imageNamed:@"qrcode_scan_bar.png"];
    navImageView.userInteractionEnabled=YES;
    [self.view addSubview:navImageView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(320/2-32,20 , 64, 44)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"扫一扫";
    [navImageView addSubview:titleLabel];
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_pressed@2x.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor.png"] forState:UIControlStateNormal];
    
    
    [button setFrame:CGRectMake(10,10, 48, 48)];
    [button addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}
-(void)animation1
{
    [UIView animateWithDuration:2 animations:^{
    
        _line.frame=CGRectMake(50, 50+200, 220, 2);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:2 animations:^{
        
            _line.frame=CGRectMake(50, 50, 220, 2);
        }];
    }];
}
//闪光灯
-(void)flashLightClick
{
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchMode==AVCaptureTorchModeOff) {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
    }
    else{
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }


}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    BOOL custom=[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (custom) {
        [self initCapture];//启动摄像头
    }
    [self createView];
}
#pragma mark   点击相册按钮
-(void)pressPhotoLibraryButton:(UIButton *)button
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _line.frame=CGRectMake(50, 50, 220, 2);
    num=0;
    upOrDown=NO;
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.allowsEditing=YES;
    picker.delegate=self;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{
        self.isScanning=NO;
        [self.captureSession stopRunning];
    
    }];

}
-(void)pressCancelButton:(UIButton *)button
{
    self.isScanning=NO;
    [self.captureSession stopRunning];
   // _ScanResult(nil,NO);
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _line.frame=CGRectMake(50, 50, 220, 2);
    num=0;
    upOrDown=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 开启相机
-(void)initCapture
{
    self.captureSession=[[AVCaptureSession alloc]init];
    AVCaptureDevice *inputDevice=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput=[AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    AVCaptureVideoDataOutput *captureOutput=[[AVCaptureVideoDataOutput alloc]init];
    captureOutput.alwaysDiscardsLateVideoFrames=YES;
    if ([[UIDevice currentDevice]systemVersion].intValue>=7) {
        AVCaptureMetadataOutput *_output=[[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        [self.captureSession addOutput:_output];
        _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        self.captureVideoPreviewLayer.frame=self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:self.captureVideoPreviewLayer];
        self.isScanning=YES;
        [self.captureSession startRunning];
    }
    else
    {
        [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        NSString *key=(NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber *value=[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings=[NSDictionary dictionaryWithObject:value forKey:key];
        [captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:captureOutput];
        NSString *preset=0;
        if (NSClassFromString(@"NSOrderdSet")&&[UIScreen mainScreen].scale>1&&[inputDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
            preset=AVCaptureSessionPresetiFrame960x540;
        }
        if (!preset) {
            preset=AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset=preset;
        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        self.captureVideoPreviewLayer.frame=self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:self.captureVideoPreviewLayer];
        self.isScanning=YES;
        [self.captureSession startRunning];
    }

}
-(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer=CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    size_t bytesperRow=CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width=CVPixelBufferGetWidth(imageBuffer);
    size_t height=CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        NSLog(@"CGColorSpaceCreateDeviceRGBfailure");
        return nil;
    }
    void *baseAddress=CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bufferSize=CVPixelBufferGetDataSize(imageBuffer);
    CGDataProviderRef provider=CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    CGImageRef cgImage=CGImageCreate(width, height, 8, 32, bytesperRow, colorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, provider, NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    UIImage *image=[UIImage imageWithCGImage:cgImage];
    return image;
}
#pragma mark 对图像进行解码
-(void)decodeImage:(UIImage*)image
{
    _isScanning=NO;
    ZBarSymbol *symbol=nil;
    ZBarReaderController *read=[ZBarReaderController new];
    read.readerDelegate=self;
    CGImageRef cgImageRef=image.CGImage;
    for (symbol in [read scanImage:cgImageRef]){
        break;}
    if (symbol!=nil) {
        if (_timer) {
            [_timer invalidate];
            _timer=nil;
        }
    _line.frame=CGRectMake(50, 50, 220, 2);
    num=0;
    upOrDown=NO;
        NSLog(@"%@",symbol.data);
    self.ScanResult(symbol.data,YES);
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        num=0;
        upOrDown=NO;
        self.isScanning=YES;
        [self.captureSession startRunning];
    }
}
#pragma mark-AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image=[self imageFromSampleBuffer:sampleBuffer];
    [self decodeImage:image];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate//IOS7下触发
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject=[metadataObjects objectAtIndex:0];
        NSLog(@"%@",metadataObject.stringValue);
        self.ScanResult(metadataObject.stringValue,YES);
    }
    [self.captureSession stopRunning];
    _line.frame=CGRectMake(50, 50, 220, 2);
    num=0;
    upOrDown=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _line.frame=CGRectMake(50, 50, 220, 2);
    num=0;
    upOrDown=NO;
    UIImage *image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self decodeImage:image];
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _line.frame=CGRectMake(50, 50, 220, 2);
    num=0;
    upOrDown=NO;
    _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        self.isScanning=YES;
        [self.captureSession startRunning];
    }];
}
#pragma mark - DecoderDelegate
+(NSString *)zhengze:(NSString *)str
{
    NSError *error;
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];//筛选
    if (regex!=nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
        if (firstMatch) {
            NSRange resultRange=[firstMatch rangeAtIndex:0];
            NSString *result1=[str substringWithRange:resultRange];
            return result1;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
