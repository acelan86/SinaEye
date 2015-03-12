//
//  ViewController.m
//  SinaEye
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "ViewController.h"
#import "SinaEyeSDK.h"
#import "MyViewController.h"

@interface ViewController () <SinaAdFeedsDelegate>
@property (nonatomic, strong) SinaEyeSDK *sdk;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个feed广告位
    SinaAdFeeds *feedsAd = [[SinaEyeSDK shareInstance] createFeedsAdWithAppkey:@"123123" apprid:@"4"];
    feedsAd.delegate = self;
    [feedsAd renderIconInViewController:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)feedsIconDidRendered:(UIButton *)icon {
    //约束sdk的按钮
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *iconVConstraint = [NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:60.0f];
    NSLayoutConstraint *iconHConstraint = [NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    NSLayoutConstraint *iconWidthConstraint = [NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    NSLayoutConstraint *iconHeightConstraint = [NSLayoutConstraint constraintWithItem:icon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    
    
    [self.view addConstraint:iconVConstraint];
    [self.view addConstraint:iconHConstraint];
    [self.view addConstraint:iconWidthConstraint];
    [self.view addConstraint:iconHeightConstraint];
}
- (IBAction)changeView:(id)sender {
    MyViewController *view = [[MyViewController alloc] init];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
