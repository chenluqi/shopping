//
//  GoodsDetailViewController.m
//  买买买
//
//  Created by huiwen on 16/2/4.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()

{
    UIScrollView *_bacScrollerView;
    
    UIScrollView *_scrollerView;
    UILabel *_nameLabel;
    UILabel *_priceLabel;
    UILabel *_descriptionLabel;
    UIPageControl *_pageCtrl;
    UIView *_buttomView;
    
    UIWebView *_webView;
    
    int num;
    
    UIView *_tmView;
    
}

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    num = 0;
    
}

- (void)setGoodID:(NSString *)goodID
{
    if (_goodID != goodID) {
        
        _goodID = goodID;
        
        [self requestOfGoods];
        
    }
}

- (void)requestOfGoods
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/items/%@",_goodID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
        //                NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        
        self.homeModel = [[HomeModel alloc] initContentWithDic:dicData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
    }];
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
    [self _createBacScrollerView];
    [self _createScrollerView];
    [self _createLabel];
    [self _createWebView];
    
}

- (void)_createBacScrollerView
{
    _bacScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _bacScrollerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 2 - 64);
    _bacScrollerView.delegate = self;
    _bacScrollerView.showsHorizontalScrollIndicator = NO;
    _bacScrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bacScrollerView];
    
    
}

- (void)_createScrollerView
{
    
    NSString *firstStr = [_homeModel.image_urls firstObject];
    NSString *lastStr = [_homeModel.image_urls lastObject];
    
    [_homeModel.image_urls insertObject:lastStr atIndex:0];
    [_homeModel.image_urls addObject:firstStr];
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 64) * 3 / 5)];
    _scrollerView.delegate = self;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.contentOffset = CGPointMake(kScreenWidth, 0);
    _scrollerView.bounces = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.showsVerticalScrollIndicator = NO;
//    _scrollerView.contentSize = CGSizeMake(kScreenWidth * _homeModel.image_urls.count, (kScreenHeight - 64) * 3 / 5);
    _scrollerView.contentSize = CGSizeMake(kScreenWidth * _homeModel.image_urls.count, -20);
    
    [_bacScrollerView addSubview:_scrollerView];
    
    for (int i = 0; i < _homeModel.image_urls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, (kScreenHeight - 64) * 3 / 5)];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_homeModel.image_urls[i]]];
        
        [_scrollerView addSubview:imageView];
    }
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 64) * 3 / 5 - 30, kScreenWidth, 30)];
    _pageCtrl.backgroundColor = [UIColor clearColor];
    _pageCtrl.numberOfPages = _homeModel.image_urls.count - 2;
    _pageCtrl.currentPage = 0;
    _pageCtrl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [_pageCtrl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventTouchUpInside];
    
    [_bacScrollerView addSubview:_pageCtrl];
}

- (void)_createWebView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, kScreenHeight)];
    _webView.delegate = self;
//    _webView.userInteractionEnabled = NO;
    _webView.scrollView.bounces = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_homeModel.url]];
    
    [_webView loadRequest:request];
    
//    [_bacScrollerView addSubview:_webView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = _scrollerView.contentOffset.x / kScreenWidth - 1;
    
    if (page == _homeModel.image_urls.count - 2) {
        page = 0;
    }
    else if (page == -1)
    {
        page = _homeModel.image_urls.count - 3;
    }
    
    _pageCtrl.currentPage = page;
    
    
    if (_bacScrollerView.contentOffset.y < kScreenHeight - 64 - 30) {
        _webView.scrollView.scrollEnabled = NO;
//        _tmView.hidden = NO;
        _bacScrollerView.scrollEnabled = YES;
    }
    else
    {
        _webView.scrollView.scrollEnabled = YES;
        _bacScrollerView.contentOffset = CGPointMake(_bacScrollerView.contentOffset.x, kScreenHeight - 64 - 30);
//        _tmView.hidden = YES;
        _bacScrollerView.scrollEnabled = NO;
    }
    
    if (_webView.scrollView.contentOffset.y == 0) {
        _bacScrollerView.scrollEnabled = YES;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger page = _scrollerView.contentOffset.x / kScreenWidth - 1;
    
    if (page == _homeModel.image_urls.count - 2) {
        page = 0;
    }
    else if (page == -1)
    {
        page = _homeModel.image_urls.count - 3;
    }
    
    _pageCtrl.currentPage = page;
    
    _scrollerView.contentOffset = CGPointMake((page + 1) * kScreenWidth, _scrollerView.contentOffset.y);
    
}

