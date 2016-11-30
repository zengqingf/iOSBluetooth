//
//  ScanViewController.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "ScanViewController.h"
#import "BLECentralManager.h"
#import "ScanTableViewCell.h"

@interface ScanViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)BLECentralManager *central;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [_tableView registerClass:[ScanTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

- (void)setupCentral {
    self.central = [[BLECentralManager alloc] initWithQueue:nil updateState:^(BLEManagerState status) {
        
    }];
    
    
}
- (IBAction)scanOrStopAction:(id)sender {
    
    if (sender) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ide = @"cell";
    return [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
