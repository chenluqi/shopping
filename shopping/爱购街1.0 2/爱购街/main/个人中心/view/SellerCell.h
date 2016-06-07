//
//  SellerCell.h
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface SellerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) HomeModel *homeModel;

@end
