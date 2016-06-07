//
//  ScanViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/20.
//  Copyright © 2016年 01. All rights reserved.
//

#import "ScanViewController.h"
#import "StateShare.h"

@interface ScanViewController ()
{
    UIView *_viewPreview;

    UIView *view1;
    
    NSInteger _is3;
    
}
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _is3 = 0;
    // Do any additional setup after loading the view, typically from a nib.
//    [self _createBackButton];
    [self _createUI];
    
    _captureSession = nil;
    _isReading = NO;
    
    [self _createBackButton];
    [self startReading];
    
    
    
}
- (void)_createBackButton{
    
//    NSUInteger count = self.navigationController.viewControllers.count;
//    if (count > 0) {
    
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
       
    [self.navigationController.navigationBar addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:@"Scan_btn_back_nav@2x"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem = backItem;
//    }
    
}

- (void)backAction:(UIButton *)button{
    NSLog(@"dddd");

//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (void)_createUI{
    
    _viewPreview = [[UIView alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth - 40, kScreenWidth - 40)];
    [self.view addSubview:_viewPreview];

    

 

    
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    
    [_viewPreview addSubview:_boxView];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
//            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
    
            NSString *urlString = [NSString stringWithFormat:@"%@",[metadataObj stringValue]];
    
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
            
            [self inputPassword:urlString];
        }
    }
}

- (void)inputPassword:(NSString *)sellerName {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您的密码 ^O^" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
    }];
    
    __block ScanViewController *this =self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *passwordText = alertController.textFields.lastObject;
        
        [this comparePassword:passwordText.text sellerName:sellerName];
        
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

