//
//  RootTabBarItem.h
//  爱购街
//
//  Created by Jhwilliam on 16/1/29.
//  Copyright © 2016年 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabBarItem : UIControl


- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)name title:(NSString *)title;

@property (nonatomic,assign) BOOL isSelect;

@end
