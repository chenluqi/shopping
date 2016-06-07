//
//  SellerView.m
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import "SellerView.h"
#import "SellerCell.h"

#define kViewHeight self.frame.size.height
#define kViewWidth self.frame.size.width
@implementation SellerView {
    
    UILabel *_nameLabel;
    UILabel *_balanceLabel;
    UITableView *_tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadChildView];
        
        [self readSeller];
    }
    
    return self;
}

- (void)setSellerArr:(NSArray *)sellerArr {
    if (_sellerArr != sellerArr) {
        _sellerArr = sellerArr;
        
        NSDictionary *sellerDic = _sellerArr[0];
        _nameLabel.text = sellerDic[@"name"];
        NSNumber *balance = sellerDic[@"balance"];
        _balanceLabel.text = [NSString stringWithFormat:@"%lu",  [balance integerValue]];
        
        [self readSellerRecord:sellerDic[@"name"]];
    }
}

#pragma mark - view
- (void)loadChildView {
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kViewWidth / 4, kViewHeight / 2)];
    _nameLabel.text = @"zhangsan";
    _nameLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    _nameLabel.numberOfLines = 0;
    [self addSubview:_nameLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _nameLabel.frame.size.height, kViewWidth / 4, kViewHeight - _nameLabel.frame.size.height)];
    _balanceLabel.text = @"1000.00";
    _balanceLabel.textColor = [UIColor redColor];
    _balanceLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _balanceLabel.numberOfLines = 0;
    [self addSubview:_balanceLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kViewWidth / 4, 0, kViewWidth * 3 / 4, kViewHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"SellerCell" bundle:nil] forCellReuseIdentifier:@"SellerCell"];
    [self addSubview:_tableView];
}

#pragma mark - table view delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _sellerRecordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellerCell" forIndexPath:indexPath];
    NSDictionary *dic = _sellerRecordArr[indexPath.row];
    cell.nameLabel.text = dic[@"name"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%lu", [dic[@"price"] integerValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 数据

//读取商家的信息
- (void)readSeller {
    _sellerArr = [NSArray arrayWithContentsOfFile:[self filePath:@"seller"]];
    if (_sellerArr) {
        NSDictionary *sellerDic = _sellerArr[0];
        _nameLabel.text = sellerDic[@"name"];
        NSNumber *balance = sellerDic[@"balance"];
        _balanceLabel.text = [NSString stringWithFormat:@"%lu",  [balance integerValue]];
        
        [self readSellerRecord:sellerDic[@"name"]];
    }
}

//读取商家的售卖记录
- (void)readSellerRecord:(NSString *)seller {
    _sellerRecordArr = [NSArray arrayWithContentsOfFile:[self filePath:[NSString stringWithFormat:@"商家_%@", seller]]];
    if (_sellerRecordArr) {
        [_tableView reloadData];
    }
}

//获取文件在沙盒里document的路径
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
