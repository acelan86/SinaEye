//
//  ViewController.m
//  SinaEye
//
//  Created by 晓斌 蓝 on 15/2/2.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "ViewController.h"
#import "SAFeedsAdView.h"
#import "MyViewController.h"

@interface ViewController () <SAFeedsAdViewDelegate>
@property (nonatomic, strong) SAFeedsAdView *feedsAD;
@property (nonatomic, strong) SAFeedsAdView *feedsAD2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"root";
    // Do any additional setup after loading the view, typically from a nib.
    
    //init default icon
    _feedsAD = [[SAFeedsAdView alloc] initWithApprid:@"4"
                                              appkey:@"123123"
                                  rootViewController:self];
    
//  other usage
//
//    _feedsAD = [[SAFeedsAdView alloc] initWithApprid:@"4"
//                                              appkey:@"123123"
//                                  rootViewController:self
//                                      feedsIconStyle:FeedsIconStyleGray];
//    
//    _feedsAD = [[SAFeedsAdView alloc] initWithApprid:@"4"
//                                              appkey:@"123123"
//                                  rootViewController:self
//                                      feedsIconStyle:FeedsIconStyleWhite
//                            feedsListBackgroundColor:@"#ffcc00"];
    //set delegate
    _feedsAD.delegate = self;
    //add to view
    [self.view addSubview:_feedsAD];
    
    _feedsAD.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *iconVConstraint = [NSLayoutConstraint constraintWithItem:_feedsAD attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:100.0f];
    NSLayoutConstraint *iconHConstraint = [NSLayoutConstraint constraintWithItem:_feedsAD attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    NSLayoutConstraint *iconWidthConstraint = [NSLayoutConstraint constraintWithItem:_feedsAD attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    NSLayoutConstraint *iconHeightConstraint = [NSLayoutConstraint constraintWithItem:_feedsAD attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    
    
    [self.view addConstraint:iconVConstraint];
    [self.view addConstraint:iconHConstraint];
    [self.view addConstraint:iconWidthConstraint];
    [self.view addConstraint:iconHeightConstraint];
    
    
    
    //init default icon
    _feedsAD2 = [[SAFeedsAdView alloc] initWithApprid:@"4"
                                              appkey:@"123123"
                                  rootViewController:self
                                       feedsIconStyle:FeedsIconStyleBlack];
    
    //  other usage
    //
    //    _feedsAD = [[SAFeedsAdView alloc] initWithApprid:@"4"
    //                                              appkey:@"123123"
    //                                  rootViewController:self
    //                                      feedsIconStyle:FeedsIconStyleGray];
    //
    //    _feedsAD = [[SAFeedsAdView alloc] initWithApprid:@"4"
    //                                              appkey:@"123123"
    //                                  rootViewController:self
    //                                      feedsIconStyle:FeedsIconStyleWhite
    //                            feedsListBackgroundColor:@"#ffcc00"];
    //set delegate
    _feedsAD2.delegate = self;
    //add to view
    [self.view addSubview:_feedsAD2];
    
    _feedsAD2.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *iconVConstraint2 = [NSLayoutConstraint constraintWithItem:_feedsAD2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:100.0f];
    NSLayoutConstraint *iconHConstraint2 = [NSLayoutConstraint constraintWithItem:_feedsAD2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
    NSLayoutConstraint *iconWidthConstraint2 = [NSLayoutConstraint constraintWithItem:_feedsAD2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    NSLayoutConstraint *iconHeightConstraint2 = [NSLayoutConstraint constraintWithItem:_feedsAD2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
    
    
    [self.view addConstraint:iconVConstraint2];
    [self.view addConstraint:iconHConstraint2];
    [self.view addConstraint:iconWidthConstraint2];
    [self.view addConstraint:iconHeightConstraint2];
}
- (IBAction)changeView:(id)sender {
    MyViewController *view = [[MyViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SAFeedsAdViewDelegate
- (void)feedsPageDidAppear {
    NSLog(@"feed appear");
}
- (void)feedsPageDidDisappear {
    NSLog(@"feed disappear");
}

@end
