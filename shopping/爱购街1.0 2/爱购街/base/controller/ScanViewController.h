//
//  ScanViewController.h
//  爱购街
//
//  Created by Jhwilliam on 16/2/20.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RootViewController.h"
#import "HomeModel.h"

#import <AVFoundation/AVFoundation.h>
@interface ScanViewController : RootViewController<AVCaptureMetadataOutputObjectsDelegate>


@property (nonatomic, strong) HomeModel *model;
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;

//-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end
