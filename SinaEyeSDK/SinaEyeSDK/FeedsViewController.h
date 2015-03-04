//
//  FeedsViewController.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/6.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong) NSString *apprid;
@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *sdkVersion;
@end
