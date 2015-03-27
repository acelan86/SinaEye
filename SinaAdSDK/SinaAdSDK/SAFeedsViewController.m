//
//  SAFeedsViewController.m
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/16.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SAFeedsViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SAInfoProvider.h"

static NSString *FEEDS_URL = @"http://d1.sina.com.cn/litong/zhitou/sinaads/demo/SinaEyeFeedPage/index.html";
static const NSString *INNER_VERSION = @"1.0.0";

@interface SAFeedsViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIBarButtonItem *spinnerItem;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation SAFeedsViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height + 20)];
    
    [WebViewJavascriptBridge enableLogging];

    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    } resourceBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]]];
    
    //js call oc
    [_bridge registerHandler:@"getAppkey" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"get app key by js params: %@", data);
        responseCallback([_delegate appKey]);
    }];
    
    [_bridge registerHandler:@"jsNetError" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js net error, data.length: %@", data);
        responseCallback(@"OK");
    }];
    [_bridge registerHandler:@"jsNetSuccess" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js net success, data.length: %@", data);
        responseCallback(@"OK");
    }];
    
    //OC call js
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    [self.view addSubview:_webview];
    
    /* 创建进度指示器 */
    _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinner.hidesWhenStopped = YES;
    [self.spinner sizeToFit];
    [self.view addSubview:_spinner];
    
    //创建进度指示器约束
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *spinnerVConstraint = [NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *spinnerHConstraint = [NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:spinnerHConstraint];
    [self.view addConstraint:spinnerVConstraint];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SAInfoProvider *info = [SAInfoProvider shareInstance];
    
    if ([info networkType] == -1) {
        NSLog(@"no net connect!");
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]];
        NSURL *baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
        NSString *path = [bundle pathForResource:@"404" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"load 404:%@", html);
        [_webview loadHTMLString:html baseURL:baseURL];
    } else {
        NSString *url = [FEEDS_URL stringByAppendingFormat:@"?appkey=%@&apprid=%@&udid=%@&plat=%@&carrier=%li&os_version=%@&sdk_version=%@&brand=%@&bundleid=%@&devicemodel=%@&geo=%@&bgcolor=%@",
             //appkey
             [_delegate appKey],
             //apprid
             [_delegate appId],
             //设备id
             [[info identifier].value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //平台
             [@"IOS" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //网络
             (long)[info networkType],
             //操作系统版本 @"ios7"
             [[info osVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //sdk版本
             [_delegate respondsToSelector:@selector(sdkVersion)] ? [_delegate sdkVersion] : INNER_VERSION,
             //品牌
             [@"Apple" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //bundle id
             [[info bundleIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //设备型号 @"iphone 6p"
             [[info deviceType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //地理位置
             [[_delegate feedsLocation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
             //[[info geoLocation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
             [[_delegate backgroundColor] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        ];
        NSLog(@"load remote feedpage:%@", url);
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
        [_webview loadRequest:req];
    }
}

#pragma  mark SABrowserViewControllerDelegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    
    NSLog(@"request: %@, %@", [url absoluteString], [url scheme]);
    
    //如果不是feed页面, 且为https或者http协议下的链接
    if (([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"])
        && [[url absoluteString] rangeOfString:@"/SinaEyeFeedPage/index.html"].location == NSNotFound) {
        
        NSLog(@"index view : %@, %@", [url host], [url path] );
        
        if ([_delegate respondsToSelector:@selector(customLink:)]) {
            [_delegate customLink:url];
        }
        return NO;
    }
    return YES;
}
/* 请求失败 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (![_spinner isAnimating]) {
        [_spinner startAnimating];
    }
}

/* 请求成功 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_spinner isAnimating]) {
        [_spinner stopAnimating];
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