//比较密码, 完成交易
- (void)comparePassword:(NSString *)password sellerName:(NSString *)sellerName{
     StateShare *state = [StateShare getStateShare];
    NSArray *userArr = [NSArray arrayWithContentsOfFile:[self filePath:@"user"]];
    if (userArr) {
        for (int i = 0; i < userArr.count; i++) {
            NSDictionary *dic = userArr[i];
            if ([state.name isEqualToString:dic[@"userName"]]) {
                if ([password isEqualToString:dic[@"transactionPassword"]]) {
                    //密码匹配的时候
                    //商家
                    NSMutableArray *sellerArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:@"seller"]];
                    
                    //判断商家信息文件本地是否已经有“？
                    if (sellerArr) {
                        
                        //商家余额更新
                        for (int i = 0; i < sellerArr.count; i++) {
                            NSDictionary *dic = sellerArr[i];
                            if ([sellerName isEqualToString:dic[@"name"]]) {
                                NSInteger balance = [dic[@"balance"] integerValue];
                                balance += [_model.price integerValue];
                                [dic setValue:[NSNumber numberWithInteger:balance] forKey:@"balance"];
                                
                                [self dataPreservation:sellerArr filerName:@"seller"];
                            }
                        }
                        
                        //商家卖出的商品信息记录
                        NSMutableArray *sellerCommodityArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:[NSString stringWithFormat:@"商家_%@", sellerName]]];
                        
                        //判断商家售卖纪录在本地是否已经存在
                        if (sellerCommodityArr) {
                            NSDictionary *businessDic = @{
                                                          @"cover_image_url" : _model.cover_image_url,
                                                          @"price" : _model.price,
                                                          @"name" : _model.name
                                                          };
                            [sellerCommodityArr addObject:businessDic];
                            [self dataPreservation:sellerCommodityArr filerName:[NSString stringWithFormat:@"商家_%@", sellerName]];
                        }else {
                            sellerCommodityArr = [NSMutableArray array];
                            NSDictionary *businessDic = @{
                                                          @"cover_image_url" : _model.cover_image_url,
                                                          @"price" : _model.price,
                                                          @"name" : _model.name
                                                          };
                            [sellerCommodityArr addObject:businessDic];
                            [self dataPreservation:sellerCommodityArr filerName:[NSString stringWithFormat:@"商家_%@", sellerName]];
                        }
                    }else {
                        
                        //创建并保存卖家信息
                        sellerArr = [NSMutableArray array];
                        
                        NSNumber *balance = @(1000.0 + [_model.price integerValue]);
                        NSDictionary *sellerDic = @{
                                                    @"name" : sellerName,
                                                    @"balance" : balance
                                                    };
                        [sellerArr addObject:sellerDic];
                        
                        
                        
                        [self dataPreservation:sellerArr filerName:@"seller"];
                        
                        //保存卖家卖出的商品纪录
                        NSMutableArray *sellerCommodityArr = [NSMutableArray array];
                        NSDictionary *businessDic = @{
                                                      @"cover_image_url" : _model.cover_image_url,
                                                      @"price" : _model.price,
                                                      @"name" : _model.name
                                                      };
                        [sellerCommodityArr addObject:businessDic];
                        [self dataPreservation:sellerCommodityArr filerName:[NSString stringWithFormat:@"商家_%@", sellerName]];
                    }
                    
                    //消费者
                    StateShare *state = [StateShare getStateShare];
                    NSMutableArray *buyerArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:@"user"]];
                    
                    //判断买家信息文件是否已经存在本地
                    if (buyerArr) {
                        for (int i = 0; i < buyerArr.count; i++) {
                            NSDictionary *dic = buyerArr[i];
                            if ([state.name isEqualToString:dic[@"userName"]]) {
                                
                                //消费者余额更新
                                NSInteger balance = [dic[@"balance"] integerValue];
                                balance -= [_model.price integerValue];
                                [dic setValue:[NSNumber numberWithInteger:balance] forKey:@"balance"];
                                
                                [self dataPreservation:buyerArr filerName:@"user"];
                                //消费者买到的商品信息记录
                                NSMutableArray *buyerCommodityArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:state.name]];
                                
                                //判断登陆用户买东西纪录在本地是否已经有记录
                                if (buyerCommodityArr) {
                                    NSDictionary *commodityDic = @{
                                                                   @"cover_image_url" : _model.cover_image_url,
                                                                   @"price" : _model.price,
                                                                   @"name" : _model.name
                                                                   };
                                    [buyerCommodityArr addObject:commodityDic];
                                    [self dataPreservation:buyerCommodityArr filerName:state.name];
                                }else {
                                    buyerCommodityArr = [NSMutableArray array];
                                    NSDictionary *commodityDic = @{
                                                                   @"cover_image_url" : _model.cover_image_url,
                                                                   @"price" : _model.price,
                                                                   @"name" : _model.name
                                                                   };
                                    [buyerCommodityArr addObject:commodityDic];
                                    [self dataPreservation:buyerCommodityArr filerName:state.name];
                                }

                            }
                        }
                    }else {
                        //        buyerArr = [NSMutableArray array];
                        
                    }
                    
                    //
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }else {
                    //密码不匹配的时候
                    if (_is3 < 3) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您输入的密码有错！" preferredStyle:UIAlertControllerStyleActionSheet];
                        __block ScanViewController *this = self;
                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [this comparePassword:password sellerName:sellerName];
                        }]];
                        
                        [self presentViewController:alertController animated:YES completion:^{
                            
                        }];
                        
                    }
                    
                    
                }
                
                //找到登录的联系人跳出循环
                break;
            }
        }
    }  
}

//保存用户信息
- (void)dataPreservation:(NSMutableArray *)arr filerName:(NSString *)name{
    [arr writeToFile:[self filePath:name] atomically:YES];
}

//获取文件在沙盒里document的路径
- (NSString *)filePath:(NSString *)str {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingFormat:@"/%@.plist", str];
    return filePath;
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (void)startStopReading:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
//            [_startButton setTitle:@"Stop" forState:UIControlStateNormal];
//            [_lblStatus setText:@"Scanning for QR Code"];
        }
    }
    else{
        [self stopReading];
//        [_startButton setTitle:@"Start!" forState:UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
