//
//  RegisterViewController.m
//  爱购街
//
//  Created by Chrismith on 16/5/19.
//  Copyright © 2016年 01. All rights reserved.
//

#import "RegisterViewController.h"

#define kScreenHeigh1_3 kScreenHeight / 3
#define kScreenWidth1_3 kScreenWidth / 3

@interface RegisterViewController ()<UITextFieldDelegate> {
    UITextField *_userName;
    UITextField *_password;
    UITextField *_transactionPassword;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown) name:UIKeyboardWillShowNotification object:nil];
    
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
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(100, kScreenHeigh1_3, kScreenWidth - 130, 40)];
    _userName.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_userName];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeigh1_3, 100, 40)];
    userLabel.text = @"用 户 名：";
    [self.view addSubview:userLabel];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(100, kScreenHeigh1_3 + 50, kScreenWidth - 130, 40)];
    _password.secureTextEntry = YES;
    _password.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_password];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeigh1_3 + 50, 100, 40)];
    passwordLabel.text = @"密    码：";
    [self.view addSubview:passwordLabel];
    
    _transactionPassword = [[UITextField alloc] initWithFrame:CGRectMake(100, kScreenHeigh1_3 + 100, kScreenWidth - 130, 40)];
    _transactionPassword.secureTextEntry = YES;
    _transactionPassword.backgroundColor = [UIColor whiteColor];
    _transactionPassword.delegate = self;
    [self.view addSubview:_transactionPassword];
    
    UILabel *transactionPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeigh1_3 + 100, 100, 40)];
    transactionPasswordLabel.text = @"支付密码：";
    [self.view addSubview:transactionPasswordLabel];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth1_3, kScreenHeigh1_3 + 150, 50, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor orangeColor];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
//    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth1_3 + 100, kScreenHeigh1_3 + 150, 50, 40)];
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth1_3 + 100, kScreenHeigh1_3 + 150, 50, 40)];
    [registerBtn setTitle:@"确定" forState:UIControlStateNormal];
    registerBtn.backgroundColor = [UIColor orangeColor];
    [registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
}

#pragma mark - action
- (void)backBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushHomePage {
    
}

- (void)keyboardWasShown {
    
}

#pragma mark - 数据处理

- (void)registerBtnAction:(UIButton *)sender {
    if (![_userName.text isEqualToString:@""] && ![_password.text isEqualToString:@""] && ![_transactionPassword.text isEqualToString:@""]) {
        NSMutableArray *userArr = [NSMutableArray arrayWithContentsOfFile:[self filePath]];
        if (userArr) {
            if ([self compare:userArr]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您注册的账号已经被别人提前注册过了，请你换一个吧 ^O^" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            }else {
                NSDictionary *dic = @{
                                      @"userName" : _userName.text,
                                      @"password" : _password.text,
                                      @"transactionPassword" : _transactionPassword.text,
                                      @"balance" : @10000.0
                                      };
                [userArr addObject:dic];
                [self dataPreservation:userArr];
            }
        }else {
            userArr = [NSMutableArray array];
            NSDictionary *dic = @{
                                  @"userName" : _userName.text,
                                  @"password" : _password.text,
                                  @"transactionPassword" : _transactionPassword.text,
                                  @"balance" : @10000.0
                                  };
            [userArr addObject:dic];
            [self dataPreservation:userArr];
        }
        

    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"有一项为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//保存心注册的用户
- (void)dataPreservation:(NSMutableArray *)arr {
    [arr writeToFile:[self filePath] atomically:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功 ^O^" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    _password.text = @"";
    _userName.text = @"";
    _transactionPassword.text = @"";
}

//获取沙盒里document的路径
- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *userFilePath = [documentPath stringByAppendingString:@"/user.plist"];
    NSLog(@"%@", documentPath);
    return userFilePath;
}

//比较该用户是否在本地已经存在
- (BOOL)compare:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dic = arr[i];
        if ([dic[@"userName"] isEqualToString:_userName.text]) {
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
