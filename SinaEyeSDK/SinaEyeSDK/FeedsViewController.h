//
//  FeedsViewController.h
//  SinaEyeSDK
//
//  Created by 晓斌 蓝 on 15/2/6.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedsViewControllerDelegate <NSObject>

- (NSString *)appendInfoParams:(NSString *)url;

@end

@interface FeedsViewController : UINavigationController

@property (nonatomic, assign) id<FeedsViewControllerDelegate>fvcdelegate;

- (FeedsViewController *)initWithDelegate:(id<FeedsViewControllerDelegate>)delegate;

@end
