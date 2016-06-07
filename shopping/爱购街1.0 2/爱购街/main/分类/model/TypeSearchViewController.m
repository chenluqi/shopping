//
//  TypeSearchViewController.m
//  买买买
//
//  Created by huiwen on 16/2/5.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "TypeSearchViewController.h"

@interface TypeSearchViewController ()

{
    HotCollectionView *_collectionView;
    NSMutableArray *_arrCollectionView;
    
    UIButton *_orderBacButton;
    UIImageView *_selectView;
    
    UIButton *_orderButton;
    
    NSDictionary *_params;
    
    NSInteger _offset;
    
    UIView *_buttonView;
    UIButton *_typeBacButton;
    
    NSMutableArray *_arrButton;
    
    NSInteger _lastButtonTag;
    
    //对象  场合  个性  价格
    
    NSString *_target;
    NSString *_scene;
    NSString *_personality;
    NSString *_price;
    
}

@end

@implementation TypeSearchViewController

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
    
    _target = @"";
    _scene = @"";
    _personality = @"";
    _price = @"";
    
    _params = @{
                @"limit" :@20,
                @"offset" :@0,
                @"target" : _target,
                @"scene" : _scene,
                @"personality" : _personality,
                @"price" : _price
                };
    
    _offset = 0;
    
    
    
}

- (void)_createOrderView
{
    
    _orderButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 10, 40, 25)];
    [_orderButton addTarget:self action:@selector(bacButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    _orderButton.backgroundColor = [UIColor blueColor];
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

- (void)requestOfButton
{
    
    _arrButton = [[NSMutableArray alloc] init];
    
    NSString *url = @"http://api.liwushuo.com/v2/search/item_filter";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"filters"];
        
        for (NSDictionary *dic in arrBanners) {
            
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dic];
            
            [_arrButton addObject:homeModel];
        }
        
        [self _createButtonView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
        
    }];
}

- (void)_createButtonView
{
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    [self.view addSubview:_buttonView];
    
    _typeBacButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 64 - 40)];
    [_typeBacButton addTarget:self action:@selector(typeBacButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _typeBacButton.hidden = YES;
    
    [self.view addSubview:_typeBacButton];
    
    [self _createOrderView];
    
    
    for (int i = 0; i < _arrButton.count; i++)
    {
        
        HomeModel *model = _arrButton[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * kScreenWidth / 4, 0, kScreenWidth / 4, 40)];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(bigTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_buttonView addSubview:button];
        
        UIView *butView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        butView.tag = 200 + i;
        butView.hidden = YES;
        butView.backgroundColor = [UIColor whiteColor];
        [_typeBacButton addSubview:butView];
        
        for (int j = 0; j < model.channels.count + 1; j++)
        {
            
            int row = j / 3;
            int col = j % 3;
            
            if (j == 0)
            {
                
                UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + col * ((kScreenWidth - 40) / 3 + 10), 10 + 50 * row, (kScreenWidth - 40) / 3, 40)];
//                typeButton.layer.masksToBounds = YES;
//                typeButton.maskView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
//                typeButton.maskView.layer.borderWidth = 5;
                typeButton.backgroundColor = [UIColor orangeColor];
                typeButton.tag = (i + 3) * 100 + j;
                [typeButton setTitle:[NSString stringWithFormat:@"任意%@",model.name]  forState:UIControlStateNormal];
                [typeButton setTintColor:[UIColor whiteColor]];
                [typeButton addTarget:self action:@selector(smallTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [butView addSubview:typeButton];
            }
            
            if (j > 0)
            {
                HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:model.channels[j - 1]];
                
                UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + col * ((kScreenWidth - 40) / 3 + 10), 10 + 50 * row, (kScreenWidth - 40) / 3, 40)];
//                typeButton.layer.masksToBounds = YES;
//                typeButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
//                [typeButton.layer setMasksToBounds:YES];
//                [typeButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor redColor])];
//                [typeButton.layer setBorderWidth:5];
                typeButton.backgroundColor = [UIColor whiteColor];
                typeButton.tag = (i + 3) * 100 + j;
                [typeButton addTarget:self action:@selector(smallTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [typeButton setTitle:homeModel.name forState:UIControlStateNormal];
                [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [butView addSubview:typeButton];
                
            }
            
            
            
            
            
        }
        
    }
    
    
}

- (void)bigTypeButtonAction:(UIButton *)button
{
    
    if (_typeBacButton.hidden) {
        _typeBacButton.hidden = NO;
    }
    else if (_lastButtonTag == button.tag)
    {
        _typeBacButton.hidden = YES;
    }
    
    for (int i = 0; i < 4; i++) {
        if (i == button.tag - 100) {
            
            UIView *bacView = [_typeBacButton viewWithTag:i + 200];
            
            bacView.hidden = NO;
            
        }
        else
        {
            UIView *bacView = [_typeBacButton viewWithTag:i + 200];
            
            bacView.hidden = YES;
        }
    }
    
    _lastButtonTag = button.tag;
}

- (void)typeBacButtonAction:(UIButton *)button
{
    button.hidden = YES;
}

- (void)smallTypeButtonAction:(UIButton *)button
{
    _typeBacButton.hidden = YES;
    
    NSInteger bigType = button.tag / 100 - 3;
    NSInteger smallType = button.tag % 100;
    
    HomeModel *model = _arrButton[bigType];
    
    NSString *type;
    
    switch (bigType) {
        case 0:
            type = @"target";
            break;
        case 1:
            type = @"scene";
            break;
        case 2:
            type = @"personality";
            break;
        case 3:
            type = @"price";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] initWithDictionary:_params];
    
    if (smallType == 0)
    {
        
        UIButton *bigButton = [_buttonView viewWithTag:100 + bigType];
        [bigButton setTitle:model.name forState:UIControlStateNormal];
        
        for (int i = 0; i < model.channels.count + 1; i++)
        {
            if (i == smallType)
            {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor orangeColor];
            }
            else
            {
                UIButton *smallButton = [_typeBacButton viewWithTag:bigType * 100 + 300 + i];
                [smallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                smallButton.backgroundColor = [UIColor whiteColor];
                
            }
        }
        
        [par removeObjectForKey:type];
        [par setObject:@"" forKey:type];
        
    }
    else
    {
        
        HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:model.channels[smallType - 1]];
        
        UIButton *bigButton = [_buttonView viewWithTag:100 + bigType];
        [bigButton setTitle:homeModel.name forState:UIControlStateNormal];
        
        for (int i = 0; i < model.channels.count + 1; i++)
        {
            if (i == smallType)
            {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor orangeColor];
            }
            else
            {
                UIButton *smallButton = [_typeBacButton viewWithTag:bigType * 100 + 300 + i];
                [smallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                smallButton.backgroundColor = [UIColor whiteColor];
                
            }
        }
        
        [par removeObjectForKey:type];
        [par setObject:homeModel.key forKey:type];
        
    }
    
    _params = par;
    
    [self requestOfCollectionViewWithType:2];
    
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
            
            //只有在collectionView创建好之后才可以把typeBacButton加上去
            
            [self requestOfButton];
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
