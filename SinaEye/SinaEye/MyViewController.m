//
//  MyViewController.m
//  SinaEye
//
//  Created by 晓斌 蓝 on 15/2/6.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "MyViewController.h"
#import "SAFeedsAdView.h"

@interface MyViewController () <SAFeedsAdViewDelegate>
@property (strong, nonatomic) SAFeedsAdView *feedsAD;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
    
    //init default icon
    _feedsAD = [[SAFeedsAdView alloc] initWithApprid:@"4"
                                              appkey:@"123123"
                                  rootViewController:self
                                      feedsIconStyle:FeedsIconStyleWhite];
    
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

}

-(void)viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnMainView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
