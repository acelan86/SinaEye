//
//  SinaAdFeeds.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/3/12.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *FEEDS_URL = @"http://localhost:8000/SinaEyeFeedPage/index.html";
static const NSString *FEEDS_SDK_VERSION = @"1.0.0";

@protocol SinaAdFeedsDelegate <NSObject>
@optional
//当icon渲染完成后调用
- (void)feedsIconDidRendered:(UIButton *)icon;
@end

@interface SinaAdFeeds : NSObject
@property (nonatomic, assign) id<SinaAdFeedsDelegate> delegate;
- (SinaAdFeeds *)initWithAppkey:(NSString *)appkey apprid:(NSString *)apprid bundle:(NSBundle *)bundle;
- (void)renderIconInViewController:(UIViewController *)vc;
@end
