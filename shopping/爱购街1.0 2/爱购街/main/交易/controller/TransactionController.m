//
//  TransactionController.m
//  爱购街
//
//  Created by Chrismith on 16/5/23.
//  Copyright © 2016年 01. All rights reserved.
//

#import "TransactionController.h"
#import "StateShare.h"
#import "ScanViewController.h"
#import "RootNavigationController.h"

@interface TransactionController ()

@end

@implementation TransactionController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Do any additional setup after loading the view.
}


- (void)setModel:(HomeModel *)model {
    if (_model != model) {
        _model = model;
        [self loadChildView];
        self.titleLabel.text = _model.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%ld", [_model.price integerValue]];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.cover_image_url]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadChildView {
    _sellerName = @"淘宝xxxxxx旗舰店";
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [self.view addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 220, kScreenWidth - 100, 80)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, kScreenWidth - 100, 40)];
    _priceLabel.textColor = [UIColor redColor];
    [self.view addSubview:_priceLabel];
    
    _peyButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 3, kScreenHeight - 64 - 170 - 60, kScreenWidth / 3, 60)];
    _peyButton.backgroundColor = [UIColor redColor];
    [_peyButton addTarget:self action:@selector(peyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_peyButton setTitle:@"扫描支付" forState:UIControlStateNormal];
    [self.view addSubview:_peyButton];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 3, kScreenHeight - 64 - 100 - 60, kScreenWidth / 3, 60)];
    _cancelButton.backgroundColor = [UIColor redColor];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"取消支付" forState:UIControlStateNormal];
    [self.view addSubview:_cancelButton];
    
}

- (void)cancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//交易过程模拟
- (void)peyAction:(UIButton *)sender {
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    scanVC.model = _model;
    
    RootNavigationController *root = [[RootNavigationController alloc]initWithRootViewController:scanVC];
    [self presentViewController:root animated:YES completion:NULL];

    
//    //商家
//    NSMutableArray *sellerArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:@"seller"]];
//    
//    //判断商家信息文件本地是否已经有“？
//    if (sellerArr) {
//        
//        //商家余额更新
//        for (int i = 0; i < sellerArr.count; i++) {
//            NSDictionary *dic = sellerArr[i];
//            if ([_sellerName isEqualToString:dic[@"name"]]) {
//                NSInteger balance = [dic[@"balance"] integerValue];
//                balance += [_model.price integerValue];
//                [dic setValue:[NSNumber numberWithInteger:balance] forKey:@"balance"];
//                
//                [self dataPreservation:sellerArr filerName:@"seller"];
//            }
//        }
//        
//        //商家卖出的商品信息记录
//        NSMutableArray *sellerCommodityArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:[NSString stringWithFormat:@"商家_%@", _sellerName]]];
//        
//        //判断商家售卖纪录在本地是否已经存在
//        if (sellerCommodityArr) {
//            NSDictionary *businessDic = @{
//                                           @"cover_image_url" : _model.cover_image_url,
//                                           @"price" : _model.price,
//                                           @"name" : _model.name
//                                           };
//            [sellerCommodityArr addObject:businessDic];
//            [self dataPreservation:sellerCommodityArr filerName:[NSString stringWithFormat:@"商家_%@", _sellerName]];
//        }else {
//            sellerCommodityArr = [NSMutableArray array];
//            NSDictionary *businessDic = @{
//                                          @"cover_image_url" : _model.cover_image_url,
//                                          @"price" : _model.price,
//                                          @"name" : _model.name
//                                          };
//            [sellerCommodityArr addObject:businessDic];
//            [self dataPreservation:sellerCommodityArr filerName:[NSString stringWithFormat:@"商家_%@", _sellerName]];
//        }
//    }else {
//        
//        //创建并保存卖家信息
//        sellerArr = [NSMutableArray array];
//        
//        NSNumber *balance = @(1000.0 + [_model.price integerValue]);
//        NSDictionary *sellerDic = @{
//                                   @"name" : _sellerName,
//                                   @"balance" : balance
//                                   };
//        [sellerArr addObject:sellerDic];
//        
//        
//        
//        [self dataPreservation:sellerArr filerName:@"seller"];
//        
//        //保存卖家卖出的商品纪录
//        NSMutableArray *sellerCommodityArr = [NSMutableArray array];
//        NSDictionary *businessDic = @{
//                                      @"cover_image_url" : _model.cover_image_url,
//                                      @"price" : _model.price,
//                                      @"name" : _model.name
//                                      };
//        [sellerCommodityArr addObject:businessDic];
//        [self dataPreservation:sellerCommodityArr filerName:[NSString stringWithFormat:@"商家_%@", _sellerName]];
//    }
//    
//    //消费者
//    StateShare *state = [StateShare getStateShare];
//    NSMutableArray *buyerArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:@"user"]];
//    
//    //判断买家信息文件是否已经存在本地
//    if (buyerArr) {
//        for (int i = 0; i < buyerArr.count; i++) {
//            NSDictionary *dic = buyerArr[i];
//            
//            //把购买信息保存到登陆账号的文件中
//            if ([state.name isEqualToString:dic[@"userName"]]) {
//                
//                //消费者余额更新
//                NSInteger balance = [dic[@"balance"] integerValue];
//                balance -= [_model.price integerValue];
//                [dic setValue:[NSNumber numberWithInteger:balance] forKey:@"balance"];
//                
//                [self dataPreservation:buyerArr filerName:@"user"];
//                
//                //消费者买到的商品信息记录
//                NSMutableArray *buyerCommodityArr = [NSMutableArray arrayWithContentsOfFile:[self filePath:state.name]];
//                
//                //判断登陆用户买东西纪录在本地是否已经有记录
//                if (buyerCommodityArr) {
//                    NSDictionary *commodityDic = @{
//                                                   @"cover_image_url" : _model.cover_image_url,
//                                                   @"price" : _model.price,
//                                                   @"name" : _model.name
//                                                   };
//                    [buyerCommodityArr addObject:commodityDic];
//                    [self dataPreservation:buyerCommodityArr filerName:state.name];
//                }else {
//                    buyerCommodityArr = [NSMutableArray array];
//                    NSDictionary *commodityDic = @{
//                                                   @"cover_image_url" : _model.cover_image_url,
//                                                   @"price" : _model.price,
//                                                   @"name" : _model.name
//                                                   };
//                    [buyerCommodityArr addObject:commodityDic];
//                    [self dataPreservation:buyerCommodityArr filerName:state.name];
//                }
//            }
//        }
//    }else {
////        buyerArr = [NSMutableArray array];
//        
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据处理
//保存用户信息
- (void)dataPreservation:(NSMutableArray *)arr filerName:(NSString *)name{
    [arr writeToFile:[self filePath:name] atomically:YES];
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
