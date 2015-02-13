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

@property (strong, nonatomic) SinaEyeSDK *sdk;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _sdk = [[SinaEyeSDK alloc] init];
    //[_sdk showFeeds:self];
}
- (IBAction)clickButton:(id)sender {
//    MyViewController *view = [[MyViewController alloc] init];
//    [self presentViewController:view animated:YES completion:nil];
    [_sdk showFeeds:self];
}

-(void)viewDidAppear:(BOOL)animated {
    //[_sdk showFeeds:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
