//
//  StateShare.h
//  爱购街
//
//  Created by Chrismith on 16/5/23.
//  Copyright © 2016年 01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateShare : NSObject
@property (nonatomic, strong) NSString *name;//记录登录的名字
+ (instancetype)getStateShare;
@end
