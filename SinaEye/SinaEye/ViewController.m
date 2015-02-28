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
    
    _feedSDK = [[SinaEyeSDK alloc] initFeedsADWithAppid:@"my-appid-is-acelan-test"];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickButton:(id)sender {
//    MyViewController *view = [[MyViewController alloc] init];
//    [self presentViewController:view animated:YES completion:nil];
    [_feedSDK showFeeds:self];
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
