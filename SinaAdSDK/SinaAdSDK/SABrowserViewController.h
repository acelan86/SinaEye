//
//  SABrowserViewController.h
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SABrowserViewControllerDelegate <NSObject>

@optional
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface SABrowserViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate>

@property (nonatomic) BOOL hasToolbar;//是否需要toolbar

@property (nonatomic, assign) id<SABrowserViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURL *url;

- (void)loadPage:(NSURL *) url;
- (SABrowserViewController *)initWithToolbar;

@end
