//
//  SAInfoProvider.m
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/13.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <sys/types.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

//for location
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

//import for str2md5
#import <CommonCrypto/CommonDigest.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#import <AdSupport/AdSupport.h>
#endif

#import "SAReachability.h"

#import "SAInfoProvider.h"


@interface SAInfoProvider () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *macAddress;
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) SAIdentity *identity;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation SAInfoProvider

//    1. 懒加载初始化：
- (CLLocationManager *) locationManager {
    if(!_locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // 设置定位精度
        // kCLLocationAccuracyNearestTenMeters:精度10米
        // kCLLocationAccuracyHundredMeters:精度100 米
        // kCLLocationAccuracyKilometer:精度1000 米
        // kCLLocationAccuracyThreeKilometers:精度3000米
        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
        // 它的单位是米，这里设置为至少移动1000m再通知委托处理更新;
        _locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    }
    return _locationManager;
}


- (void) startUpdateLocation {
    //    2. 调用请求：
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0) {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        NSLog(@"%f, %f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
    } else {
        NSLog(@"定位功能未开启");
    }
}

- (NSString *)geoLocation {
    return [NSString stringWithFormat:@"%f,%f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
}

//
- (NSString *) stringToMD5:(NSString *) aString {
    if(aString == nil || [aString length] == 0)
        return nil;
    
    const char *value = [aString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value,  (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
    return aString;
}

+ (SAInfoProvider *)shareInstance {
    static SAInfoProvider *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Get the singlton sax eye sdk.");
        info = [[SAInfoProvider alloc] init];
        //[info startUpdateLocation];
    });
    return info;
}

- (NSString *) deviceType {
    if(_deviceType == nil) {
        _deviceType = [self p_deviceTypeString];
    }
    return _deviceType;
}

- (NSString *) osVersion {
    if(_osVersion == nil) {
        NSString *ios = @"IOS";
        _osVersion = [ios stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
    }
    return _osVersion;
}

-(NSString *) macAddress {
    
    if (_macAddress == nil) {
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex("en0")) == 0) {
            printf("Error: if_nametoindex error\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 1\n");
            return NULL;
        }
        
        if ((buf = malloc(len)) == NULL) {
            printf("Could not allocate memory. error!\n");
            return NULL;
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            printf("Error: sysctl, take 2");
            free(buf);
            return NULL;
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
        free(buf);
        
        _macAddress =  outstring;
    }
    return _macAddress;
    
}

-(NSString *)md5MacAddress {
    return [self stringToMD5:[self macAddress]];
}

-(SAIdentity *) identifier {
    if(_identity == nil) {
        if ([self p_deviceHasASIdentifierManager]) {
            _identity = [[SAIdentity alloc] initWithType:@"IDFA" andValue:[self p_identifierFromASIdentifierManager]];
        }
        if(_identity == nil) {
            _identity = [[SAIdentity alloc] initWithType:@"MAC" andValue:[self md5MacAddress]];
        }
    }
    return _identity;
}

-(CGSize) screenSize {
    return [[UIScreen mainScreen] bounds].size;
}

-(NSString *)resolution {
    if (_resolution == nil) {
        CGSize size = [self screenSize];
        NSDecimalNumber *width = [[NSDecimalNumber alloc] initWithFloat:size.width];
        NSDecimalNumber *height = [[NSDecimalNumber alloc] initWithFloat:size.height];
        _resolution =  [NSString stringWithFormat:@"%d*%d", [width intValue], [height intValue]];
    }
    return _resolution;
}

-(UIInterfaceOrientation) orientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
}

-(NSString *) bundleIdentifier {
    return [[NSString alloc] initWithFormat:@"%@",[[self p_infoDictionary] objectForKey:@"CFBundleIdentifier"]];
}

- (NSInteger) networkType {
    NSInteger ret = 0; //unknown
    switch ([self p_networkType]) {
        case NotReachable:
            ret = -1;
            break;
        case ReachableViaWiFi:
            ret = 1;
            break;
        case ReachableViaWWAN:
            ret = 3;
            break;
        default:
            ret = 0;
            break;
    }
    return ret;
    return 0;
}

-(BOOL) isWIFI {
    if ([self p_networkType] == ReachableViaWiFi) {
        return YES;
    }else {
        return NO;
    }
}

-(NSString *)appVersion {
    return [[self p_infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(NSString *)carrierName {
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    return [carrier carrierName];
}


#pragma mark private

- (NSString *) p_deviceTypeString{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        platform = @"iPhone";
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        platform = @"iPhone 3G";
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        platform = @"iPhone 3GS";
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        platform = @"iPhone 4";
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        platform = @"iPhone 4S";
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        platform = @"iPhone 5";
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        platform = @"iPhone 5C";
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        platform = @"iPhone 5S";
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        platform = @"iPod touch 4";
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        platform = @"iPod touch 5";
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        platform = @"iPod touch 3";
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        platform = @"iPod touch 2";
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        platform = @"iPod touch";
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        platform = @"iPad 3";
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        platform = @"iPad 2";
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        platform = @"iPad 1";
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        platform = @"ipad mini";
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        platform = @"ipad 3";
    }
    
    return platform;
}

- (BOOL)p_advertisingTrackingEnabled
{
    BOOL enabled = YES;
    
    if ([self p_deviceHasASIdentifierManager]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
#endif
    }
    
    return enabled;
}

- (BOOL)p_deviceHasASIdentifierManager
{
    return !!NSClassFromString(@"ASIdentifierManager");
}

- (NSString *)p_identifierFromASIdentifierManager
{
    NSString *identifier = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    identifier = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
#endif
    return identifier;
}

- (NSDictionary *) p_infoDictionary {
    if (_infoDict == nil) {
        _infoDict = [[NSBundle mainBundle] infoDictionary];
    }
    return _infoDict;
}


- (NetworkStatus)p_networkType:(NSString *)hostname {
    SAReachability *reachability = [SAReachability reachabilityWithHostName:hostname];
    return [reachability currentReachabilityStatus];
}

- (NetworkStatus)p_networkType {
    SAReachability *reachability = [SAReachability reachabilityForInternetConnection];
    return [reachability currentReachabilityStatus];
}

- (NSMutableURLRequest *)buildRequestWithURL:(NSURL *)URL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    return request;
}

- (NSString *)userAgent
{
    if (!_userAgent) {
        _userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    
    return _userAgent;
}


#pragma mark - CLLocationManagerDelegate
// 3.代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%f, %f", manager.location.coordinate.latitude, manager.location.coordinate.longitude);
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"resume location update");
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"pause location update");
}


@end


/* SAIdentity 实现 */
@implementation SAIdentity

-(SAIdentity *)initWithType:(NSString *)type andValue:(NSString *)value {
    self = [super init];
    if (self) {
        _type = type;
        _value = value;
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"type=%@, value=%@", _type, _value ];
}
@end


