//
//  RightClassifyView.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/18.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RightClassifyView.h"
#import "RightClassifyReusableView.h"
#import "RightClassifyViewCell.h"
#import "ClassSearchViewController.h"
#import "ClassifyViewController.h"

#define identifyClassCell @"ClassCollectionViewCell"
#define identifyClassHeader @"ClassCollectionViewHeader"

@implementation RightClassifyView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[RightClassifyViewCell class] forCellWithReuseIdentifier:identifyClassCell];
        
        [self registerClass:[RightClassifyReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifyClassHeader];
        
    }
    return self;
}

- (void)setModels:(NSMutableArray *)models{
    
    if (_models != models) {
        
        _models = models;
        
        [self reloadData];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float y = self.contentOffset.y;
    
    float rY = 0;
    
    for (int i = 0; i < _models.count; i++) {
        
        ClassifyModel *model = _models[i];
        
        rY += ((model.subcategories.count - 1) / 3 + 1) * (ImgViewWidth + 20) + 3;
        
        if (rY > y) {
            ClassifyViewController *VC = (ClassifyViewController *)self.viewController;
            
            [VC giftClassButtonActionTwo:300 + i];
            
            
            return;
        }
        
    }
}
#pragma mark-delegate

//cell的内容
//里面有多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    ClassifyModel *class = _models[section];
    
    return class.subcategories.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RightClassifyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyClassCell forIndexPath:indexPath];
    ClassifyModel *class = _models[indexPath.section];
    
    ClassifyModel *classifyModel = [[ClassifyModel alloc]initContentWithDic:class.subcategories[indexPath.row]];
    
    cell.classifyModel = classifyModel;
    
    return cell;
}
// 几个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _models.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    RightClassifyReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifyClassHeader forIndexPath:indexPath];
    
    ClassifyModel *headerModel = _models[indexPath.section];
    
//    ClassifyModel *headerClass = [[ClassifyModel alloc]initContentWithDic:headerModel];
    
    header.classifyModel = headerModel;
    
    return header;
    
}

//cell和header的高度

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth - 100, 3);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ImgViewWidth + 20, ImgViewWidth +20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassSearchViewController *classSearchVC = [[ClassSearchViewController alloc]init];
    
    ClassifyModel *model = _models[indexPath.section];
    
    NSMutableArray *array = model.subcategories;
    
    NSDictionary *dic = array[indexPath.row];
    
    ClassifyModel *classifyModel = [[ClassifyModel alloc]initContentWithDic:dic];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/item_subcategories/%@/items",model.id];
    classSearchVC.urlString = urlString;
    classSearchVC.title = classifyModel.name;
    
    [self.viewController.navigationController pushViewController:classSearchVC animated:YES];
    
}

@end
