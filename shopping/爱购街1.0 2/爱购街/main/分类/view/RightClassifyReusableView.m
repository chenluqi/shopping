//
//  RightClassifyReusableView.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RightClassifyReusableView.h"

@implementation RightClassifyReusableView
{
    UILabel *_titleLabel;
    UIView *_grayView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 100 - 80)/2, 10, 100, 25)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreenWidth - 100, 3)];
        _grayView.backgroundColor = [UIColor grayColor];
        
        [self addSubview:_grayView];
        
    }
    return self;
}

- (void)setClassifyModel:(ClassifyModel *)classifyModel{
    if (_classifyModel != classifyModel ) {
        _classifyModel = classifyModel;
        
        [self configData];
    }
}

- (void)configData{
    
    _titleLabel.text = _classifyModel.name;
   
}
@end
