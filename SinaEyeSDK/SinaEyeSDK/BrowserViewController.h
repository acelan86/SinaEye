//
//  BrowserViewController.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *closeButton;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *safariButton;

@property (nonatomic,strong) UIBarButtonItem *spinnerItem;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;


@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) NSURL *url;

- (void)loadPage:(NSURL *) url;

@end
