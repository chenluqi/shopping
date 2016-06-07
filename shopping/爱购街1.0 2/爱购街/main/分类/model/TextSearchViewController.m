//
//  TextSearchViewController.m
//  买买买
//
//  Created by ji on 16/2/5.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "TextSearchViewController.h"
#import "HomeTableView.h"

@interface TextSearchViewController ()

{
    HotCollectionView *_collectionView;
    NSMutableArray *_arrCollectionView;
    
    HomeTableView *_tableView;
    NSMutableArray *_arrTableView;
    
    UIButton *_orderBacButton;
    UIImageView *_selectView;
    
    UIButton *_orderButton;
    
    NSDictionary *_paramsCol;
    NSDictionary *_paramsTab;
    
    NSInteger _offsetCol;
    NSInteger _offsetTab;
    
    NSString *_keyword;
    
    NSMutableArray *_arrHotwords;
    
    UITextField *_searchTextFiled;
    
    UIButton *_searchButton;
    
    UIButton *_tacticButton;
    UIButton *_giftButton;
    
    UIScrollView *_backgroundScrollerView;
    
}

@end

@implementation TextSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _orderButton.hidden = NO;
    _searchTextFiled.hidden = NO;
    _searchButton.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _orderButton.hidden = YES;
    _searchTextFiled.hidden = YES;
    _searchButton.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _paramsCol = @{
                @"limit" :@20,
                @"offset" :@0
                };
    
    _offsetCol = 0;
    
    _paramsTab = @{
                   @"limit" :@20,
                   @"offset" :@0
                   };
    
    _offsetTab = 0;
    
}

#pragma mark ---搜索

#pragma mark ---搜索结果

- (void)_createBackgroundView
{
    //这个必须先加，第一scrollerView好像会在最上面预留一块位置，第一个scrollerView都有点奇怪
    
    _backgroundScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    //    _backgroundScrollerView.backgroundColor = [UIColor whiteColor];
    _backgroundScrollerView.contentSize = CGSizeMake(kScreenWidth * 2, -20);
    _backgroundScrollerView.delegate = self;
    _backgroundScrollerView.bounces = NO;
    _backgroundScrollerView.pagingEnabled = YES;
    _backgroundScrollerView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollerView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_backgroundScrollerView];
    
    _tacticButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 0, kScreenWidth / 2, 40)];
    _tacticButton.tag = 300;
    [_tacticButton setTitle:@"攻略" forState:UIControlStateNormal];
    _tacticButton.backgroundColor = [UIColor orangeColor];
    [_tacticButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tacticButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [_tacticButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_tacticButton];
    
    _giftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 40)];
    _giftButton.tag = 301;
    [_giftButton setTitle:@"礼物" forState:UIControlStateNormal];
    _giftButton.backgroundColor = [UIColor whiteColor];
    [_giftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _giftButton.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [_giftButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_giftButton];
    
}

- (void)selectTacticButton
{
    _tacticButton.backgroundColor = [UIColor whiteColor];
    [_tacticButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    _giftButton.backgroundColor = [UIColor orangeColor];
    [_giftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        _backgroundScrollerView.contentOffset = CGPointMake(kScreenWidth, _backgroundScrollerView.contentOffset.y);
    }];
    
}

- (void)selectGiftButton
{
    _tacticButton.backgroundColor = [UIColor orangeColor];
    [_tacticButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _giftButton.backgroundColor = [UIColor whiteColor];
    [_giftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4 animations:^{
        _backgroundScrollerView.contentOffset = CGPointMake(0, _backgroundScrollerView.contentOffset.y);
    }];
    
}

- (void)topButtonAction:(UIButton *)button
{
    
    if (button.tag == 300)
    {
        
        [self selectTacticButton];
        
    }
    else if (button.tag == 301)
    {
        
        [self selectGiftButton];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_backgroundScrollerView.contentOffset.x > kScreenWidth / 2)
    {
        [self selectTacticButton];
    }
    else
    {
        [self selectGiftButton];
    }
    
}

#pragma mark ---排序

- (void)_createOrderView
{
    
    _orderButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 10, 40, 25)];
    [_orderButton addTarget:self action:@selector(bacButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_orderButton setTitle:@"排序" forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar addSubview:_orderButton];
    
    _orderBacButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _orderBacButton.hidden = YES;
    [_orderBacButton addTarget:self action:@selector(bacButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _orderBacButton.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_orderBacButton];
    
    NSArray *arr = @[@"默认排序",@"按热度排序",@"价格由低到高",@"价格由高到低"];
    
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 120, i * 40, 120, 40)];
        button.tag = 500 + i;
        button.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.85];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_orderBacButton addSubview:button];
        
    }
    
    _selectView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30, 10, 20, 20)];
    _selectView.image = [UIImage imageNamed:@"icon_checked-1"];
    
    [_orderBacButton addSubview:_selectView];
    
    
}

