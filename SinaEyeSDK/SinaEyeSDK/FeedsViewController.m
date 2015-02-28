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

static NSString *feedURL = @"http://d1.sina.com.cn/litong/zhitou/sinaads/demo/SinaEyeFeedPage/index.html";

@interface FeedsViewController ()
@property (nonatomic, strong) UIView *button;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *closebutton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation FeedsViewController

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
    // Do any additional setup after loading the view.
    SinaEyeInfoProvider *info = [SinaEyeInfoProvider shareInstance];
    NSString *strURL = [feedURL stringByAppendingFormat:@"?appid=%@&udid=%@&platform=%@&carrier=%ld&os_version=%@&brand=%@&bundleid=%@&devicemodel=%@",
                        //appid
                        _appid,
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
