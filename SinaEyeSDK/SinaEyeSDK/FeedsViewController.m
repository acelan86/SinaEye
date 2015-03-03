//
//  FeedsViewController.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/6.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "FeedsViewController.h"
#import "BrowserViewController.h"
#import "SinaEyeSDK.h"
#import "SinaEyeInfoProvider.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

static NSString *feedURL = @"http://d1.sina.com.cn/litong/zhitou/sinaads/demo/SinaEyeFeedPage/index.html";

@interface FeedsViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) UIView *button;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *closebutton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation FeedsViewController

//    1. 懒加载初始化：
- (CLLocationManager *)locationManager{
    if(!_locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // 设置定位精度
        // kCLLocationAccuracyNearestTenMeters:精度10米
        // kCLLocationAccuracyHundredMeters:精度100 米
        // kCLLocationAccuracyKilometer:精度1000 米
        // kCLLocationAccuracyThreeKilometers:精度3000米
        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
        // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
        _locationManager.distanceFilter = 50.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    }
    return _locationManager;
}


- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] applicationFrame].origin.y, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - 44)];
    _webview.backgroundColor = [UIColor whiteColor];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    
    _toolbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolbar];
    
    _closebutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(h_close)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [items addObjectsFromArray:[NSArray arrayWithObjects:flexItem, _closebutton, nil]];
    
    [_toolbar setItems:items];
    
    /* 创建进度指示器 */
    _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinner.hidesWhenStopped = YES;
    [self.spinner sizeToFit];
    [self.view addSubview:_spinner];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    2. 调用请求：
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0) {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        NSLog(@"%f, %f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
    } else {
        NSLog(@"定位功能未开启");
    }
    
    // Do any additional setup after loading the view.
    SinaEyeInfoProvider *info = [SinaEyeInfoProvider shareInstance];
    NSString *strURL = [feedURL stringByAppendingFormat:@"?appkey=%@&apprid=%@&udid=%@&plat=%@&carrier=%ld&os_version=%@&brand=%@&bundleid=%@&devicemodel=%@",
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
                        //品牌
                        [@"Apple" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        //bundle id
                        [[info bundleIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        //设备型号 @"iphone 6p"
                        [[info deviceType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                    ];

    NSLog(@"open url: %@", strURL);
    
    NSURL *url = [[NSURL alloc] initWithString:strURL];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:req];

    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *toolbarVConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *toolbarWConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:toolbarVConstraint];
    [self.view addConstraint:toolbarWConstraint];
    
    //创建进度指示器约束
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *spinnerVConstraint = [NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *spinnerHConstraint = [NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:spinnerHConstraint];
    [self.view addConstraint:spinnerVConstraint];
}

- (void) viewDidDisappear:(BOOL)animated {
    [_locationManager stopUpdatingLocation];
}

-(void) h_close {
    NSLog(@"close!!!!!!");
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebviewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"feeds start load");
    if (![_spinner isAnimating]) {
        [_spinner startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"feeds finish load");
    if ([self.spinner isAnimating]) {
        [self.spinner stopAnimating];
    }
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    
    //如果不是feed页面
    if ([[url path] rangeOfString:@"/SinaEyeFeedPage/index.html"].location == NSNotFound) {
    
        NSLog(@"index view : %@, %@", [url host], [url path] );
    
        BrowserViewController *browserVC = [[BrowserViewController alloc] init];
    
        [self presentViewController:browserVC animated:YES completion:^{
            [browserVC loadPage:url];
        }];
        return NO;
    }
//    switch ([self interceptType:url navigationType:navigationType]) {
//        case kSAXAdViewRequestTypeClick:
//            //TODO:异步发送点击监控
//            
//            self.adBrowerManager = [[SaxAdBrowerAgent alloc] initWithUrl:url];
//            self.adBrowerManager.delegate = self;
//            [self.adBrowerManager  requestUrl];
//            [self presentViewController:self.adBrowerManager.browerController animated:YES completion:nil];
//            return NO;
//            break;
//        case kSAXAdViewRequestTypeSAX:
//            [self.jsBridge processURL:url forWebView:webView];
//            return NO;
//            break;
//        default:
//            break;
//    }
//    
//    // for other url
//    SAXLogInfo(@"Normal process.");
    return YES;
}

#pragma mark - CLLocationManagerDelegate
// 3.代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%f, %f", manager.location.coordinate.latitude, manager.location.coordinate.longitude);
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"resume location update");
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"pause location update");
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
