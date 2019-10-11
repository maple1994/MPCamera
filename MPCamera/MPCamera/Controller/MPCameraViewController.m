//
//  MPCameraViewController.m
//  MPCamera
//
//  Created by Maple on 2019/10/11.
//  Copyright © 2019 Beauty-ruanjian. All rights reserved.
//

#import "MPCameraViewController.h"

@interface MPCameraViewController ()

@end

@implementation MPCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UISwitch *swicth = [[UISwitch alloc] init];
    [self.view addSubview:swicth];
    [swicth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
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
