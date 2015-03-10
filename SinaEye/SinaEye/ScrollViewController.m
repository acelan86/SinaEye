//
//  ScrollViewController.m
//  SinaEye
//
//  Created by 晓斌 蓝 on 15/3/10.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController () <UIWebViewDelegate>

@end

@implementation ScrollViewController

- (void)loadView {
    UIWebView *webview = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
    [view addSubview:webview];
    [webview loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://sina.cn"]]];
    webview.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scroll to top");
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
