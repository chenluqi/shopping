//
//  ClassifyViewController.m
//  爱购街
//
//  Created by Jhwilliam on 16/1/28.
//  Copyright © 2016年 01. All rights reserved.
//

#import "ClassifyViewController.h"
#import "LeftCollectionView.h"
#import "RightClassifyView.h"
#import "TextSearchViewController.h"
#import "TypeSearchViewController.h"
@interface ClassifyViewController ()
{
    NSMutableArray *_StategyArray;
    NSMutableArray *_giftArray;//gift左边scrollView的分类数量
    
    LeftCollectionView *_leftCollectionView;
    RightClassifyView *_rightGiftView;
    
    UIScrollView *_backgroundScrollView;//用来放置攻略和礼物的
    UIScrollView *_leftGiftScrollerView;//礼物视图中左边的滑动视图
    
    UIView *_selectView;//礼物左边按钮选择的view
    
    UIView *_TopMiddleView;//选择攻略或者礼物
    UIButton *_strategyButton;//攻略按钮
    UIButton *_giftButton;//礼物按钮
   
    UIButton *_selectGiftButton;//选礼神器按钮
    UIButton *_searchButton;//搜索
    
    
}
@end

@implementation ClassifyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _selectGiftButton.hidden = NO;
    _searchButton.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _selectGiftButton.hidden = YES;
    _searchButton.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    
    //创建存放攻略页面和礼物页面的滑动视图
    [ self _createbackgroundView];
    
    [self _createNavBarButton];//导航栏上面的按钮
    
    [self _requestStrategyData];//攻略页面加载
    
    [self _requestGiftData];  //礼物页面加载
    


}

//创建存放攻略页面和礼物页面的滑动视图
- (void)_createbackgroundView{
    
    _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64)];
    
//    _backgroundScrollView.contentSize = CGSizeMake(KScreenWidth * 2, -20);
    
    _backgroundScrollView.delegate = self;
    _backgroundScrollView.bounces = NO;
    _backgroundScrollView.pagingEnabled = YES;
    _backgroundScrollView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_backgroundScrollView];
    
    
}

- (void)_createNavBarButton{
    //titleView 放一个View，再view上面放按钮
    _TopMiddleView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/4, 10, kScreenWidth/2, 25)];
    _TopMiddleView.tag = 200;
    _TopMiddleView.backgroundColor = [UIColor whiteColor];
    
    //    [self.navigationController.navigationBar addSubview:_TopMiddleView];
    
    self.navigationItem.titleView = _TopMiddleView;
    
    //攻略按钮
    _strategyButton = [[UIButton alloc]initWithFrame:CGRectMake(1, 1, kScreenWidth/4, 24)];
    _strategyButton.tag = 201;
    [_strategyButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _strategyButton.backgroundColor = [UIColor whiteColor];
    [_strategyButton setTitle:@"攻略" forState:UIControlStateNormal];
    [_strategyButton addTarget:self action:@selector(SelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_TopMiddleView addSubview:_strategyButton];
    
    //礼物按钮
    _giftButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/4 + 1, 1, kScreenWidth/4, 24)];
    _giftButton.tag = 202;
    _giftButton.backgroundColor = [UIColor orangeColor];
    [_giftButton setTitle:@"礼物" forState:UIControlStateNormal];
    [_giftButton addTarget:self action:@selector(SelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_TopMiddleView addSubview:_giftButton];
    
    //选礼神器按钮
    _selectGiftButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 60, 30)];
    [_selectGiftButton addTarget:self action:@selector(selectGiftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectGiftButton setTitle:@"选礼神器" forState:UIControlStateNormal];
    _selectGiftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.navigationController.navigationBar addSubview:_selectGiftButton];
    
    //搜索按钮
    _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 30, 7, 25, 25)];
    [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setImage:[UIImage imageNamed:@"Search_fruitless@2x"] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar addSubview:_searchButton];
    
}

