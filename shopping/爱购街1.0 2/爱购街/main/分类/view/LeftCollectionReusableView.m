//
//  LeftCollectionReusableView.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "LeftCollectionReusableView.h"

@implementation LeftCollectionReusableView
{
    UILabel *_titleLabel;
    UIView *_topView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
        _topView.backgroundColor = [UIColor grayColor];
    
        [self addSubview:_topView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        _titleLabel.textColor = [UIColor blackColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:4];
        
        [_topView addSubview:_titleLabel];
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
    
    _titleLabel.text = _classifyModel.name;
    
}
@end
