//
//  WebViewController.m
//  买买买
//
//  Created by 洪曦尘 on 16/2/20.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

{
    
    UIWebView *_webView;
    UIActivityIndicatorView *_activityView;
    UIWebView *_webView2;
    
    int num;
}

@end

@implementation WebViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _webView.delegate = self;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    num = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setUrl:(NSString *)url
{
    if (_url != url) {
        _url = url;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    [_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if (num == 0) {
        num ++;
        
        NSString *htmlStr = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        
        NSString *regex1 = @"viewport";
        NSString *regex2 = @"download";
        NSString *regex3 = @"http://static.liwushuo.com/static/web/apps/liwushuo/img/app_download_3a8b4aa.png";
        NSString *regex4 = @"礼物说";
        NSString *regex5 = @"http://static.liwushuo.com/static/web/apps/liwushuo/img/app_icon_34371a9.png";
        NSString *regex6 = @"www.liwushuo.com";
        
        NSMutableString *str = [[NSMutableString alloc] initWithString:htmlStr];
        
        [str replaceOccurrencesOfRegex:regex1 withString:@""];
        [str replaceOccurrencesOfRegex:regex2 withString:@""];
        [str replaceOccurrencesOfRegex:regex3 withString:@""];
        [str replaceOccurrencesOfRegex:regex4 withString:@"爱购街"];
        [str replaceOccurrencesOfRegex:regex5 withString:@""];
        [str replaceOccurrencesOfRegex:regex6 withString:@""];
        
        [_webView loadHTMLString:str baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//        [_webView loadHTMLString:str baseURL:nil];
        
        [self performSelector:@selector(addWebView) withObject:nil afterDelay:0.1];
        
        UIImageView *imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * (414 - 100) / 414, 0, kScreenWidth * 100 / 414, kScreenWidth * 100 / 414 * 2 / 3)];
        imaView.image = [UIImage imageNamed:@"mmmWebPage"];
        [_webView.scrollView addSubview:imaView];
        
    }
}

- (void)addWebView
{
    [self.view addSubview:_webView];
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
