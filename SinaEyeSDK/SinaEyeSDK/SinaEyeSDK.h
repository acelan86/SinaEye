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

+ (SinaEyeSDK *)shareInstance;

- (void)showFeeds:(UIViewController *)view;

@end
