//
//  LeftTableViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/24.
//  Copyright © 2016年 01. All rights reserved.
//

#import "LeftTableViewController.h"

@interface LeftTableViewController ()

@end

@implementation LeftTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //计算缓存大小
    [self _countCacheSize];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)_countCacheSize{
    
    NSUInteger fileSize = [[SDImageCache sharedImageCache] getSize];
    
    countLabel.text = [NSString stringWithFormat:@"%.1f M", fileSize / 1024 / 1024.0];
    
    NSLog(@"%@",countLabel.text);
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
    
    if (indexPath.row == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"清除缓存" message:@"确定清除缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        
        
        [self _countCacheSize];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
