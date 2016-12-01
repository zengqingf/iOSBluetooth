//
//  FirstViewController.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/12/1.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "FirstViewController.h"
#import "ScanViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(id)sender {
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController showViewController:vc sender:self];
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
