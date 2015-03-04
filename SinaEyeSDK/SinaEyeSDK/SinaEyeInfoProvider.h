//
//  SinaEyeInfoProvider.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/27.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SinaEyeIdentity;

@interface SinaEyeInfoProvider : NSObject

//Geo location (经度,纬度)
- (NSString *)geoLocation;

//设备类型
- (NSString *) deviceType;

//OS版本
- (NSString *) osVersion;

//MAC地址
- (NSString *) macAddress;

//md5后的MAC地址
- (NSString *) md5MacAddress;

//屏幕尺寸
- (CGSize) screenSize;

//分辨率
- (NSString *) resolution;

//屏幕朝向
- (UIInterfaceOrientation) orientation;

//BundleIdentifier
- (NSString *) bundleIdentifier;

//是否能联网
//-(BOOL)isConnectionRequired;

//网络类型
- (NSInteger) networkType;

//app版本
- (NSString *) appVersion;

//电信运营商
- (NSString *) carrierName;

//设备id
- (SinaEyeIdentity *) identifier;


+ (SinaEyeInfoProvider *)shareInstance;

@end


/**
 * 身份唯一标示符
 */
@interface SinaEyeIdentity : NSObject
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *value;

-(SinaEyeIdentity *)initWithType:(NSString *)type andValue:(NSString *)value;
@end

