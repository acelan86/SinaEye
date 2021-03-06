//
//  SABrowserViewController.m
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SABrowserViewController.h"
#import "SAInfoProvider.h"

@interface SABrowserViewController ()

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *safariButton;

@property (nonatomic,strong) UIBarButtonItem *spinnerItem;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;

@property (nonatomic, strong) UIScrollView *hiddenScrollView;


@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic) NSInteger webviewLoadCount;

@end

@implementation SABrowserViewController

- (SABrowserViewController *)initWithToolbar {
    SABrowserViewController *bvc = [[SABrowserViewController alloc] init];
    bvc.hasToolbar = YES;
    return bvc;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - (self.hasToolbar == YES ? 44 : 0) + 20)];
    } else {
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - (self.hasToolbar == YES ? 44 : 0) - 44.0f)];
    }
    
    [self.view addSubview:_webview];
    
    //创建toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    _toolbar.backgroundColor = [UIColor whiteColor];
    
    _backButton = [[UIBarButtonItem alloc] initWithImage:[self backButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_back)];
    _forwardButton = [[UIBarButtonItem alloc] initWithImage:[self forwardButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_forward)];
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(h_refresh)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _safariButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(h_openWithSafari)];
    
    _backButton.enabled = NO;
    _forwardButton.enabled = NO;
    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObjectsFromArray:[NSArray arrayWithObjects:_backButton, flexItem, _forwardButton, flexItem, _safariButton, flexItem, _refreshButton, nil]];
    
    [_toolbar setItems:items];
    [self.view addSubview:_toolbar];
    
    //指定toolbar的约束
    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *toolbarVConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *toolbarWConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:toolbarVConstraint];
    [self.view addConstraint:toolbarWConstraint];
    //end 创建toolbar
    
    if (self.hasToolbar != YES) {
        _toolbar.hidden = YES;
    }
    
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
    
    _webview.delegate = self;
    
    //[_webview.scrollView setScrollsToTop:NO];
    
    //    //添加一个隐藏的scrollview，用来实现点击状态条滚动到顶部
    //    _hiddenScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 500)];
    //    _hiddenScrollView.backgroundColor = [UIColor grayColor];
    //    [_hiddenScrollView setContentOffset:CGPointMake(0, 1000)];
    //    [_hiddenScrollView setContentSize:CGSizeMake(200, 2400)];
    //    _hiddenScrollView.scrollsToTop = YES;
    //    [self.view addSubview:_hiddenScrollView];
    //
    //    _hiddenScrollView.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _webviewLoadCount = 0;
    
    
    if (self.url) {
        if ([[SAInfoProvider shareInstance] networkType] == -1) {
            NSLog(@"no net connect!");
            NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]];
            NSURL *baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
            NSString *path = [bundle pathForResource:@"404" ofType:@"html"];
            NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"load 404:%@", html);
            [_webview loadHTMLString:html baseURL:baseURL];
        } else {
            NSLog(@"load remote feedpage:%@", self.url);
            [self loadPage:self.url];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)h_back {
    [self dismissActionSheet];
    [_webview goBack];
    [self refreshButtonStatus];
}
- (void)h_forward {
    [self dismissActionSheet];
    [_webview goForward];
    [self refreshButtonStatus];
}
- (void)h_refresh {
    [self dismissActionSheet];
    [_webview reload];
}

- (void)refreshButtonStatus {
    _backButton.enabled = self.webview.canGoBack;
    _forwardButton.enabled = self.webview.canGoForward;
}

- (void) h_openWithSafari {
    NSLog(@"open with safari");
    if (_actionSheet) {
        [self dismissActionSheet];
    }else {
        /* 创建actionsheet，open in safari， cancel两个按钮 */
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"Open in Safari", nil];
        if ([UIActionSheet instancesRespondToSelector:@selector(showFromBarButtonItem:animated:)]) {
            [_actionSheet showFromBarButtonItem:_safariButton animated:YES];
        } else {
            [_actionSheet showInView:self.view];
        }
    }
}

- (void)dismissActionSheet
{
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    _actionSheet = nil;
    
}

/* 用safari打开链接，使用actionSheet的delegate, h文件中声明实现actionsheet的delegate */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    _actionSheet = nil;
    switch (buttonIndex) {
            //@open with safari
        case 0:
            [[UIApplication sharedApplication] openURL:_url];
            break;
            
        default:
            break;
    }
}

#pragma mark uiwebview delegate

/* 请求失败 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webview start load");
    _url = self.webview.request.URL;
    
    _refreshButton.enabled = YES;
    _safariButton.enabled = YES;
    if (![_spinner isAnimating]) {
        [_spinner startAnimating];
    }
    _webviewLoadCount++;
    
    if ([_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_delegate webViewDidStartLoad:webView];
    }
}

/* 请求成功 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webview finish load");
    _webviewLoadCount--;
    if (self.webviewLoadCount > 0) return;
    
    _refreshButton.enabled = YES;
    _safariButton.enabled = YES;
    [self refreshButtonStatus];
    if ([self.spinner isAnimating]) {
        [self.spinner stopAnimating];
    }
    
    if ([_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:webView];
    }
}

/* 拦截请求并做特殊处理 */
-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}



- (void)loadPage:(NSURL *)url {
    NSLog(@"loadpage: %@", url);
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:req];
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

- (UIImage *)forwardButtonImage {
    UIImage *forwardButtonImage = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){12,21}, NO, [[UIScreen mainScreen] scale]);
    {
        //// Color Declarations
        UIColor* forwardColor = [UIColor blackColor];
        
        //// BackButton Drawing
        UIBezierPath* forwardButtonPath = [UIBezierPath bezierPath];
        [forwardButtonPath moveToPoint: CGPointMake(1.1, 0)];
        [forwardButtonPath addLineToPoint: CGPointMake(0, 1.1)];
        [forwardButtonPath addLineToPoint: CGPointMake(10.9, 11.75)];
        [forwardButtonPath addLineToPoint: CGPointMake(12, 10.7)];
        [forwardButtonPath addLineToPoint: CGPointMake(1.1, 0)];
        [forwardButtonPath closePath];
        [forwardButtonPath moveToPoint: CGPointMake(0.02, 19.9)];
        [forwardButtonPath addLineToPoint: CGPointMake(1.12, 21)];
        [forwardButtonPath addLineToPoint: CGPointMake(11.46, 11.21)];
        [forwardButtonPath addLineToPoint: CGPointMake(10.36, 10.11)];
        [forwardButtonPath addLineToPoint: CGPointMake(0.02, 19.9)];
        [forwardButtonPath closePath];
        [forwardColor setFill];
        [forwardButtonPath fill];
        
        forwardButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    
    return forwardButtonImage;
}

- (void)dealloc {
    NSLog(@"browser is dealloc");
}
@end