- (void)changePage
{
    _scrollerView.contentOffset = CGPointMake((_pageCtrl.currentPage + 1) * kScreenWidth, _scrollerView.contentOffset.y);
}

- (void)_createLabel
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenHeight - 64) * 3 / 5, kScreenWidth - 20, (kScreenHeight - 64) / 15)];
    _nameLabel.text = _homeModel.name;
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenHeight - 64) * 2 / 3, kScreenWidth - 20, (kScreenHeight - 64) / 15)];
    _priceLabel.textColor = [UIColor orangeColor];
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_homeModel.price floatValue]];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenHeight - 64) * 11 / 15, kScreenWidth - 20, (kScreenHeight - 64) * 2 / 15)];
    
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = _homeModel.descriptions;
    
    _buttomView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenHeight - 64 - 30, kScreenWidth - 20, 30)];
    
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, (kScreenWidth - 20) / 2, 30)];
    detailButton.backgroundColor = [UIColor whiteColor];
    [detailButton addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setTitle:@"网页详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_buttomView addSubview:detailButton];
    
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, (kScreenWidth - 20) / 2, 30)];
    buyButton.backgroundColor = [UIColor orangeColor];
    [buyButton addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitle:@"买买买" forState:UIControlStateNormal];
    [_buttomView addSubview:buyButton];
    
    
    [_bacScrollerView addSubview:_nameLabel];
    [_bacScrollerView addSubview:_priceLabel];
    [_bacScrollerView addSubview:_descriptionLabel];
    [_bacScrollerView addSubview:_buttomView];
    
}

- (void)detailButtonAction
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_homeModel.url]];
}

- (void)buyButtonAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_homeModel.purchase_url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if (num == 0) {
        num ++;
        
        NSString *htmlStr = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        
        NSString *regex1 = @"viewport";
        NSString *regex2 = @"download";
        NSString *regex3 = @"http://static.liwushuo.com/static/web/apps/liwushuo/img/app_download_3a8b4aa.png";
        NSString *regex4 = @"礼物说";
        NSString *regex5 = @"http://static.liwushuo.com/static/web/apps/liwushuo/img/app_icon_34371a9.png";
        NSString *regex6 = @"www.liwushuo.com";
        
        NSMutableString *str = [[NSMutableString alloc] initWithString:htmlStr];
        
        [str replaceOccurrencesOfRegex:regex1 withString:@""];
        [str replaceOccurrencesOfRegex:regex2 withString:@""];
        [str replaceOccurrencesOfRegex:regex3 withString:@""];
        [str replaceOccurrencesOfRegex:regex4 withString:@"买买买"];
        [str replaceOccurrencesOfRegex:regex5 withString:@""];
        [str replaceOccurrencesOfRegex:regex6 withString:@""];
        
        [_webView loadHTMLString:str baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        
        [_bacScrollerView addSubview:_webView];
        
//        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * (414 - 90) / 414, 0, kScreenWidth * 90 / 414, kScreenWidth * 90 / 414 * 2 / 3)];
//        redView.backgroundColor = [UIColor redColor];
//        [_webView.scrollView addSubview:redView];
        
        _tmView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, kScreenHeight)];
        _tmView.backgroundColor = [UIColor clearColor];
        
//        [_bacScrollerView addSubview:_tmView];
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
