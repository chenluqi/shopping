//
//  CommodityTableView.h
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray *dataArr;
@end
