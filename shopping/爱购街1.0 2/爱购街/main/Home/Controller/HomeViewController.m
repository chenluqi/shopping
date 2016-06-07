//
//  HomeViewController.m
//  买买买
//
//  Created by huiwen on 16/1/31.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "HomeViewController.h"
#import "TextSearchViewController.h"
#import "CollectionsImageView.h"
#import "LocationButton.h"
#import "ScanViewController.h"
#import "RootNavigationController.h"
@interface HomeViewController ()

{
    UIScrollView *_topButtonScrollerView;
    UIScrollView *_topImageViewScrollerView;
    UIScrollView *_midImageViewScrollerView;
    UIPageControl *_pageCtrl;
    HomeTableView *_tableView;
    
    UIView *_selectView;
    NSInteger _buttonTag;
    
    NSMutableArray *_arrButton;  //第一排的数据
    NSMutableArray *_arrImageViewTop;  //第二排的数据
    NSMutableArray *_arrImageViewMid;  //第三排的数据
    NSMutableArray *_arrTableView;  //第四排的数据
    
    NSTimer *_timer;
    
    BOOL _isInside;
    
    NSDictionary *_params;
    
    NSInteger _offset;
    
    LocationButton *_locationButton;//定位按钮
    
    UIButton *_searchButton;//搜索按钮
    UIButton *_scanButton;//扫码按钮

    
}

@end

@implementation HomeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _locationButton.hidden = YES;
    _searchButton.hidden = YES;
    _scanButton.hidden = YES;
  
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    _locationButton.hidden = NO;
    _searchButton.hidden = NO;
    _scanButton.hidden = NO;
   

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _params = @{
                @"limit"  :  @20,
                @"ad" :  @2,
                @"gender" :	@1,
                @"offset" :	@0,
                @"generation" :	@2
                };
    
    _offset = 0;
    
    _buttonTag = 200;
    
    [self _createUI];
    
    
}


//先网络请求，再创建，第一个直接放在self.view上面  第二个和第三个放在tableView的headerView里
- (void)_createUI
{
    [self _createNavBar];
    
    [self requestOfButtonScrollerView];
    
    HomeModel *homeModel = _arrButton[0];
    
    [self requestOfTableViewWithId:homeModel.id type:1];
    
   
    
}

- (void)_createNavBar
{
    //搜索按钮
    _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 30, 9, 25, 25)];
    [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setImage:[UIImage imageNamed:@"Search_fruitless@2x"] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar addSubview:_searchButton];
    
     //定位
    _locationButton = [[LocationButton alloc]initWithFrame:CGRectMake(5, 7, 80, 30)];
    
    [self.navigationController.navigationBar addSubview:_locationButton];
    
    //扫码
    _scanButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 9, 25, 25)];
    [_scanButton setImage:[UIImage imageNamed:@"Explore_ScanButton@2x.png"] forState:UIControlStateNormal];
    _scanButton.backgroundColor = [UIColor orangeColor];
    [self.navigationController.navigationBar addSubview:_scanButton];
    
    [_scanButton addTarget:self action:@selector(scanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    
}

//搜索按钮点击后的效果
- (void)searchButtonAction:(UIButton *)button{
    
    TextSearchViewController *textSearchVC = [[TextSearchViewController alloc] init];
    textSearchVC.urlString = @"http://api.liwushuo.com/v2/search/hot_words";
    
    [self.navigationController pushViewController:textSearchVC animated:YES];
}

//扫码按钮的效果
- (void)scanButtonAction:(UIButton*)button{
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    
    RootNavigationController *root = [[RootNavigationController alloc]initWithRootViewController:scanVC];
    
    
    
    [self presentViewController:root animated:YES completion:NULL];
    //    [self.navigationController pushViewController:root animated:YES];
}



#pragma mark ---第一排
//第一排开始

//网络请求
- (void)requestOfButtonScrollerView
{
    _arrButton = [[NSMutableArray alloc] init];
    NSDictionary *dicFirst = @{
                               @"id" : @"101",
                               @"name" : @"精选"
                               };
    HomeModel *model = [[HomeModel alloc] initContentWithDic:dicFirst];
    [_arrButton addObject:model];
    
    NSString *urlString = @"http://api.liwushuo.com/v2/channels/preset";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    NSDictionary *params = @{
                             @"gender" : @1,
                             @"generation" : @2
                             };
    
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
        //        NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"candidates"];
        
        for (NSDictionary *dic in arrBanners) {
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            [_arrButton addObject:homeModel];
        }
        
        [self _createButtonScrollerView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
    }];
}



