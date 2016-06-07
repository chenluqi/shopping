//
//  LeftCollectionView.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "LeftCollectionView.h"
#import "LeftCollectionViewCell.h"
#import "LeftCollectionReusableView.h"
#import "UIView+ViewController.h"
#import "CollectionsViewController.h"

#define identifyClass @"ClassCollectionViewCell"
#define identifyClassHeader @"ClassCollectionViewHeaderCell"

@implementation LeftCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[LeftCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifyClassHeader];
        
        [self registerClass:[LeftCollectionViewCell class] forCellWithReuseIdentifier:identifyClass];
        
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        
        [self reloadData];
    }
}

#pragma mark- delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ClassifyModel *class = _dataArray[section];
    
    return class.channels.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyClass forIndexPath:indexPath];
    ClassifyModel *model = _dataArray[indexPath.section];
    
    ClassifyModel *classifyModel = [[ClassifyModel alloc]initContentWithDic:model.channels[indexPath.row]];
    
    cell.classifyModel = classifyModel;
    
    return cell;
    
}

//组的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _dataArray.count;
}

//上面的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ImgViewWidth + 30 , ImgViewWidth + 50 );
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    LeftCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifyClassHeader forIndexPath:indexPath];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    ClassifyModel *classify = _dataArray[indexPath.section];
    headerView.classifyModel = classify;
    
    return headerView;
}

//点击上面的小图标后跳转的画面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionsViewController *collectionsVC = [[CollectionsViewController alloc]init];
    
    ClassifyModel *model = _dataArray[indexPath.section];
    NSMutableArray *array = model.channels;
    NSDictionary *dic = array[indexPath.row];
    
    ClassifyModel *classifyModel = [[ClassifyModel alloc]initContentWithDic:dic];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/collections/%@/posts",classifyModel.id];
    collectionsVC.urlString = urlString;
    
    [self.viewController.navigationController pushViewController:collectionsVC animated:NO];
}
@end
