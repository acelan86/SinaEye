//
//  SinaEyeSDK.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SinaEyeSDK : NSObject

@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *apprid;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) UIButton *feedsButton;

- (SinaEyeSDK *) initFeedsADWithViewController:(UIViewController *)mainViewController apprid:(NSString *)apprid appkey:(NSString *)appkey;

- (void)showFeeds;

@end
