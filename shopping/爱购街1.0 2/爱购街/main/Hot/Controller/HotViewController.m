//
//  HotViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/2/20.
//  Copyright © 2016年 01. All rights reserved.
//

#import "HotViewController.h"
#import "TextSearchViewController.h"
@interface HotViewController ()
{
    HotCollectionView *_collectionView;
    NSMutableArray *_arrCollectionView;
    
    UIButton *_searchButton;
}

@end

@implementation HotViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _searchButton.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    _searchButton.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestOfCollectionView];
    
    //搜索
    [self _createSearchButton];
    
}
- (void)_createSearchButton{
    
    //搜索按钮
    _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 30, 7, 25, 25)];
    [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setImage:[UIImage imageNamed:@"Search_fruitless@2x"] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar addSubview:_searchButton];
}

//搜索按钮点击后的效果
- (void)searchButtonAction:(UIButton *)button{
    
    TextSearchViewController *textSearchVC = [[TextSearchViewController alloc] init];
    textSearchVC.urlString = @"http://api.liwushuo.com/v2/search/hot_words";
    
    [self.navigationController pushViewController:textSearchVC animated:YES];
}
- (void)requestOfCollectionView
{
    _arrCollectionView = [[NSMutableArray alloc] init];
    
    NSString *urlString = @"http://api.liwushuo.com/v2/items";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    NSDictionary *params = @{
                             @"limit" :@20,
                             @"offset" :@0,
                             @"gender" :@1,
                             @"generation" :@2
                             };
    
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
        //                NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *arrBanners = dicData[@"items"];
        
        for (NSDictionary *dic in arrBanners) {
            
            NSDictionary *dicDataOfItem = dic[@"data"];
            
            HomeModel *homeModel = [[HomeModel alloc] initContentWithDic:dicDataOfItem];
            [_arrCollectionView addObject:homeModel];
        }
        
        [self _createCollectionView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
    }];
}

- (void)_createCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 10);
    
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    
    _collectionView = [[HotCollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, kScreenHeight - 64 - 49) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.models = _arrCollectionView;
    
    [self.view addSubview:_collectionView];
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
