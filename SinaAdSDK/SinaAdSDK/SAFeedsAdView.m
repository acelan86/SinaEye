//
//  SAFeedsAdView.m
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SAFeedsAdView.h"
#import "SAFeedsViewController.h"
#import "SABrowserViewController.h"

static const NSString *FEEDS_SDK_VERSION = @"1.0.0";
static const float FEEDS_REFRESH_FREQUENCE = 30; //红点刷新时间

@interface SAFeedsAdView () <SAFeedsViewControllerDelegate>
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:FEEDS_REFRESH_FREQUENCE target:self selector:@selector(p_showIconHasMsg) userInfo:nil repeats:YES];
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
    //重新创建30s timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(p_showIconHasMsg) userInfo:nil repeats:YES];
    
    if ([_delegate respondsToSelector:@selector(feedsPageDidDisappear)]) {
        [_delegate feedsPageDidDisappear];
    }
}

# pragma mark SAFeedsViewControllerDelegate

- (NSString *)appKey {
    return _appkey;
}
- (NSString *)appId {
    return _apprid;
}
- (NSString *)feedsLocation {
    return _location ?
        [NSString stringWithFormat:@"%f,%f", _location.coordinate.latitude, _location.coordinate.longitude] :
        @"0.000,0.000";
}

- (void)customLink:(NSURL *)url {
    SABrowserViewController *browser = [[SABrowserViewController alloc] initWithToolbar];
    browser.url = url;
    [_navigation pushViewController:browser animated:YES];
}

//创建并显示feedsView
- (void)h_showFeedsView {
    //停止timer，并设置icon为无新消息模式
    [_timer invalidate];
    _timer = nil;
    [self p_showIconNormal];
    
    //创建并显示feeds
    SAFeedsViewController *feedsViewController = [[SAFeedsViewController alloc] init];
    feedsViewController.delegate = self;
    //初始化导航
    _navigation = [[UINavigationController alloc] initWithRootViewController:feedsViewController];
    
    //添加导航关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[self backButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_close)];
    feedsViewController.navigationItem.leftBarButtonItem = closeButton;
    feedsViewController.title = @"新浪推荐";
    
    [_rootViewController presentViewController:_navigation animated:YES completion:nil];
    
    if ([_delegate respondsToSelector:@selector(feedsPageDidAppear)]) {
        [_delegate feedsPageDidAppear];
    }
    
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
    _rootViewController = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
