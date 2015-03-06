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

@interface ViewController ()
@property (nonatomic, strong) SinaEyeSDK *feedSDK;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _feedSDK = [[SinaEyeSDK alloc] initFeedsADWithViewController:self apprid:@"my-apprid-is-acelan-test" appkey:@"123123"];
    // Do any additional setup after loading the view, typically from a nib.
    //约束sdk的按钮
    _feedSDK.feedsButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *iconVConstraint = [NSLayoutConstraint constraintWithItem:_feedSDK.feedsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:60.0f];
    NSLayoutConstraint *iconHConstraint = [NSLayoutConstraint constraintWithItem:_feedSDK.feedsButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    NSLayoutConstraint *iconWidthConstraint = [NSLayoutConstraint constraintWithItem:_feedSDK.feedsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    NSLayoutConstraint *iconHeightConstraint = [NSLayoutConstraint constraintWithItem:_feedSDK.feedsButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    
    
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
