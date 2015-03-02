//
//  SinaEyeSDK.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SinaEyeSDK.h"
#import "FeedsViewController.h"

@interface SinaEyeSDK ()
@property (nonatomic, weak) UIViewController *mainViewController;
@property (nonatomic, strong) FeedsViewController *feedsViewController;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSTimer *messageTimer;
@end

@implementation SinaEyeSDK

- (SinaEyeSDK *) initFeedsADWithViewController:(UIViewController *)mainViewController apprid:(NSString *)apprid appkey:(NSString *)appkey {
    self = [super init];
    if (self) {
        self.mainViewController = mainViewController;
        self.feedsViewController = [[FeedsViewController alloc] init];
        self.feedsViewController.apprid = apprid;
        self.feedsViewController.appkey = appkey;
        
        self.feedsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
        _bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]];
        
        [self showIconNormal];
        [self.mainViewController.view addSubview:self.feedsButton];
        
        [self.feedsButton addTarget:self action:@selector(showFeeds) forControlEvents:UIControlEventTouchUpInside];
        
        //设置定时器，进行新消息提醒
        _messageTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(showIconHasNewMessage) userInfo:nil repeats:YES];
        [_messageTimer fire];
    }
    return self;
}
- (void) showIconHasNewMessage {
    NSString *highlightIconPath = [_bundle pathForResource:@"ICON_05" ofType:@"png"];
    [self.feedsButton setImage:[UIImage imageWithContentsOfFile:highlightIconPath] forState:UIControlStateNormal];
}

- (void) showIconNormal {
    NSString *normalIconPath = [_bundle pathForResource:@"ICON_03" ofType:@"png"];
    [self.feedsButton setImage:[UIImage imageWithContentsOfFile:normalIconPath] forState:UIControlStateNormal];
}
- (void) showFeeds {
    [self showIconNormal];
    //切换view controller 为feedsViewController
    [self.mainViewController presentViewController:self.feedsViewController animated:YES completion:nil];
}

@end