//最上面一排button分类
- (void)_createButtonScrollerView
{
    
    _topButtonScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    //不设置成负的就会上下滚动？只有第一个创建的scrollerView才会有这种情况
    
    _topButtonScrollerView.showsHorizontalScrollIndicator = NO;
    _topButtonScrollerView.showsVerticalScrollIndicator = NO;
    _topButtonScrollerView.bounces = NO;
    _topButtonScrollerView.contentSize = CGSizeMake(70 * _arrButton.count, -200);
    
    [self.view addSubview:_topButtonScrollerView];
    
    for (int i = 0; i < _arrButton.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70 * i, 0, 70, 40)];
        button.tag = 200 + i;
        
        HomeModel *homeModel = _arrButton[i];
        
        [button setTitle:homeModel.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topButtonScrollerView addSubview:button];
        
    }
    
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 3, 70, 3)];
    _selectView.backgroundColor = [UIColor orangeColor];
    
    [_topButtonScrollerView addSubview:_selectView];
    
}

- (void)buttonAction:(UIButton *)button
{
    if (_buttonTag != button.tag) {
        
        _buttonTag = button.tag;
        
        HomeModel *homeModel = _arrButton[button.tag - 200];
        
        [self requestOfTableViewWithId:homeModel.id type:1];
        
        _selectView.frame = CGRectMake(70 * (button.tag - 200), 40 - 3, 70, 3);
        
        float x = 70 * (button.tag - 201);
        if (x < 0) {
            x = 0;
        }
        else if (x > _arrButton.count * 70 - kScreenWidth) {
            x = _arrButton.count * 70 - kScreenWidth;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            _topButtonScrollerView.contentOffset = CGPointMake(x, _topButtonScrollerView.contentOffset.y);
        }];
        
    }
}

//第一排结束


#pragma mark ---第二排
//第二排开始

//网络请求
- (void)requestOfTopImageViewScrollerView
{
    _arrImageViewTop = [[NSMutableArray alloc] init];
    
    NSString *urlString = @"http://api.liwushuo.com/v2/banners";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
//        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
//        NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"banners"];
        
        for (NSDictionary *dic in arrBanners) {
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            if ([homeModel.type isEqualToString:@"collection"]) {
                [_arrImageViewTop addObject:homeModel];
            }
        }
        
        HomeModel *firstModel = [_arrImageViewTop firstObject];
        HomeModel *lastModel = [_arrImageViewTop lastObject];
        
        [_arrImageViewTop insertObject:lastModel atIndex:0];
        [_arrImageViewTop addObject:firstModel];
        
        [self _createTopImageViewScrollerView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
    }];
}

//上面三张大图
- (void)_createTopImageViewScrollerView
{
    
    _topImageViewScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 3 / 7)];
    _topImageViewScrollerView.delegate = self;
    _topImageViewScrollerView.pagingEnabled = YES;
    _topImageViewScrollerView.contentOffset = CGPointMake(kScreenWidth, 0);
    _topImageViewScrollerView.bounces = NO;
    _topImageViewScrollerView.showsHorizontalScrollIndicator = NO;
    _topImageViewScrollerView.contentSize = CGSizeMake(kScreenWidth * _arrImageViewTop.count, kScreenWidth * 3 / 7);
    
    [_tableView.tableHeaderView addSubview:_topImageViewScrollerView];
    
    for (int i = 0; i < _arrImageViewTop.count; i++) {
        CollectionsImageView *imageView = [[CollectionsImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenWidth * 3 / 7)];
        
        //加这句就会往左偏移一点  为什么？商品详情里就不会这样
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        HomeModel *homeModel = _arrImageViewTop[i];
        
        imageView.homeModel = homeModel;
        
        [_topImageViewScrollerView addSubview:imageView];
    }
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenWidth * 3 / 7 - 30, kScreenWidth, 30)];
    _pageCtrl.backgroundColor = [UIColor clearColor];
    _pageCtrl.numberOfPages = _arrImageViewTop.count - 2;
    _pageCtrl.currentPage = 0;
    [_pageCtrl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventTouchUpInside];
    
    [_tableView.tableHeaderView addSubview:_pageCtrl];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
}

- (void)timerAction
{
    [UIView animateWithDuration:0.3 animations:^{
        _topImageViewScrollerView.contentOffset = CGPointMake(_topImageViewScrollerView.contentOffset.x + kScreenWidth, _topImageViewScrollerView.contentOffset.y);
        
    }];
    
    [self scrollViewDidEndDecelerating:_topImageViewScrollerView];
//    [self scrollViewDidScroll:_topImageViewScrollerView];
}

//touch方法都不会进，只有在这里把计时器清零

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [_timer invalidate];
    
    NSInteger page = _topImageViewScrollerView.contentOffset.x / kScreenWidth - 1;
    
    if (page == _arrImageViewTop.count - 2) {
        page = 0;
    }
    else if (page == -1)
    {
        page = _arrImageViewTop.count - 3;
    }
    
    _pageCtrl.currentPage = page;
    
//    _topImageViewScrollerView.contentOffset = CGPointMake((page + 1) * kScreenWidth, _topImageViewScrollerView.contentOffset.y);
    
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [_timer invalidate];
    
    NSInteger page = _topImageViewScrollerView.contentOffset.x / kScreenWidth - 1;
    
    if (page == _arrImageViewTop.count - 2) {
        page = 0;
    }
    else if (page == -1)
    {
        page = _arrImageViewTop.count - 3;
    }
    
    _pageCtrl.currentPage = page;
    
    _topImageViewScrollerView.contentOffset = CGPointMake((page + 1) * kScreenWidth, _topImageViewScrollerView.contentOffset.y);
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

