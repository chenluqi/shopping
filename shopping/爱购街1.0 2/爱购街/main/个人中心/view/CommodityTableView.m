//
//  CommodityTableView.m
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import "CommodityTableView.h"
#import "CommodityCell.h"
@implementation CommodityTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CommodityCell" bundle:nil] forCellReuseIdentifier:@"CommodityCell"];
    }
    
    return self;
}
#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommodityCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