- (void)bacButtonAction:(UIButton *)button
{
    _orderBacButton.hidden = !_orderBacButton.hidden;
}

- (void)buttonAction:(UIButton *)button
{
    
    _offsetCol = 0;
    
    _collectionView.contentOffset = CGPointZero;
    
    _selectView.frame = CGRectMake(kScreenWidth - 30, 10 + (button.tag - 500) * 40, 20, 20);
    
    _orderBacButton.hidden = !_orderBacButton.hidden;
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_paramsCol];
    
    [par removeObjectForKey:@"offset"];
    [par setObject:@(_offsetCol) forKey:@"offset"];
    
    NSString *sort;
    
    if (button.tag == 500) {
        [par removeObjectForKey:@"sort"];
    }
    else if (button.tag != 500) {
        if (button.tag == 501) {
            sort = @"hot";
        }
        else if (button.tag == 502) {
            sort = @"price:asc";
        }
        else if (button.tag == 503) {
            sort = @"price:desc";
        }
        [par removeObjectForKey:@"sort"];
        [par setObject:sort forKey:@"sort"];
    }
    
    _paramsCol = par;
    
    
    [self requestOfCollectionViewWithType:2];
    
}

- (void)setUrlString:(NSString *)urlString
{
    if (_urlString != urlString) {
        _urlString = urlString;
        
//        [self requestOfCollectionViewWithType:1];
        
        [self requestOfHotwords];
        
    }
}

#pragma mark ---热词

- (void)requestOfHotwords
{
    
    _arrHotwords = [[NSMutableArray alloc] init];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:_urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dicData = responseObject[@"data"];
        
        HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dicData];
        
        _arrHotwords = [[NSMutableArray alloc] init];
        _arrHotwords = homeModel.hot_words;
        
        [self _createHotWordsView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
        
    }];
}

