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
@property (nonatomic, strong) FeedsViewController *feedsViewController;
@end

@implementation SinaEyeSDK

- (SinaEyeSDK *) initFeedsADWithAppid:(NSString *)appid {
    self = [super init];
    if (self) {
        self.feedsViewController = [[FeedsViewController alloc] init];
        self.feedsViewController.appid = appid;
    }
    return self;
}
- (void) showFeeds: (UIViewController *) viewController {
    //切换view controller 为feedsViewController
    [viewController presentViewController:self.feedsViewController animated:YES completion:nil];
}

@end
