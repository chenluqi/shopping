//
//  ClassSearchViewController.m
//  买买买
//
//  Created by 洪曦尘 on 16/2/5.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "ClassSearchViewController.h"
#import "HotCollectionView.h"
@interface ClassSearchViewController ()

{
    HotCollectionView *_collectionView;
    NSMutableArray *_arrCollectionView;
    
    UIButton *_orderBacButton;
    UIImageView *_selectView;
    
    UIButton *_orderButton;
    
    NSDictionary *_params;
    
    NSInteger _offset;
    
    
}

@end

@implementation ClassSearchViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _orderButton.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _orderButton.hidden = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _params = @{
                @"limit" :@20,
                @"offset" :@0
                };
    
    _offset = 0;
    
}

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
    
    _offset = 0;
    
    _collectionView.contentOffset = CGPointZero;
    
    _selectView.frame = CGRectMake(kScreenWidth - 30, 10 + (button.tag - 500) * 40, 20, 20);
    
    _orderBacButton.hidden = !_orderBacButton.hidden;
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_params];
    
    [par removeObjectForKey:@"offset"];
    [par setObject:@(_offset) forKey:@"offset"];
    
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
    
    _params = par;
    
    
    [self requestOfCollectionViewWithType:2];
    
}

- (void)setUrlString:(NSString *)urlString
{
    if (_urlString != urlString) {
        _urlString = urlString;
        
        [self requestOfCollectionViewWithType:1];
        
    }
}

//type 1代表初始 2代表排序 3代表加载更多 4代表刷新

- (void)requestOfCollectionViewWithType:(NSInteger)type
{
    
    if (type == 1 || type == 2 || type == 4) {
        _arrCollectionView = nil;
        
        _arrCollectionView = [[NSMutableArray alloc] init];
        
        _offset = 0;
        
    }
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_params];
    
    [par removeObjectForKey:@"offset"];
    [par setObject:@(_offset) forKey:@"offset"];
    _params = par;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:_urlString parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"items"];
        
        for (NSDictionary *dic in arrBanners) {
            
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            
            [_arrCollectionView addObject:homeModel];
        }
        
        if (type == 1) {
            [self _createCollectionView];
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
    
    _collectionView = [[HotCollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - 64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.models = _arrCollectionView;
    
    [self.view addSubview:_collectionView];
    
    __weak __typeof(self) weakSelf = self;
    
    [_collectionView addPullDownRefreshBlock:^{
        
        _offset = 0;
        
        [weakSelf requestOfCollectionViewWithType:4];
        
    }];
    
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        
        _offset += 20;
        
        [weakSelf requestOfCollectionViewWithType:3];
        
    }];
    
    [self _createOrderView];
}

- (void)stopRefresh
{
    [_collectionView.pullToRefreshView stopAnimating];
    [_collectionView.infiniteScrollingView stopAnimating];
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