- (void)_createHotWordsView
{
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:hotView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 70, 15)];
    label.text = @"猜你想要";
    label.font = [UIFont systemFontOfSize:10];
    [hotView addSubview:label];
    
    float maxX = 0;
    float maxY = 40;
    
    for (int i = 0; i < _arrHotwords.count; i++) {
        
        NSString *hotword = _arrHotwords[i];
        
        if ((maxX + 10 + 30 + hotword.length * 12 + 10) > kScreenWidth) {
            maxX = 0;
            
            maxY += 25 + 10;
        }
        
        UIButton *hotButton = [[UIButton alloc] initWithFrame:CGRectMake(maxX + 10, maxY + 10, 30 + hotword.length * 12, 25)];
        hotButton.tag = 800 + i;
        [hotButton setTitle:hotword forState:UIControlStateNormal];
        [hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        hotButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [hotButton addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [hotView addSubview:hotButton];
        
        maxX += 10 + 30 + hotword.length * 12;
        
    }
    
}

- (void)hotButtonAction:(UIButton *)button
{
    
    NSString *hotword = _arrHotwords[button.tag - 800];
    
    _keyword = hotword;
    
    NSMutableDictionary *parCol = [[NSMutableDictionary alloc] initWithDictionary:_paramsCol];
    
    [parCol removeObjectForKey:@"keyword"];
    [parCol setObject:_keyword forKey:@"keyword"];
    _paramsCol = parCol;
    
    NSMutableDictionary *parTab = [[NSMutableDictionary alloc] initWithDictionary:_paramsTab];
    
    [parTab removeObjectForKey:@"keyword"];
    [parTab setObject:_keyword forKey:@"keyword"];
    _paramsTab = parTab;
    
    if (!_backgroundScrollerView) {
        [self _createBackgroundView];
        [self requestOfCollectionViewWithType:1];
        [self requestOfTableViewWithType:1];
    }
    else
    {
        [self requestOfCollectionViewWithType:2];
        [self requestOfTableViewWithType:2];
    }
    
    
    
}

#pragma mark ---左边的礼物

//type 1代表初始 2代表排序 3代表加载更多 4代表刷新

- (void)requestOfCollectionViewWithType:(NSInteger)type
{
    if (type == 1 || type == 2 || type == 4) {
        _arrCollectionView = nil;
        
        _arrCollectionView = [[NSMutableArray alloc] init];
        
        _offsetCol = 0;
        
    }
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_paramsCol];
    
    [par removeObjectForKey:@"offset"];
    [par setObject:@(_offsetCol) forKey:@"offset"];
    _paramsCol = par;
    
    NSString *url = @"http://api.liwushuo.com/v2/search/item";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:url parameters:_paramsCol success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"items"];
        
        for (NSDictionary *dic in arrBanners) {
            
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            
            [_arrCollectionView addObject:homeModel];
        }
        
        if (type == 1) {
            [self _createCollectionView];
            [self _createOrderView];
        }
        
        if (type == 2 || type == 3 || type == 4) {
            _collectionView.models = _arrCollectionView;
        }
        
        [self stopRefresh];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
        
        [self stopRefresh];
        
    }];
}

- (void)_createCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 10);
    
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    
    _collectionView = [[HotCollectionView alloc] initWithFrame:CGRectMake(10, 40, kScreenWidth - 20, kScreenHeight - 64 - 40) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.models = _arrCollectionView;
    
    [_backgroundScrollerView addSubview:_collectionView];
    
    __weak __typeof(self) weakSelf = self;
    
    [_collectionView addPullDownRefreshBlock:^{
        
        _offsetCol = 0;
        
        [weakSelf requestOfCollectionViewWithType:4];
        
    }];
    
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        
        _offsetCol += 20;
        
        [weakSelf requestOfCollectionViewWithType:3];
        
    }];
}

- (void)stopRefresh
{
    [_collectionView.pullToRefreshView stopAnimating];
    [_collectionView.infiniteScrollingView stopAnimating];
}


#pragma mark ---右边的攻略

//type 1代表初始 2代表排序 3代表加载更多 4代表刷新

- (void)requestOfTableViewWithType:(NSInteger)type
{
    if (type == 1 || type == 2 || type == 4) {
        _arrTableView = nil;
        
        _arrTableView = [[NSMutableArray alloc] init];
        
        _offsetTab = 0;
        
    }
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_paramsTab];
    
    [par removeObjectForKey:@"offset"];
    [par setObject:@(_offsetTab) forKey:@"offset"];
    _paramsTab = par;
    
    NSString *url = @"http://api.liwushuo.com/v2/search/post";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:url parameters:_paramsTab success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"posts"];
        
        for (NSDictionary *dic in arrBanners) {
            
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            
            [_arrTableView addObject:homeModel];
        }
        
        if (type == 1) {
            [self _createTableView];
        }
        
        if (type == 2 || type == 3 || type == 4) {
            _tableView.models = _arrTableView;
        }
        
        [self stopRefreshTableView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
        
        [self stopRefreshTableView];
        
    }];
}

- (void)_createTableView
{
    _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(10 + kScreenWidth, 40, kScreenWidth - 20, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.models = _arrTableView;
    
    [_backgroundScrollerView addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    
    [_tableView addPullDownRefreshBlock:^{
        
        _offsetTab = 0;
        
        [weakSelf requestOfTableViewWithType:4];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        _offsetTab += 20;
        
        [weakSelf requestOfTableViewWithType:3];
        
    }];
}

- (void)stopRefreshTableView
{
    [_tableView.pullToRefreshView stopAnimating];
    [_tableView.infiniteScrollingView stopAnimating];
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
