//
//  SinaEyeSDK.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SinaEyeSDK.h"
#import "FeedsViewController.h"

@implementation SinaEyeSDK

+ (SinaEyeSDK *)shareInstance {
    static SinaEyeSDK *sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Get the singlton sax eye sdk.");
        sdk = [[SinaEyeSDK alloc] init];
    });
    return sdk;
}

- (void) showFeeds: (UIViewController *) viewController {
    FeedsViewController *feedsViewController = [[FeedsViewController alloc] init];
    //切换view controller 为feedsViewController
    [viewController presentViewController:feedsViewController animated:YES completion:nil];
}

@end
