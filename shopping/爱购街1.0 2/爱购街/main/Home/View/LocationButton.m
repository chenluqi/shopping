//
//  locationButton.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import "LocationButton.h"
#import "RegexKitLite.h"
@implementation LocationButton
{
    CLLocationManager *manager;
    UIButton *_button;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _button = [[UIButton alloc]initWithFrame:self.bounds];
        [self addSubview:_button];
        [_button setTitle:@"定位中" forState:UIControlStateNormal];
        NSLog(@"%@",_button.titleLabel.text);
        
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        //1、定位 经纬度 海拔
        
        //定位功能是否开启
        
        if ([CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位已经开启");
        }
        
        manager = [[CLLocationManager alloc]init];
        manager.delegate = self;
        
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            //将定位服务访问设置为当使用的时候定位
            [manager requestWhenInUseAuthorization];
        }
        //定位的精度 double类型 精度越高越耗电
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //定位的频率
        manager.distanceFilter = 1000.0;
        
        //开始定位
        [manager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //    坐标经纬度
    //    CLLocationCoordinate2D coordinate;
    //    CLLocationDegrees latitude;
    //    CLLocationDegrees longitude;
    NSLog(@"经纬度%f %f 海拔%f 水平，垂直精确度%f %f",locations[0].coordinate.latitude,locations[0].coordinate.longitude, locations[0].altitude, locations[0].horizontalAccuracy, locations[0].verticalAccuracy);
    
    //    //创建位置对象
    //
    //    CLLocation *anyLocation = [[CLLocation alloc] initWithLatitude:39.92 longitude:116.18];
    //    //计算两个点之间的距离
    //    CLLocationDistance distance = [locations[0] distanceFromLocation:anyLocation];
    //    NSLog(@"杭州总部离北京总部的距离%f", distance);//将近1138公里
    
    //位置反编码（经纬度->具体的地点）30，120 ->杭州
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark *place in placemarks) {
//            NSLog(@"%@", place);
//            NSString *regex = @"\\b\\w*\\b";
//            NSArray *result = [place.locality componentsMatchedByRegex:regex];
            
            [_button setTitle:[NSString stringWithFormat:@"%@",place.locality] forState:UIControlStateNormal];
//            NSLog(@"%@",result[0]);
            
        }
    }];
    
}

//- (void)buttonAction:(UIButton*)button{
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 100, 100)];
//    [self.viewController.view insertSubview:view aboveSubview:button];
//    
//    
//    
//}

@end
