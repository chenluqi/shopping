//
//  CommodityCell.m
//  爱购街
//
//  Created by Chrismith on 16/5/21.
//  Copyright © 2016年 01. All rights reserved.
//

#import "CommodityCell.h"

@implementation CommodityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CommodityModel *)model {
    if (_model != model) {
        _model = model;
        
        _nameLabel.text = model.name;
        _priceLabel.text = [NSString stringWithFormat:@"%lu", [model.price integerValue]];
    }
}

@end
