//
//  CollectionsImageView.m
//  买买买
//
//  Created by huiwen on 16/1/31.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "CollectionsImageView.h"
#import "CollectionsViewController.h"
@implementation CollectionsImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
//        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return self;
}

- (void)setHomeModel:(HomeModel *)homeModel
{
    if (_homeModel != homeModel) {
        
        _homeModel = homeModel;
        
        [self configView];
    }
}

- (void)configView
{
    [self sd_setImageWithURL:[NSURL URLWithString:_homeModel.image_url]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (!_homeModel.type) {
        NSString *targetUrl = _homeModel.target_url;
        
        NSString *regrx1 = @"type=\\w+&";
        NSString *textType;
        NSArray *result1 = [targetUrl componentsMatchedByRegex:regrx1];
        for (int i = 0; i < result1.count; i++) {
            textType = result1[i];
        }
        
        textType = [textType substringWithRange:NSMakeRange(5, textType.length - 6)];
        
        _homeModel.type = textType;
        
        if ([_homeModel.type isEqualToString:@"url"]) {
            NSString *regrx2 = @"url=.*";
            NSString *textUrl;
            NSArray *result2 = [targetUrl componentsMatchedByRegex:regrx2];
            for (int i = 0; i < result2.count; i++) {
                textUrl = result2[i];
            }
            
            textUrl = [textUrl substringWithRange:NSMakeRange(4, textUrl.length - 4)];
            textUrl = [textUrl stringByReplacingOccurrencesOfRegex:@"%3A" withString:@":"];
            textUrl = [textUrl stringByReplacingOccurrencesOfRegex:@"%2F" withString:@"/"];
            
            _homeModel.target_url = textUrl;
        }
        else
        {
            NSString *regrx3 = @"id=\\d{3,8}";
            NSString *textId;
            NSArray *result3 = [targetUrl componentsMatchedByRegex:regrx3];
            for (int i = 0; i < result3.count; i++) {
                textId = result3[i];
            }
            textId = [textId substringWithRange:NSMakeRange(3, textId.length - 3)];
            
            _homeModel.target_id = textId;
        }
        
    }
    
    if ([_homeModel.type isEqualToString:@"url"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_homeModel.target_url]];
    }
    else if ([_homeModel.type isEqualToString:@"post"]) {
         
         NSString *urlStr = [NSString stringWithFormat:@"http://www.liwushuo.com/posts/%@",_homeModel.target_id];
         
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else if ([_homeModel.type isEqualToString:@"collection"] || [_homeModel.type isEqualToString:@"topic"])
    {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/collections/%@/posts",_homeModel.target_id];
        
        CollectionsViewController *colVC = [[CollectionsViewController alloc] init];
        colVC.urlString = urlStr;
        
        [self.viewController.navigationController pushViewController:colVC animated:YES];
        
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
