//
//  TaobaoViewController.m
//  Life
//
//  Created by lanou on 16/6/1.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "TaobaoViewController.h"
#import <WebKit/WebKit.h>

@interface TaobaoViewController ()<WKNavigationDelegate,MBProgressHUDDelegate>

@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation TaobaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 25)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_taobaoURL]];
    [self.webView loadRequest:request];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.delegate = self;
}
- (void)popback{
    _webView.navigationDelegate = nil; // 不用时，置nil
    [_webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _webView.navigationDelegate = nil; // 不用时，置nil
    [_webView stopLoading];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.hud showAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.hud hideAnimated:YES];
    //设置标题
    self.title = webView.title;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud hideAnimated:YES];
    //设置标题
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
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
