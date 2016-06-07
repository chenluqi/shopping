//
//  LoginViewController.m
//  爱购街
//
//  Created by Chrismith on 16/5/19.
//  Copyright © 2016年 01. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RootTabBarController.h"
#import "RightViewController.h"
#import "LeftTableViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "MMDrawerController.h"
#import "StateShare.h"

#define kScreenHeigh1_3 kScreenHeight / 3
#define kScreenWidth1_3 kScreenWidth / 3

@interface LoginViewController ()<UITextFieldDelegate> {
    UITextField *_userName;
    UITextField *_password;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown) name:UIKeyboardWillShowNotification object:nil];
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    [self loadChildView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mairk - view
- (void)loadChildView {
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(70, kScreenHeigh1_3, kScreenWidth - 100, 40)];
    _userName.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_userName];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeigh1_3, 80, 40)];
    userLabel.text = @"用户名：";
    [self.view addSubview:userLabel];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(70, kScreenHeigh1_3 + 50, kScreenWidth - 100, 40)];
    _password.secureTextEntry = YES;
    _password.secureTextEntry = YES;
    _password.delegate = self;
    _password.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_password];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeigh1_3 + 50, 80, 40)];
    passwordLabel.text = @"密  码：";
    [self.view addSubview:passwordLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth1_3, kScreenHeigh1_3 + 100, 50, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor orangeColor];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth1_3 + 70, kScreenHeigh1_3 + 100, 50, 40)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor = [UIColor orangeColor];
    [registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
}

#pragma mark - action
- (void)loginBtnAction:(UIButton *)sender {
    if (![_userName.text isEqualToString:@""] && ![_password.text isEqualToString:@""]) {
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self filePath]];
        if (arr) {
            if ([self compare:arr]) {
                
                //记录登录人的名字
                StateShare *state = [StateShare getStateShare];
                state.name = _userName.text;
                
                //登录首页
                [self pushHomePage];
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误 ^O^" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不存在 ^O^" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空 ^O^" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)registerBtnAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self presentViewController:registerVC animated:YES completion:^{
        
    }];
}

- (void)pushHomePage {
    UIStoryboard *leftStoryboard = [UIStoryboard storyboardWithName:@"Left" bundle:nil];
    
    UINavigationController *leftNavigationVC = [leftStoryboard instantiateInitialViewController];
    
    RootTabBarController *tabBarCtrl = [[RootTabBarController alloc]init];
    
    MMDrawerController *drawerCtrl = [[MMDrawerController alloc]initWithCenterViewController:tabBarCtrl leftDrawerViewController:leftNavigationVC];
    //设置左右的宽度
    [drawerCtrl setMaximumLeftDrawerWidth:kScreenWidth - 100];
    //    [self.drawerCtrl setMaximumRightDrawerWidth:1];
    
    //设置手势操作的区域
    [drawerCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerCtrl setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    drawerCtrl.view.backgroundColor = [UIColor clearColor];
    
    //配置管理动画的block
    [drawerCtrl
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    self.view.window.rootViewController = drawerCtrl;
}

- (void)keyboardWasShown {
    
}

#pragma mark - 数据处理
//获取沙盒里document的路径
- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *userFilePath = [documentPath stringByAppendingString:@"/user.plist"];
    NSLog(@"%@", documentPath);
    return userFilePath;
}

//比较该用户是否在本地存在
- (BOOL)compare:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        if ([dic[@"userName"] isEqualToString:_userName.text] && [dic[@"password"] isEqualToString:_password.text]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
