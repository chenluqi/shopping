//
//  HomeTableView.h
//  买买买
//
//  Created by Jhwilliam on 16/2/1.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *models;

@end
