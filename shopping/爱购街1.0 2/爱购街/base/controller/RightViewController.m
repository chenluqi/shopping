//
//  RightViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/1.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RightViewController.h"
#import "ScanViewController.h"
#import "SelectViewController.h"
#import "RootNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _createButton];
    
}

- (void)_createButton{
    
    //扫码按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 80, 80)];
    [button setImage:[UIImage imageNamed:@"6301247_CD1463A58036C6C0D806F84067760932.jpg"] forState:UIControlStateNormal];
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
       [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    //定位按钮
//    UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 60, 50)];
//    [locationButton setTitle:@"定位" forState:UIControlStateNormal];
//    [self.view addSubview:locationButton];
//    
//    [locationButton addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buttonAction:(UIButton*)button{
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    
    RootNavigationController *root = [[RootNavigationController alloc]initWithRootViewController:scanVC];
    
    
    
   [self presentViewController:root animated:YES completion:NULL];
//    [self.navigationController pushViewController:root animated:YES];
}

//- (void)locationAction:(UIButton *)button{
//    
//    LocationViewController *locationVC = [[LocationViewController alloc]init];
//     RootNavigationController *root = [[RootNavigationController alloc]initWithRootViewController:locationVC];
//    
//    [self presentViewController:root animated:YES completion:NULL];
//    
//}
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
