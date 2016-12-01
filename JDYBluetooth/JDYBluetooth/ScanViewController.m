//
//  ScanViewController.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanTableViewCell.h"
#import "BLE.h"

@interface ScanViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)BLECentralManager *central;
@property (nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIView *actiview;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:5];
    // Do any additional setup after loading the view from its nib.
    
//    [_tableView registerClass:[ScanTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self setupCentral];
    
}

- (void)setupCentral {
    self.central = [[BLECentralManager alloc] initWithQueue:nil updateState:^(BLEManagerState status) {
        
    }];
    
    
}

- (void)dataArrAddobject:(id)object {
    
    if ([_dataSource indexOfObject:object] == NSNotFound) {
        [_tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSource.count inSection:0];
        [_dataSource addObject:object];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_tableView endUpdates];
    }
    
    
}

- (IBAction)scanOrStopAction:(id)sender {
    if (_central.isScanning) {
        [_central stopScanning];
        [self setbtnScanState:NO];
    } else {
        [_dataSource removeAllObjects];
        [_tableView reloadData];
        [self setbtnScanState:YES];
        [_central scanWithTimeout:10 discoverPeripheral:^(BLEPeripheral *peripheral) {
            [self dataArrAddobject:peripheral];
        } complete:^{
            [self setbtnScanState:NO];
        }];
    }
}

- (void)setbtnScanState:(BOOL) scan {
    if (scan) {
        static NSString *stopScanStr = @"停止扫描";
        [_scanBtn setTitle:stopScanStr forState:UIControlStateNormal];
        [_scanBtn setBackgroundColor:[UIColor redColor]];
        _actiview.hidden = NO;
    } else {
        static NSString *startScanStr = @"开始扫描";
        [_scanBtn setTitle:startScanStr forState:UIControlStateNormal];
        [_scanBtn setBackgroundColor:[UIColor orangeColor]];
        _actiview.hidden = YES;
    }
}

- (void)connectOrDisconnectPeripheral:(BLEPeripheral *)peripheral {
    
    if (peripheral.state == BLEPeripheralStateConnected) {
        [_central disConnectBT:peripheral];
    } else if (peripheral.state == BLEPeripheralStateDisconnected) {
        [_central connectPerpheral:peripheral connectStateChangeBlock:^(BLEPeripheral *peripheral, BLEConnectPeripheral state, NSError *error) {
            switch (state) {
                case BLEConnectPeripheralDisconnected:
                    NSLog(@"%@断开连接", peripheral.name);
                    break;
                case BLEConnectPeripheralSuccess:
                    NSLog(@"%@连接成功", peripheral.name);
                    break;
                case BLEConnectPeripheralFail:
                    NSLog(@"%@连接失败", peripheral.name);
                    break;
                    
                default:
                    break;
            }
            [_tableView reloadData];
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ide = @"cell";
    ScanTableViewCell *cell = (ScanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    BLEPeripheral *peripheral = _dataSource[indexPath.row];
    BOOL connectState = (peripheral.state ==  BLEPeripheralStateConnected);
    [cell setupIndexPath:indexPath name:peripheral.name connectState:connectState clickBlock:^(NSIndexPath *indexPath) {
        BLEPeripheral *peripheral = _dataSource[indexPath.row];
        [self connectOrDisconnectPeripheral:peripheral];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
