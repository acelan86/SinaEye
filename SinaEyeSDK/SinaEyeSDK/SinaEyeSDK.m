//
//  SinaEyeSDK.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SinaEyeSDK.h"
#import "SinaEyeInfoProvider.h"
#import "FeedsViewController.h"

static NSString *SDK_VERSION = @"1.0.0";

@interface SinaEyeSDK () <FeedsViewControllerDelegate>
@property (nonatomic, weak) UIViewController *mainViewController;
@property (nonatomic, strong) FeedsViewController *feedsViewController;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSTimer *messageTimer;
@property (nonatomic, strong) UINavigationController *navigator;
@end

@implementation SinaEyeSDK

- (SinaEyeSDK *) initFeedsADWithViewController:(UIViewController *)mainViewController apprid:(NSString *)apprid appkey:(NSString *)appkey {
    self = [super init];
    if (self) {
        //配置项
        _sdkVersion = SDK_VERSION;
        _appkey = appkey;
        _apprid = apprid;
        _mainViewController = mainViewController;
        _bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]];
        
        //创建信息流广告入口按钮
        _feedsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
        [self showIconNormal];
        [_mainViewController.view addSubview:_feedsButton];
        [_feedsButton addTarget:self action:@selector(showFeeds) forControlEvents:UIControlEventTouchUpInside];
        //设置定时器，进行新消息提醒
        _messageTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(showIconHasNewMessage) userInfo:nil repeats:YES];
        //先执行一次新消息提醒
        [_messageTimer fire];
    }
    return self;
}
//以新消息形式来展现按钮
- (void) showIconHasNewMessage {
    NSString *highlightIconPath = [_bundle pathForResource:@"ICON_05" ofType:@"png"];
    [_feedsButton setImage:[UIImage imageWithContentsOfFile:highlightIconPath] forState:UIControlStateNormal];
}
//以无消息正常形式展现按钮
- (void) showIconNormal {
    NSString *normalIconPath = [_bundle pathForResource:@"ICON_03" ofType:@"png"];
    [self.feedsButton setImage:[UIImage imageWithContentsOfFile:normalIconPath] forState:UIControlStateNormal];
}
//入口按钮触发事件，打开feeds页面
- (void) showFeeds {
    [self showIconNormal];
    //初始化一个feedsVC
    FeedsViewController *feedsViewController = [[FeedsViewController alloc] initWithDelegate:self];
    [self.mainViewController presentViewController:feedsViewController animated:YES completion:nil];
}


//FeedsViewControllerDelegate
- (NSString *)appendInfoParams:(NSString *)url {
    //当webView加载完成后执行
    SinaEyeInfoProvider *info = [SinaEyeInfoProvider shareInstance];
    NSString *str = [url stringByAppendingFormat:@"?appkey=%@&apprid=%@&udid=%@&plat=%@&carrier=%ld&os_version=%@&sdk_version=%@&brand=%@&bundleid=%@&devicemodel=%@&geo=%@",
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
                        //sdk版本
                        _sdkVersion,
                        //品牌
                        [@"Apple" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        //bundle id
                        [[info bundleIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        //设备型号 @"iphone 6p"
                        [[info deviceType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        //地理位置
                        [[info geoLocation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                        ];
    return str;
}
@end
