//
//  RightClassifyView.h
//  爱购街
//
//  Created by Jhwilliam on 16/2/18.
//  Copyright © 2016年 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightClassifyView : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *models;
@end
