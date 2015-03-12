//
//  SinaAdFeeds.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/3/12.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SinaAdFeeds.h"
#import "BrowserViewController.h"
#import "SinaEyeInfoProvider.h"

@interface SinaAdFeeds () <BrowserViewControllerDelegate>
@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *apprid;

@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, weak)   UIViewController *container;
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation SinaAdFeeds
- (SinaAdFeeds *)initWithAppkey:(NSString *)appkey apprid:(NSString *)apprid bundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        _appkey = appkey;
        _apprid = apprid;
        _bundle = bundle;
    }
    return self;
}
- (void)renderIconInViewController:(UIViewController *)vc{
    _container = vc;
    
    //创建信息流广告入口按钮
    _icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [self p_showIconNormal];
    [_container.view addSubview:_icon];
    [_icon addTarget:self action:@selector(h_showFeedsView) forControlEvents:UIControlEventTouchUpInside];
    
    //设置定时器，进行新消息提醒
    _timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(p_showIconHasMsg) userInfo:nil repeats:YES];
    //先执行一次新消息提醒
    [_timer fire];
    
    [_delegate feedsIconDidRendered:_icon];
}

#pragma mark prive method
- (void)p_showIconHasMsg {
    NSString *highlightIconPath = [_bundle pathForResource:@"ICON_05" ofType:@"png"];
    [_icon setImage:[UIImage imageWithContentsOfFile:highlightIconPath] forState:UIControlStateNormal];
}

- (void)p_showIconNormal {
    NSString *normalIconPath = [_bundle pathForResource:@"ICON_03" ofType:@"png"];
    [_icon setImage:[UIImage imageWithContentsOfFile:normalIconPath] forState:UIControlStateNormal];
}
- (void)h_close {
    [_container dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)h_feedsUrl {
    SinaEyeInfoProvider *info = [SinaEyeInfoProvider shareInstance];
    NSString *str = [FEEDS_URL stringByAppendingFormat:@"?appkey=%@&apprid=%@&udid=%@&plat=%@&carrier=%ld&os_version=%@&sdk_version=%@&brand=%@&bundleid=%@&devicemodel=%@&geo=%@",
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
                     [[info geoLocation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                     ];
    return str;
}


//创建并显示feedsView
- (void)h_showFeedsView {
    BrowserViewController *feedsView = [[BrowserViewController alloc] init];
    feedsView.delegate = self;
    //添加url
    feedsView.url = [[NSURL alloc] initWithString:[self h_feedsUrl]];
    
    //初始化导航
    _navigation = [[UINavigationController alloc] initWithRootViewController:feedsView];
    
    //添加导航关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[self backButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_close)];
    feedsView.navigationItem.leftBarButtonItem = closeButton;
    feedsView.title = @"新浪推荐";
    
    [_container presentViewController:_navigation animated:YES completion:nil];
    
}

#pragma  mark browserViewController delegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    
    NSLog(@"request: %@", [url absoluteString]);
    
    //如果不是feed页面且不是本地文件
    if (!([[url absoluteString] rangeOfString:@"/SinaEyeFeedPage/index.html"].location != NSNotFound || [[url absoluteString] rangeOfString:@"file://"].location != NSNotFound)) {
        
        NSLog(@"index view : %@, %@", [url host], [url path] );
        
        BrowserViewController *browser = [[BrowserViewController alloc] initWithToolbar];
        
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

- (void)dealloc {
    NSLog(@"feeds ad is dealloc");
}

@end
