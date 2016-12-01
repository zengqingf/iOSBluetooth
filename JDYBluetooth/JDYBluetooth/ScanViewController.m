//
//  ScanViewController.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanTableViewCell.h"
#import "DataViewController.h"
#import "BLE.h"

@interface ScanViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)BLECentralManager *central;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableSet *connectingPers;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIView *actiview;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource     = [NSMutableArray arrayWithCapacity:5];
    self.connectingPers = [NSMutableSet setWithCapacity:5];

    
    [_tableView registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _tableView.rowHeight = 80;
    
    [self setupCentral];
    
}

- (void)setupCentral {
    self.central = [[BLECentralManager alloc] initWithQueue:nil updateState:^(BLEManagerState state) {
        NSLog(@"蓝牙状态改变=%ld", state);
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
        [_dataSource addObjectsFromArray:[_connectingPers allObjects]];
        [_tableView reloadData];
        [self setbtnScanState:YES];
        
        
        __weak __typeof(self)weakSelf = self;
    
        [_central scanWithTimeout:5 discoverPeripheral:^(BLEPeripheral *peripheral) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dataArrAddobject:peripheral];
        } complete:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf setbtnScanState:NO];
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
                    [_connectingPers removeObject:peripheral];
                    break;
                case BLEConnectPeripheralSuccess:
                    NSLog(@"%@连接成功", peripheral.name);
                    [_connectingPers addObject:peripheral];
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
    BOOL connectState = (peripheral.state == BLEPeripheralStateConnected);
    
    __weak __typeof(self)weakSelf = self;
    [cell setupIndexPath:indexPath name:peripheral.name connectState:connectState clickBlock:^(NSIndexPath *indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        BLEPeripheral *peripheral = _dataSource[indexPath.row];
        [strongSelf connectOrDisconnectPeripheral:peripheral];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DataViewController *vc = [[DataViewController alloc] init];
    vc.peripheral = _dataSource[indexPath.row];
    [self.navigationController showViewController:vc sender:self];
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BLEPeripheral *peripheral = _dataSource[indexPath.row];
    return (peripheral.state == BLEPeripheralStateConnected);
}

@end
