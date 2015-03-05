//
//  BrowserViewController.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrowserViewControllerDelegate <NSObject>
@optional
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface BrowserViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate>

@property (nonatomic, assign) id<BrowserViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURL *url;

- (void)loadPage:(NSURL *) url;

@end
