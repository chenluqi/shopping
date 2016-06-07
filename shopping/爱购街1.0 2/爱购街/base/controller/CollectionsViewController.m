//
//  CollectionsViewController.m
//  买买买
//
//  Created by huiwen on 16/1/31.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "CollectionsViewController.h"

@interface CollectionsViewController ()

{
    NSMutableArray *_arrTableView;
    HomeTableView *_tableView;
    
    NSDictionary *_params;
    
    NSInteger _offset;
}

@end

@implementation CollectionsViewController

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

- (void)setUrlString:(NSString *)urlString
{
    if (_urlString != urlString) {
        _urlString = urlString;
        
        [self requestOfTableViewWithType:1];
        
    }
}

//type 1代表初始 2代表排序 3代表加载更多 4代表刷新

- (void)requestOfTableViewWithType:(NSInteger)type
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:self.urlString parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //        NSLog(@"响应对象:%@", task.response);
        
        //responseObject是已经过JSON解析后的数据
        //        NSLog(@"%@", responseObject);
        
        NSDictionary *dicData = responseObject[@"data"];
        
        self.title = dicData[@"title"];
        
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
        
        [self stopRefresh];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"errro:%@", error);
        
        [self stopRefresh];
    }];
}

- (void)_createTableView
{
    _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.models = _arrTableView;
    
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    
    [_tableView addPullDownRefreshBlock:^{
        
        _offset = 0;
        
        [weakSelf requestOfTableViewWithType:4];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        _offset += 20;
        
        [weakSelf requestOfTableViewWithType:3];
        
    }];
    
}

- (void)stopRefresh
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