//选礼神器按钮点击后的效果
- (void)selectGiftButtonAction:(UIButton *)button{
    TypeSearchViewController *typeSearchVC = [[TypeSearchViewController alloc] init];
    typeSearchVC.urlString = @"http://api.liwushuo.com/v2/search/item_by_type";
    typeSearchVC.title = @"挑选礼物";
    
    [self.navigationController pushViewController:typeSearchVC animated:YES];

    
}

//搜索按钮点击后的效果
- (void)searchButtonAction:(UIButton *)button{
    
    TextSearchViewController *textSearchVC = [[TextSearchViewController alloc] init];
    textSearchVC.urlString = @"http://api.liwushuo.com/v2/search/hot_words";
    
    [self.navigationController pushViewController:textSearchVC animated:YES];
}

//攻略或者礼物按钮点击后选择
- (void)SelectAction:(UIButton *)button{
    if (button.tag == 201) {
        
        [self _selectStrategyButton];
        
    }else if(button.tag == 202){
        [self _selectGiftButton];
    }
    
    
}
//选择攻略按钮
- (void)_selectStrategyButton{
    
    [_strategyButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _strategyButton.backgroundColor = [UIColor whiteColor];
    
    [_giftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _giftButton.backgroundColor = [UIColor orangeColor];
    
    //点击左边跳到左边的视图，点击礼物跳到右边的视图
    [UIView animateWithDuration:0.3 animations:^{
        
        _backgroundScrollView.contentOffset = CGPointMake(0, _backgroundScrollView.contentOffset.y);
    }];
    
    
    
}
// 选择礼物按钮
- (void)_selectGiftButton{
    
    [_strategyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _strategyButton.backgroundColor = [UIColor orangeColor];
    
    [_giftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _giftButton.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:0.3 animations:^{
       
        _backgroundScrollView.contentOffset = CGPointMake(kScreenWidth, _backgroundScrollView.contentOffset.y);
    }];
    
}

//scrollView滚动完了以后加载
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_backgroundScrollView.contentOffset.x > kScreenWidth/2) {
        
        [self _selectGiftButton];
    }else{
        
        [self _selectStrategyButton];
    }
}

//攻略按钮的网络数据加载
- (void)_requestStrategyData{
    _StategyArray = [[NSMutableArray alloc]init];
    
    NSString *urlString = @"http://api.liwushuo.com/v2/channel_groups/all";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *channelArr = dicData[@"channel_groups"];
        
        for (NSDictionary *dic in channelArr) {
            
            ClassifyModel *classifyModel = [[ClassifyModel alloc]initContentWithDic:dic];
            
            [_StategyArray addObject:classifyModel];
        }
        
        [self _createCollectionView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
}
//选择礼物按钮的网络加载
- (void)_requestGiftData{
    _giftArray = [[NSMutableArray alloc]init];
    
    NSString *urlString = @"http://api.liwushuo.com/v2/item_categories/tree";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dicData = responseObject[@"data"];
        NSArray *array = dicData[@"categories"];
        
        for (NSDictionary *dic in array) {
            
            ClassifyModel *classifyModel = [[ClassifyModel alloc]initContentWithDic:dic];
            
            [_giftArray addObject:classifyModel];
            
        }
        
        [self _createGiftCollectionView];
        [self _createLeftGiftView];//礼物左边的分类栏
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@",error);
    }];
    
    
}



//攻略页面显示
- (void)_createCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _leftCollectionView = [[LeftCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64) collectionViewLayout:flowLayout];
    _leftCollectionView.backgroundColor = [UIColor whiteColor];
    
    _leftCollectionView.dataArray = _StategyArray;
    
    [_backgroundScrollView addSubview:_leftCollectionView];
}

