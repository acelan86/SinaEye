//
//  FeedsViewController.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/6.
//  Copyright (c) 2015年 esina. All rights reserved.
//
// @todo
// 1、把feedsViewController做成delegate，对外暴露init完成的方法
// 即webview初始化完成，由sdk来实现loadPage，这样可以控制什么时候feed重新加载，什么时候不重新加载
// 正确的逻辑应该是当点击大眼睛的时候，feed全新加载，当navigator退回的时候不重新加载
// 2、地理位置的获取需要看下怎么处理
//

#import "FeedsViewController.h"
#import "BrowserViewController.h"

static NSString *FEED_URL = @"http://d1.sina.com.cn/litong/zhitou/sinaads/demo/SinaEyeFeedPage/index.html";

@interface FeedsViewController () <BrowserViewControllerDelegate>
@property (nonatomic, strong) BrowserViewController *feeds;
@end

@implementation FeedsViewController

- (FeedsViewController *) initWithDelegate:(id<FeedsViewControllerDelegate>)delegate {
    _feeds = [[BrowserViewController alloc] init];
    FeedsViewController *navigation = [super initWithRootViewController:_feeds];
    
    //添加delegate
    _feeds.delegate = self;
    navigation.fvcdelegate = delegate;
    
    //添加url
    _feeds.url = [[NSURL alloc] initWithString:[_fvcdelegate appendInfoParams:FEED_URL]];
    //添加导航关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(h_close)];
    _feeds.navigationItem.leftBarButtonItem = closeButton;
    _feeds.title = @"新浪推荐";
    
    return navigation;
}


- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    
    //如果不是feed页面
    if ([[url path] rangeOfString:@"/SinaEyeFeedPage/index.html"].location == NSNotFound) {
    
        NSLog(@"index view : %@, %@", [url host], [url path] );
    
        BrowserViewController *browser = [[BrowserViewController alloc] init];
        
        browser.url = url;
    
        [self pushViewController:browser animated:YES];
        return NO;
    }
    return YES;
}

-(void) h_close {
    NSLog(@"feeds close!!!!!!");
    
    //animate
    /**
     *typedef enum {
     UIModalTransitionStyleCoverVertical = 0,
     UIModalTransitionStyleFlipHorizontal,
     UIModalTransitionStyleCrossDissolve,
     UIModalTransitionStylePartialCurl,
     } UIModalTransitionStyle;
     */
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dealloc {
    NSLog(@"feedsNavigationController is dealloc");
}

@end
