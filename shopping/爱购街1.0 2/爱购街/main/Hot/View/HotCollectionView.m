//
//  HotCollectionView.m
//  买买买
//
//  Created by huiwen on 16/2/3.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "HotCollectionView.h"
#import "HotCollectionViewCell.h"
#import "GoodsDetailViewController.h"
#define identifyHot @"HotCollectionViewCell"
#define identifyHotHeader @"HotCollectionViewHeaderCell"
#import "LoginViewController.h"
#import "StateShare.h"
#import "TransactionController.h"

@implementation HotCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self registerClass:[HotCollectionViewCell class] forCellWithReuseIdentifier:identifyHot];
        
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifyHotHeader];
        
    }
    
    return self;
}

- (void)setModels:(NSMutableArray *)models
{
    if (_models != models) {
        _models = models;
    }
    
    [self reloadData];
    
}


#pragma mark - UICollectionView delegate
//1、指定组的个数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 2;
//    
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _models.count;
//    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyHot forIndexPath:indexPath];
//    HomeModel *model = _models[indexPath.row];
    
    cell.homeModel = _models[indexPath.row];
    
    return cell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((kScreenWidth - 30) / 2, (kScreenWidth - 30) * 3 / 4);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"购买" message:@"请选择" preferredStyle:UIAlertControllerStyleAlert];
    HomeModel *model = _models[indexPath.row];
    
    //查看商品详情
    [alerController addAction:[UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GoodsDetailViewController *goodCtrl = [[GoodsDetailViewController alloc] init];
        goodCtrl.goodID = model.id;
        
        [self.viewController.navigationController pushViewController:goodCtrl animated:YES];
    }]];
    
    //购买，交易
    
    __block HotCollectionView *this = self;
    __block HomeModel *blockModel = model;
    [alerController addAction:[UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([this loginState]) {
            TransactionController *transaction = [[TransactionController alloc] init];
            transaction.model = blockModel;
            [this.viewController presentViewController:transaction animated:YES completion:nil];
        }else {
            
        }
        
    }]];
    [self.viewController presentViewController:alerController animated:YES completion:^{
        
    }];

}

//判断是否登录
- (BOOL)loginState {
    StateShare *state = [StateShare getStateShare];
    if (state.name) {
        return YES;
    }else {
        return NO;
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifyHeader forIndexPath:indexPath];
//    
//    headerView.backgroundColor = [UIColor redColor];
//    return headerView;
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
