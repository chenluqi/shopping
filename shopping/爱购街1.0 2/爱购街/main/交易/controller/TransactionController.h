//
//  TransactionController.h
//  爱购街
//
//  Created by Chrismith on 16/5/23.
//  Copyright © 2016年 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface TransactionController : UIViewController
@property (nonatomic, strong) HomeModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *peyButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic,copy) NSString *sellerName;

@end
