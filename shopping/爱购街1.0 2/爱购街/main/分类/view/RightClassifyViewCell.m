//
//  RightClassifyViewCell.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RightClassifyViewCell.h"

@implementation RightClassifyViewCell
{
    UIImageView *_imgView;
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, ImgViewWidth + 8, ImgViewWidth - 5)];
        [self.contentView addSubview:_imgView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, ImgViewWidth + 9, ImgViewWidth + 15, 20)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:11];
        
        [self.contentView addSubview:_label];
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
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_classifyModel.icon_url]];
    
    _label.text = _classifyModel.name;
    
}
@end
