//
//  RootNavigationController.m
//  爱购街
//
//  Created by Jhwilliam on 16/1/28.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    NSDictionary *attri = @{
                            NSForegroundColorAttributeName : [UIColor whiteColor]
                            };
    
    self.navigationBar.barTintColor = [UIColor orangeColor];
    
    self.navigationBar.titleTextAttributes = attri;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = itme;
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
