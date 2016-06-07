//
//  RootTabBarItem.m
//  爱购街
//
//  Created by Jhwilliam on 16/1/29.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RootTabBarItem.h"


@implementation RootTabBarItem
{
    UILabel *titleLabel;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)name title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        //1. 创建子视图
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - 25)/2, 5, 25, 25)];
        imgView.image = [UIImage imageNamed:name];
         imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imgView];
        //2.创建标题视图
        //getMaxY表示拿到imgView的y方向的最大值
        
        CGFloat maxY = CGRectGetMaxY(imgView.frame);
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, maxY, frame.size.width, 20)];
        
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self addSubview:titleLabel];
          self.selected = NO;
    }
  
  
    return self;
}

- (void)setIsSelect:(BOOL)isSelect{
    
    if (_isSelect != isSelect) {
        _isSelect = isSelect;
        
        if (_isSelect) {
            
            titleLabel.textColor = [UIColor orangeColor];
        }else{
            
            titleLabel.textColor = [UIColor grayColor];
        }
    }
}
@end
