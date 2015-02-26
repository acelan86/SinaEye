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

//设备类型
@property (nonatomic, strong) NSString *deviceType;

//OS版本
@property (nonatomic, strong) NSString *osVersion;

//MAC地址
@property (nonatomic, strong) NSString *macAddress;

//md5后的MAC地址
@property (nonatomic, strong) NSString *md5MacAddress;

//屏幕尺寸
@property (nonatomic) CGSize screenSize;

//分辨率
@property (nonatomic, strong) NSString *resolution;

//屏幕朝向
@property (nonatomic) UIInterfaceOrientation orientation;

//BundleIdentifier
@property (nonatomic, strong) NSString *bundleIdentifier;

//是否能联网
//-(BOOL)isConnectionRequired;

//网络类型
@property (nonatomic) NSInteger networkType;

//app版本
@property (nonatomic, strong) NSString *appVersion;

//电信运营商
@property (nonatomic, strong) NSString *carrierName;

//设备id
@property (nonatomic, strong) NSString *uuid;



+ (SinaEyeSDK *)shareInstance;

- (void)showFeeds:(UIViewController *)view;

@end
