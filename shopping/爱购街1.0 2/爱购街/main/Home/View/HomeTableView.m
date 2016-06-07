//
//  HomeTableView.m
//  买买买
//
//  Created by Jhwilliam on 16/2/1.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeTableViewCell.h"

#define identify @"HomeTableViewCell"

@implementation HomeTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[HomeTableViewCell class] forCellReuseIdentifier:identify];
    }
    
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kScreenWidth * 4 / 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    cell.homeModel = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *homeModel = _models[indexPath.row];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.liwushuo.com/posts/%@",homeModel.id]]];
    WebViewController *webVC = [[WebViewController alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"http://www.liwushuo.com/posts/%@",homeModel.id];
    
    webVC.url = urlString;
    
    [self.viewController.navigationController pushViewController:webVC animated:YES];
    
    
}

- (void)setModels:(NSMutableArray *)models
{
    if (_models != models) {
        _models = models;
    }
    
    [self reloadData];
}

@end
