//
//  SAFeedsAdView.m
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SAFeedsAdView.h"
#import "SABrowserViewController.h"
#import "SAInfoProvider.h"

static NSString *FEEDS_URL = @"http://d1.sina.com.cn/litong/zhitou/sinaads/demo/SinaEyeFeedPage/index.html";
static const NSString *FEEDS_SDK_VERSION = @"1.0.0";

@interface SAFeedsAdView () <SABrowserViewControllerDelegate>
@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *apprid;

@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic, strong) CLLocation *location;

@end

@implementation SAFeedsAdView

- (SAFeedsAdView *)initWithApprid:(NSString *)apprid appkey:(NSString *)appkey rootViewController:(UIViewController *)rootViewController {
    self = [super initWithFrame:CGRectMake(0, 0, 34, 34)];
    if (self) {
        _apprid = apprid;
        _appkey = appkey;
        _rootViewController = rootViewController;
        _bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]];
        //设置按钮展现和时间
        [self p_showIconNormal];
        [self addTarget:self action:@selector(h_showFeedsView) forControlEvents:UIControlEventTouchUpInside];
        
        //设置定时器，进行新消息提醒
        _timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(p_showIconHasMsg) userInfo:nil repeats:YES];
        //先执行一次新消息提醒
        [_timer fire];
    }
    return self;
}

- (void)setLocation:(CLLocation *)location {
    _location = location;
}

- (void)p_showIconHasMsg {
    NSString *highlightIconPath = [_bundle pathForResource:@"ICON_05" ofType:@"png"];
    [self setImage:[UIImage imageWithContentsOfFile:highlightIconPath] forState:UIControlStateNormal];
}

- (void)p_showIconNormal {
    NSString *normalIconPath = [_bundle pathForResource:@"ICON_03" ofType:@"png"];
    [self setImage:[UIImage imageWithContentsOfFile:normalIconPath] forState:UIControlStateNormal];
}

- (void)h_close {
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)p_feedsUrl {
    SAInfoProvider *info = [SAInfoProvider shareInstance];
    
    
    NSString *locationString;
    if (_location == nil) {
        locationString = @"0.000,0.000";
    } else {
        locationString = [NSString stringWithFormat:@"%f,%f", _location.coordinate.latitude, _location.coordinate.longitude];
    }
    
    NSString *str = [FEEDS_URL stringByAppendingFormat:@"?appkey=%@&apprid=%@&udid=%@&plat=%@&carrier=%d&os_version=%@&sdk_version=%@&brand=%@&bundleid=%@&devicemodel=%@&geo=%@",
                     //appkey
                     _appkey,
                     //apprid
                     _apprid,
                     //设备id
                     [[info identifier].value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     //平台
                     [@"IOS" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     //网络
                     [info networkType],
                     //操作系统版本 @"ios7"
                     [[info osVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     //sdk版本
                     FEEDS_SDK_VERSION,
                     //品牌
                     [@"Apple" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     //bundle id
                     [[info bundleIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     //设备型号 @"iphone 6p"
                     [[info deviceType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     //地理位置
                     [locationString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                     //[[info geoLocation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                     ];
    return str;
}


//创建并显示feedsView
- (void)h_showFeedsView {
    SABrowserViewController *feedsView = [[SABrowserViewController alloc] init];
    feedsView.delegate = self;
    //添加url
    feedsView.url = [[NSURL alloc] initWithString:[self p_feedsUrl]];
    
    //初始化导航
    _navigation = [[UINavigationController alloc] initWithRootViewController:feedsView];
    
    //添加导航关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[self backButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_close)];
    feedsView.navigationItem.leftBarButtonItem = closeButton;
    feedsView.title = @"新浪推荐";
    
    [_rootViewController presentViewController:_navigation animated:YES completion:nil];
    
}

#pragma  mark SABrowserViewControllerDelegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    
    NSLog(@"request: %@", [url absoluteString]);
    
    //如果不是feed页面且不是本地文件
    if (!([[url absoluteString] rangeOfString:@"/SinaEyeFeedPage/index.html"].location != NSNotFound || [[url absoluteString] rangeOfString:@"file://"].location != NSNotFound)) {
        
        NSLog(@"index view : %@, %@", [url host], [url path] );
        
        SABrowserViewController *browser = [[SABrowserViewController alloc] initWithToolbar];
        browser.url = url;
        
        [_navigation pushViewController:browser animated:YES];
        return NO;
    }
    return YES;
}

- (UIImage *)backButtonImage {
    UIImage *backButtonImage = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){12,21}, NO, [[UIScreen mainScreen] scale]);
    {
        //// Color Declarations
        UIColor* backColor = [UIColor blackColor];
        
        //// BackButton Drawing
        UIBezierPath* backButtonPath = [UIBezierPath bezierPath];
        [backButtonPath moveToPoint: CGPointMake(10.9, 0)];
        [backButtonPath addLineToPoint: CGPointMake(12, 1.1)];
        [backButtonPath addLineToPoint: CGPointMake(1.1, 11.75)];
        [backButtonPath addLineToPoint: CGPointMake(0, 10.7)];
        [backButtonPath addLineToPoint: CGPointMake(10.9, 0)];
        [backButtonPath closePath];
        [backButtonPath moveToPoint: CGPointMake(11.98, 19.9)];
        [backButtonPath addLineToPoint: CGPointMake(10.88, 21)];
        [backButtonPath addLineToPoint: CGPointMake(0.54, 11.21)];
        [backButtonPath addLineToPoint: CGPointMake(1.64, 10.11)];
        [backButtonPath addLineToPoint: CGPointMake(11.98, 19.9)];
        [backButtonPath closePath];
        [backColor setFill];
        [backButtonPath fill];
        
        backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return backButtonImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
