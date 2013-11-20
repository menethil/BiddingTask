//
//  RefreshViewController.m
//  快速集成下拉刷新
//
//  Created by mj on 13-11-3.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "RefreshViewController.h"
#import "AFNetworking.h"
#import "Toast+UIView.h"

/*
 MJ友情提示：
 1> 在MJRefreshBaseView.h中：可以通过NeedAudio宏来控制是否需要刷新音效
 2> 在MJRefreshFooterView.m和MJRefreshHeaderView.m中可以修改刷新显示的文字
 3> 监听进入刷新状态有2种方式：
  * 设置delegate，通过代理方法监听
  * 设置beginRefreshingBlock，通过block回调监听
 4> 本框架兼容iPhone\iPad横竖屏
 */

// 1.主头文件
#import "MJRefresh.h"
#import "BiddingItem.h"
#import "SVProgressHUD.h"

// 2.刷新代理协议（达到刷新状态就会调用）
@interface RefreshViewController()  <MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end


/**
 本视图控制器负责数据地获取和提示信息的加载显示,继承于 MasterViewController
 **/
@implementation RefreshViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 这部分是适配ios7，防止刷新后列表被导航栏遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    //在block中要__weak引用，防止重复retain
    __weak RefreshViewController *tempView = self;
    
    // 集成下拉刷新数据控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    
    // 下拉刷新时调用该方法
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        // 刷新数据,参数为true代表重新获取数据
        [tempView loadNextPageData:true];
    };
    
    // 集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //加载数据,参数false代表加载下一页数据，不重新获取当前已有数据
        [tempView loadNextPageData:false];
    };
    
    // 首次自动下拉刷新
    [self loadNextPageData:false];
}

//加载下一页的数据
- (void)loadNextPageData:(bool) refresh{
    // 如果是刷新界面，那么重新获取首页的数据源
    if(refresh)
    {
        currentPageNum = 0;
        _objects = nil;
    }
    
    currentPageNum +=1;
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://zzct.fjzfcg.gov.cn/secpag.cfm?caidan=采购公告&caidan2=招标公告&pageNum=%d",currentPageNum];
    NSString* string2 = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string2]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //在此解析
        NSError *error;
        NSString *regexString = @"<td width=\"83%\" title=\"(.*?)\"><img src=\"images/dian.gif\">&nbsp;(.*?)<a href=\"(.*?)\" target=([.\\S\\s]*?)<td width=\"17%\" align=\"right\">(.*?)&nbsp;</td>";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *_str = operation.responseString;
        NSArray *array = nil;
        array = [regex matchesInString:_str options:0 range:NSMakeRange(0, [_str length])];
        
        for (NSTextCheckingResult* b in array)
        {
            if (!_objects) {
                _objects = [[NSMutableArray alloc] init];
            }
            
            //采购项解析
            BiddingItem *biddingItem = [[BiddingItem alloc ]init];
            biddingItem.title = [_str substringWithRange:[b rangeAtIndex:1]];
            biddingItem.no = [_str substringWithRange:[b rangeAtIndex:2]];
            biddingItem.url = [_str substringWithRange:[b rangeAtIndex:3]];
            biddingItem.date = [_str substringWithRange:[b rangeAtIndex:5]];
            
            //正序插入，列表最顶端为最新的招标项目
            [_objects insertObject:biddingItem atIndex:[_objects count]];
        }
        
        //重载界面
        [self reloadDeals];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //返回错误信息2.0
        [SVProgressHUD showErrorWithStatus:@"加载错误，请检查网络"];
    }];
    
    [operation start];
}

#pragma mark 刷新
- (void)reloadDeals
{
    [self.tableView reloadData];
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
    
    // 显示加载成功信息
    if(currentPageNum > 1){
//        [CSNotificationView showInViewController:self
//                                           style:CSNotificationViewStyleSuccess
//                                         message:@"加载成功"];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    }else if(currentPageNum == 1)
    {
//        [CSNotificationView showInViewController:self
//                                           style:CSNotificationViewStyleSuccess
//                                         message:@"刷新成功"];
        [self.view makeToast:@"刷新成功" duration:1.0 position:@"top"];
//        [SVProgressHUD showSuccessWithStatus:@"刷新成功"];
    }
}
@end
