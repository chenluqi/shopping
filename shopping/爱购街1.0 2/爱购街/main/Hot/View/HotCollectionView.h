//
//  HotCollectionView.h
//  买买买
//
//  Created by huiwen on 16/2/3.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSArray *models;

@end
