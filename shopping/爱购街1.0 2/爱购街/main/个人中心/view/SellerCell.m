//
//  SellerCell.m
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import "SellerCell.h"

@implementation SellerCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHomeModel:(HomeModel *)homeModel {
    if (_homeModel != homeModel) {
        _homeModel = homeModel;
        self.priceLabel.text = [NSString stringWithFormat:@"%lu", [_homeModel.price integerValue]];
        self.nameLabel.text = _homeModel.name;
    }
}

@end
