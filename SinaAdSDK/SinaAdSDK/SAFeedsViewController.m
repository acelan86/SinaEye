//
//  SAFeedsViewController.m
//  SinaAdSDK
//
//  Created by 晓斌 蓝 on 15/3/16.
//  Copyright (c) 2015年 esina. All rights reserved.
//

#import "SAFeedsViewController.h"

@interface SAFeedsViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *list;
@property (nonatomic, strong) NSMutableArray *ds;
@end

@implementation SAFeedsViewController

- (void)loadView {
    _list = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = _list;
    [_list setDelegate:self];
    [_list setDataSource:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger page = 0;
    _ds = [self getList:page];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)getList:(NSInteger)page {
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:@"acelan", @"lanxiaobin", @"othername", nil];
    return list;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [_ds objectAtIndex:indexPath.row]);
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_ds objectAtIndex:indexPath.row];
    return cell;
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