//礼物右边页面显示
- (void)_createGiftCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth - 100, 5);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _rightGiftView = [[RightClassifyView alloc]initWithFrame:CGRectMake(100+kScreenWidth, 0, kScreenWidth - 100, kScreenHeight - 49 - 64)collectionViewLayout:flowLayout];
    _rightGiftView.backgroundColor = [UIColor whiteColor];
    
    _rightGiftView.models = _giftArray;
    
    [_backgroundScrollView addSubview:_rightGiftView];
}
//礼物左边分类页面实现
- (void)_createLeftGiftView{
    
    _leftGiftScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 100, kScreenHeight - 49 - 64)];
    _leftGiftScrollerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
    _leftGiftScrollerView.showsHorizontalScrollIndicator = NO;
    _leftGiftScrollerView.showsVerticalScrollIndicator = NO;
    
    _leftGiftScrollerView.bounces = NO;
    
    _leftGiftScrollerView.contentSize = CGSizeMake(80, _giftArray.count * 40);
    
    [_backgroundScrollView addSubview:_leftGiftScrollerView];
    
    for (int i = 0; i < _giftArray.count; i ++) {
        
        ClassifyModel *class = _giftArray[i];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 40, 100, 40)];
        button.tag = 300 + i;
        [button setTitle:class.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [button addTarget:self action:@selector(giftClassButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            
        }
        else{
            
            button.backgroundColor = [UIColor clearColor];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [_leftGiftScrollerView addSubview:button];
    }
    
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 40)];
    _selectView.backgroundColor = [UIColor orangeColor];
    
    [_leftGiftScrollerView addSubview:_selectView];
    
}

- (void)giftClassButtonAction:(UIButton*)button{
    
    for (int i = 0; i < _giftArray.count; i ++) {
        
        UIButton *newButton = [self.view viewWithTag:300 + i];
        
        if (button.tag == 300 + i) {
            newButton.backgroundColor = [UIColor whiteColor];
            [newButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        else
        {
            newButton.backgroundColor = [UIColor clearColor];
            [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

    }
    
    _selectView.frame = CGRectMake(0, 40 * (button.tag - 300), 3, 40);
    
    float y = 40 * (button.tag - 301);
    if (y < 0) {
        y = 0;
    }
    else if (y > _giftArray.count * 40 - (kScreenHeight - 64 - 49)) {
        y = _giftArray.count * 40 - (kScreenHeight - 64 - 49);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _leftGiftScrollerView.contentOffset = CGPointMake(_leftGiftScrollerView.contentOffset.x, y);
    }];
    
    float maxY;
    for (int i = 0; i < _giftArray.count; i++) {
        
        ClassifyModel *model = _giftArray[i];
        
        if (model.subcategories.count > 0) {
            maxY += ((model.subcategories.count - 1) / 3 + 1) * (ImgViewWidth + 20) + 3 ;
        }
        
    }
    
    float rY = 0;
    
    for (int i = 0; i < button.tag - 300; i++) {
        
        ClassifyModel *model = _giftArray[i];
        
        if (model.subcategories.count > 0) {
            rY += ((model.subcategories.count - 1) / 3 + 1) * (ImgViewWidth + 20) + 3;
        }
        
        if (rY > maxY - (kScreenHeight - 64 - 49)) {
            rY = maxY - (kScreenHeight - 64 - 49);
        }
       
    }
    _rightGiftView.contentOffset = CGPointMake(_rightGiftView.contentOffset.x, rY);
    
}

- (void)giftClassButtonActionTwo:(NSInteger)tag
{
    
    for (int i = 0; i < _giftArray.count; i++) {
        
        UIButton *newButton = [self.view viewWithTag:300 + i];
        
        if (tag == 300 + i) {
            newButton.backgroundColor = [UIColor whiteColor];
            [newButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        else
        {
            newButton.backgroundColor = [UIColor clearColor];
            [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    
    _selectView.frame = CGRectMake(0, 40 * (tag - 300), 3, 40);
    
    float y = 40 * (tag - 301);
    if (y < 0) {
        y = 0;
    }
    else if (y > _giftArray.count * 40 - (kScreenHeight - 64 - 49)) {
        y = _giftArray.count * 40 - (kScreenHeight - 64 - 49);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _leftGiftScrollerView.contentOffset = CGPointMake(_leftGiftScrollerView.contentOffset.x, y);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
