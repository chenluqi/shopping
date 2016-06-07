//
//  MyController.m
//  爱购街
//
//  Created by Chrismith on 16/5/19.
//  Copyright © 2016年 01. All rights reserved.
//

#import "MyController.h"
#import "SellerView.h"
#import "BuyerView.h"

@interface MyController () {
    NSArray *_sellerArr;
    NSArray *_sellerRecordArr;
    
    SellerView *_sellerView;
    BuyerView *_buyerView;
}

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self loadChildView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_sellerView) {
        [self readSeller];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - veiw 
- (void)loadChildView {
    UILabel *sellerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, 0, 100, 30)];
    sellerLabel.text = @"卖家信息";
    sellerLabel.backgroundColor = [UIColor clearColor];
    sellerLabel.textColor = [UIColor redColor];
    [self.view addSubview:sellerLabel];
    
    _sellerView = [[SellerView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, kScreenHeight / 3)];
    [self.view addSubview:_sellerView];
    
    UILabel *buyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, 30 + _sellerView.frame.size.height, 100, 30)];
    buyerLabel.backgroundColor = [UIColor clearColor];
    buyerLabel.text = @"买家信息";
    buyerLabel.textColor = [UIColor redColor];
    [self.view addSubview:buyerLabel];
    
    _buyerView = [[BuyerView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 3 + 30 + 30, kScreenWidth, kScreenHeight * 2 / 3 -80 - 64)];
    [self.view addSubview:_buyerView];
    
    UIButton *rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"清楚缓存" forState:UIControlStateNormal];
     rightBtn.frame = CGRectMake(kScreenWidth - 70, 0, 45, 45);
    [rightBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightBtn];

}

- (void)clear {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:documentPath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:documentPath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[documentPath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}


#pragma mark - 数据

//读取商家的信息
- (void)readSeller {
    _sellerArr = [NSArray arrayWithContentsOfFile:[self filePath:@"seller"]];
    if (_sellerArr) {
        _sellerView.sellerArr = _sellerArr;
    }
}

//获取文件在沙盒里document的路径
- (NSString *)filePath:(NSString *)str {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingFormat:@"/%@.plist", str];
    return filePath;
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
