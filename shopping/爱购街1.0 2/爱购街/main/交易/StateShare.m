//
//  StateShare.m
//  爱购街
//
//  Created by Chrismith on 16/5/23.
//  Copyright © 2016年 01. All rights reserved.
//

#import "StateShare.h"

static StateShare *state = nil;
@implementation StateShare

+ (instancetype)getStateShare {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        state = [[self alloc] init] ;
    }) ;
    
    return state;
}

@end
