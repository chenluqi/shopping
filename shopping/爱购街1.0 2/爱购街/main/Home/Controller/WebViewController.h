//
//  WebViewController.h
//  买买买
//
//  Created by 洪曦尘 on 16/2/20.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "SelectViewController.h"

@interface WebViewController : SelectViewController <UIWebViewDelegate>

@property (nonatomic,copy) NSString *url;

@end
