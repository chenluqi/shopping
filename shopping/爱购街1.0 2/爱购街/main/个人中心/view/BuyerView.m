//
//  BuyerView.m
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import "BuyerView.h"
#import "CommodityTableView.h"
#import "CommodityModel.h"
#import "BuyerModel.h"
#import "UserCell.h"

#define kViewHeight self.frame.size.height
#define kViewWidth self.frame.size.width

@implementation BuyerView {
    UILabel *_balanceLabel;
    UITableView *_userTableView;
    CommodityTableView *_commodityTableView;
    NSMutableArray *_buyerArr;
    NSMutableArray *_buyerRecordArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self loadChildView];
        
        [self readBuyer];
    }
    
    return self;
}

#pragma mark - view
- (void)loadChildView {
    _userTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth / 4, kViewWidth) style:UITableViewStylePlain];
    _userTableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    [_userTableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
    [self addSubview:_userTableView];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewWidth / 4, 0, kViewWidth * 3 / 4, 60)];
    _balanceLabel.text = [NSString stringWithFormat:@"当前余额为：0.00"];
    _balanceLabel.backgroundColor = [UIColor whiteColor];
    _balanceLabel.textColor = [UIColor redColor];
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_balanceLabel];
    
    _commodityTableView = [[CommodityTableView alloc] initWithFrame:CGRectMake(kViewWidth / 4, 60, kViewWidth * 3 / 4, kViewHeight - 60) style:UITableViewStylePlain];
    [self addSubview:_commodityTableView];
    
//    BuyerModel *model = _buyerArr[0];
//    NSNumber *balance = model.balance;
//    _balanceLabel.text = [NSString stringWithFormat:@"%lu", [balance integerValue]];
//    BuyerModel *buyerModel = _buyerArr[0];
//    NSString *str = buyerModel.userName;
//    [self readBuyerRecord:str];
//    _commodityTableView.dataArr = _buyerRecordArr;
//    [_commodityTableView reloadData];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _buyerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    BuyerModel *model = _buyerArr[indexPath.row];
    cell.userLabel.text = model.userName;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self readBuyer];
    
    BuyerModel *model = _buyerArr[indexPath.row ];
    NSNumber *balance = model.balance;
    NSLog(@"%d", balance.intValue);
    _balanceLabel.text = [NSString stringWithFormat:@"%lu", [balance integerValue]];
    
    
    UserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *str = cell.userLabel.text;
    [self readBuyerRecord:str];
    _commodityTableView.dataArr = _buyerRecordArr;
    [_commodityTableView reloadData];
}

#pragma mark - 数据
//读取买家信息
- (void)readBuyer {
    NSArray *arr = [NSArray arrayWithContentsOfFile:[self filePath:@"user"]];
    if (arr) {
        [_buyerArr removeAllObjects];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            BuyerModel *model = [[BuyerModel alloc] init];
            model.userName = dic[@"userName"];
            model.balance = dic[@"balance"];
            if (!_buyerArr) {
                _buyerArr = [NSMutableArray array];
            }
            [_buyerArr addObject:model];
        }
        [_userTableView reloadData];
    }
}

//读取买家买东西纪录
- (void)readBuyerRecord:(NSString *)name {
    //清空前一个买家的买东西纪录
    if (_buyerRecordArr) {
        [_buyerRecordArr removeAllObjects];
    }
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:[self filePath:name]];
    if (arr) {
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            CommodityModel *model = [[CommodityModel alloc] init];
            model.name = dic[@"name"];
            model.price = dic[@"price"];
            if (!_buyerRecordArr) {
                _buyerRecordArr = [NSMutableArray array];
            }
            [_buyerRecordArr addObject:model];
        }
    }
    
    [_commodityTableView reloadData];
}

- (NSString *)filePath:(NSString *)str {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingFormat:@"/%@.plist", str];
    return filePath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
