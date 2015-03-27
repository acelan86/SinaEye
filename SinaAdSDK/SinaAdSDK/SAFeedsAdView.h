//
//  SAFeedsAdView.h
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    FeedsIconStyleDefault = 1,
    FeedsIconStyleGray,
    FeedsIconStyleWhite
} FeedsIconStyle;

@protocol SAFeedsAdViewDelegate <NSObject>
@optional
- (void)feedsPageDidAppear; //当feeds面板打开
- (void)feedsPageDidDisappear; //当feeds面板关闭
@end

@interface SAFeedsAdView : UIButton

@property (nonatomic, assign) id<SAFeedsAdViewDelegate> delegate;

//rootViewController，广告展现容器
@property (nonatomic, weak) UIViewController *rootViewController;

//初始化feeds ad view
- (SAFeedsAdView *)initWithApprid:(NSString *)apprid appkey:(NSString *)appkey rootViewController:(UIViewController *)rootViewController;

- (SAFeedsAdView *)initWithApprid:(NSString *)apprid appkey:(NSString *)appkey rootViewController:(UIViewController *)rootViewController feedsIconStyle:(FeedsIconStyle)style;

- (SAFeedsAdView *)initWithApprid:(NSString *)apprid appkey:(NSString *)appkey rootViewController:(UIViewController *)rootViewController feedsIconStyle:(FeedsIconStyle)style feedsListBackgroundColor:(NSString *)color;

//设置location
- (void)setLocation:(CLLocation *)location;

@end
