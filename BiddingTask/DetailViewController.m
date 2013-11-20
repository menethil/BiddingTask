//
//  DetailViewController.m
//  BiddingTask
//
//  Created by Menethil on 13-11-12.
//  Copyright (c) 2013年 Menethil. All rights reserved.
//

#import "DetailViewController.h"
#import "SVProgressHUD.h"
#import "CSNotificationView.h"


@interface DetailViewController ()<UIWebViewDelegate>
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(BiddingItem*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.title;
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        
        NSString *urlString = [NSString stringWithFormat:@"http://zzct.fjzfcg.gov.cn/%@",self.detailItem.url];
        NSURL* url = [NSURL URLWithString:urlString];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载招标信息"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
//    [CSNotificationView showInViewController:self
//                                       style:CSNotificationViewStyleSuccess
//                                     message:@"加载成功"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载错误，请检查网络"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 这部分是适配ios7，防止刷新后列表被导航栏遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
