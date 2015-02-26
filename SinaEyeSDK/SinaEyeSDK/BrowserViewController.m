//
//  BrowserViewController.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) NSInteger webviewLoadCount;
@end

@implementation BrowserViewController

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webview = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    [self.view addSubview:_webview];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    _toolbar.backgroundColor = [UIColor whiteColor];
    
    _closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(h_close)];
    _backButton = [[UIBarButtonItem alloc] initWithImage:[self backButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_back)];
    _forwardButton = [[UIBarButtonItem alloc] initWithImage:[self forwardButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(h_forward)];
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(h_refresh)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _safariButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(h_openWithSafari)];
    
    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObjectsFromArray:[NSArray arrayWithObjects:_backButton, flexItem, _forwardButton, flexItem, _safariButton, flexItem, _refreshButton, flexItem, _closeButton, nil]];
    
    [_toolbar setItems:items];
    [self.view addSubview:_toolbar];
    
    /* 创建进度指示器 */
    _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _spinner.hidesWhenStopped = YES;
    [self.spinner sizeToFit];
    [self.view addSubview:_spinner];

    
    _webview.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do any additional setup after loading the view.
    _webviewLoadCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)h_close {
    [self dismissActionSheet];
    [self dismissViewControllerAnimated:YES completion:nil];
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

/** uiwebview delegate */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webview start load");
    _url = self.webview.request.URL;
    
    _refreshButton.enabled = YES;
    _safariButton.enabled = YES;
    if (![_spinner isAnimating]) {
        [_spinner startAnimating];
    }
    _webviewLoadCount++;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end