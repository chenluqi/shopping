//
//  RootViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/1/28.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RootViewController.h"
#import "TextSearchViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController



- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
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
