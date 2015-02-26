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

static NSString *feedURL = @"http://d1.sina.com.cn/litong/zhitou/sinaads/demo/SinaEyeFeedPage/index.html";

@interface FeedsViewController ()
@property (nonatomic, strong) UIView *button;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *closebutton;
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *strURL = [feedURL stringByAppendingFormat:@"?uuid=%@&platform=%@", @"uuid-is-uuid", @"ios"];

    NSLog(@"open url: %@", strURL);
    
    NSURL *url = [[NSURL alloc] initWithString:strURL];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:req];

    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *toolbarVConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *toolbarWConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:toolbarVConstraint];
    [self.view addConstraint:toolbarWConstraint];
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