- (void)changePage
{
    _topImageViewScrollerView.contentOffset = CGPointMake((_pageCtrl.currentPage + 1) * kScreenWidth, _topImageViewScrollerView.contentOffset.y);
}
//第二排结束


#pragma mark ---第三排
//第三排开始

//网络请求
- (void)requestOfMidImageViewScrollerView
{
    _arrImageViewMid = [[NSMutableArray alloc] init];
    
    NSString *urlString = @"http://api.liwushuo.com/v2/secondary_banners";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    NSDictionary *params = @{
                             @"gender" : @1,
                             @"generation" : @2
                             };
    
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
//        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
//        NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"secondary_banners"];
        
        for (NSDictionary *dic in arrBanners) {
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            [_arrImageViewMid addObject:homeModel];
        }
        
        [self _createMidImageViewScrollerView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
    }];
}

//中间一排小图
- (void)_createMidImageViewScrollerView
{
    //    NSArray *arr = @[[UIColor redColor],[UIColor orangeColor],[UIColor redColor],[UIColor orangeColor],[UIColor redColor],[UIColor orangeColor],[UIColor redColor]];
    
    _midImageViewScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImageViewScrollerView.frame), kScreenWidth, 100 * kScreenWidth / 414)];
    _midImageViewScrollerView.contentSize = CGSizeMake((100 * kScreenWidth / 414 - 10) * _arrImageViewMid.count + 10, 100 * kScreenWidth / 414);
    _midImageViewScrollerView.showsHorizontalScrollIndicator = NO;
    _midImageViewScrollerView.showsVerticalScrollIndicator = NO;
    _midImageViewScrollerView.bounces = NO;
    
    [_tableView.tableHeaderView addSubview:_midImageViewScrollerView];
    
    for (int i = 0; i < _arrImageViewMid.count; i++) {
        CollectionsImageView *imageView = [[CollectionsImageView alloc] initWithFrame:CGRectMake((100 * kScreenWidth / 414 - 10) * i + 10, 10, 100 * kScreenWidth / 414 - 20, 100 * kScreenWidth / 414 - 20)];
        
        HomeModel *homeModel = _arrImageViewMid[i];
        
        imageView.homeModel = homeModel;
        
        [_midImageViewScrollerView addSubview:imageView];
    }
    
}

//第三排结束


#pragma mark ---第四排
//第四排开始

//网络请求

//type 1代表初始 2代表排序 3代表加载更多 4代表刷新

- (void)requestOfTableViewWithId:(NSString *)dataId type:(NSInteger)type
{
//    _arrTableView = [[NSMutableArray alloc] init];
    
    if (type == 1 || type == 2 || type == 4) {
        _arrTableView = nil;
        
        _arrTableView = [[NSMutableArray alloc] init];
        
        _offset = 0;
        
    }
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_params];
    
    [par removeObjectForKey:@"offset"];
    [par setObject:@(_offset) forKey:@"offset"];
    _params = par;
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/channels/%@/items",dataId];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:urlString parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
        //        NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrItems = dicData[@"items"];
        
        for (NSDictionary *dic in arrItems) {
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            [_arrTableView addObject:homeModel];
        }
        
//        [self _createTableViewWithImageView];
        
        if (type == 1) {
            [self _createTableViewWithImageView];
        }
        
        if (type == 2 || type == 3 || type == 4) {
            _tableView.models = _arrTableView;
        }
        
        [self stopRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
        
        [self stopRefresh];
        
    }];
}

//下面的tableView
- (void)_createTableViewWithImageView
{
    HomeModel *homeModel = _arrButton[0];
    
    [_tableView removeFromSuperview];
    [_topImageViewScrollerView removeFromSuperview];
    [_midImageViewScrollerView removeFromSuperview];
    [_pageCtrl removeFromSuperview];
    [_timer invalidate];
    
    _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 64 - 49) style:UITableViewStylePlain];
    _tableView.models = _arrTableView;
    
    [self.view addSubview:_tableView];
    
    if (_buttonTag == 200) {
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 3 / 7 + 100 * kScreenWidth / 414)];
        
        [self requestOfTopImageViewScrollerView];
        
        [self requestOfMidImageViewScrollerView];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    [_tableView addPullDownRefreshBlock:^{
        
        _offset = 0;
        
        [weakSelf requestOfTableViewWithId:homeModel.id type:4];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        _offset += 20;
        
        [weakSelf requestOfTableViewWithId:homeModel.id type:3];
        
    }];
    
    
}

- (void)stopRefresh
{
    [_tableView.pullToRefreshView stopAnimating];
    [_tableView.infiniteScrollingView stopAnimating];
}

//第四排结束


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
