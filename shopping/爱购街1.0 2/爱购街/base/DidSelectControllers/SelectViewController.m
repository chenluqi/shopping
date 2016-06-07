//
//  SelectViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTabBar];
}

- (void)_createTabBar{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 20);
    
    [button setBackgroundImage:[UIImage imageNamed:@"Scan_btn_back_nav@2x"] forState:UIControlStateNormal];
    
    //点击返回
    [button addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)backItemAction: (UIButton*)button{
    
    [self.navigationController popViewControllerAnimated:YES];
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
