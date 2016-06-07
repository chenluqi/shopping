//
//  LeftCollectionView.h
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray *dataArray;

@end
