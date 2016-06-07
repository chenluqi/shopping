//
//  RootTabBarController.m
//  爱购街
//
//  Created by Jhwilliam on 16/1/28.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootTabBarItem.h"

@interface RootTabBarController ()
{
    UIImageView *_selectImgView;
    NSArray *_selectImgArray;
    CGFloat itemWidth;
   CGFloat height;
}
@end

@implementation RootTabBarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self removeUITabBarItem];
    //自定义tabBar
    [self _createCustomTabBar];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建viewCtrls
    [self _createViewCtrls];
    
   
  
}

- (void)_createViewCtrls{
    
    
    NSArray *storyboardNames = @[@"Home",@"Favorite",@"Classify",@"My"];
    NSMutableArray *viewCtrls = [NSMutableArray arrayWithCapacity:storyboardNames.count];
    
    for (int i = 0; i < storyboardNames.count; i ++) {
        
        NSString *storyName = storyboardNames[i];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyName bundle:nil];
        
        UIViewController *viewCtrl = [storyBoard instantiateInitialViewController];
        
        [viewCtrls addObject: viewCtrl];
    }
    
    self.viewControllers = viewCtrls;

}

- (void)_createCustomTabBar{

    for (UIView *view in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    
    
    itemWidth = kScreenWidth / 4;
//    UIView *tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 49)];
//    [self.tabBar addSubview:tabBarView];
    
    //1.tabBar按钮
     NSArray *imgArray = @[@"TabBar_home.png",
                           @"TabBar_gift.png",
                           @"TabBar_category.png",
                           @"TabBar_home.png"];
    NSArray *titleArray = @[@"首页",@"热门",@"分类",@"个人中心"];
    
    //遍历数组创建按钮
    for (int i = 0; i < imgArray.count; i ++) {
        NSString *imgName =  imgArray[i];
        NSString *title = titleArray[i];
        
        // 2创建标签栏按钮尺寸
        CGRect frame = CGRectMake(i * itemWidth, 0, itemWidth, 49);
        
        RootTabBarItem *item = [[RootTabBarItem alloc]initWithFrame:frame imageName:imgName title:title];
        
        item.tag = i + 100;
        if (i == 0) {
            item.isSelect = YES;
        }
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:item];
        
        
    }
        [self _createSelectImgView];
     
}



//创建标签栏选中的效果的视图
- (void)_createSelectImgView{
    
    _selectImgArray = @[
                       @"TabBar_home_selected",
                       @"TabBar_gift_selected",
                       @"TabBar_category_Selected",
                       @"TabBar_home_selected"
                       ];
    _selectImgView = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth - 25)/2, 5, 25, 25)];
    _selectImgView.image = [UIImage imageNamed:_selectImgArray[0]];
    [self.tabBar addSubview:_selectImgView];
    
    
}
//选中后的效果
- (void)clickItem:(RootTabBarItem*)item{
    self.selectedIndex = item.tag - 100 ;
    for (int i = 0; i < _selectImgArray.count; i ++) {
        RootTabBarItem *item = [self.view viewWithTag:i + 100];
        
        if (i == self.selectedIndex) {
            
            item.isSelect = YES;
        }else{
            item.isSelect = NO;
        }
    }
    _selectImgView.frame = CGRectMake(self.selectedIndex * itemWidth + (itemWidth - 25) / 2, 5, 25, 25);
    
    _selectImgView.image = [UIImage imageNamed:_selectImgArray[item.tag - 100]];

    
  
}

   //删除原有的标签栏视图
- (void)removeUITabBarItem{
 
    for (UIView *view in self.tabBar.subviews) {
        
        //Class是一个抽象类，能把所有相似的类归纳为一个类。
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            
            [view removeFromSuperview];
        }
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
