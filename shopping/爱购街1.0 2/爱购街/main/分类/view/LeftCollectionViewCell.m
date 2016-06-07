//
//  LeftCollectionViewCell.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "LeftCollectionViewCell.h"

@implementation LeftCollectionViewCell
{
     UILabel *_themeLabel;
     UIImageView *_themeImgView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _themeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, ImgViewWidth, ImgViewWidth)];
        _themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, ImgViewWidth + 20, ImgViewWidth, 25)];
        _themeLabel.textAlignment = NSTextAlignmentCenter;
        _themeLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_themeImgView];
        [self.contentView addSubview:_themeLabel];
        
    }
    return self;
}

- (void)setClassifyModel:(ClassifyModel *)classifyModel{
    if (_classifyModel != classifyModel) {
        _classifyModel = classifyModel;
        
        [self configData];
    }
}

- (void)configData{
    
    [_themeImgView sd_setImageWithURL:[NSURL URLWithString:_classifyModel.icon_url]];
    
    _themeLabel.text = _classifyModel.name;
}


@end
