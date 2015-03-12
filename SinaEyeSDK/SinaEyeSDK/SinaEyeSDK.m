//
//  SinaEyeSDK.m
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SinaEyeSDK.h"
#import "SinaEyeInfoProvider.h"

static NSString *SDK_VERSION = @"1.0.0";

@interface SinaEyeSDK ()
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation SinaEyeSDK

+ (SinaEyeSDK *)shareInstance {
    static SinaEyeSDK *sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Get the singlton sax eye sdk.");
        sdk = [[SinaEyeSDK alloc] init];
        sdk.bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SinaEyeResource" ofType:@"bundle"]];
    });
    return sdk;
}

/** 创建一个Feed流广告实例 */
- (SinaAdFeeds *)createFeedsAdWithAppkey:(NSString *)appkey apprid:(NSString *)apprid {
    return [[SinaAdFeeds alloc] initWithAppkey:appkey apprid:apprid bundle:_bundle];
}
@end
