//
//  ScanViewController.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "ScanViewController.h"
#import "BLECentralManager.h"

@interface ScanViewController ()
@property(nonatomic, strong)BLECentralManager *centralm;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)setupCentral {
    self.centralm = [[BLECentralManager alloc] initWithQueue:nil updateState:^(BLEManagerState status) {
        
    }];
    
    
}
- (IBAction)scan:(id)sender {
}
- (IBAction)stopScan:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
