//
//  GoodsDetailViewController.h
//  买买买
//
//  Created by huiwen on 16/2/4.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "SelectViewController.h"

@interface GoodsDetailViewController : SelectViewController <UIScrollViewDelegate,UIWebViewDelegate>


@property(nonatomic,copy)NSString *goodID;
@property(nonatomic,strong)HomeModel *homeModel;

@end
