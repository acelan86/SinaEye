//
//  SAFeedsViewController.h
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/16.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAFeedsViewControllerDelegate <NSObject>

- (NSString *)appKey;
- (NSString *)appId;
- (NSString *)backgroundColor;
- (NSString *)feedsLocation;

@optional
- (NSString *)sdkVersion;
- (void)customLink:(NSURL *)url; //外链部分，需要打开新窗口或者做自定义处理

@end

@interface SAFeedsViewController : UIViewController
@property (nonatomic, assign) id<SAFeedsViewControllerDelegate> delegate;
@end
