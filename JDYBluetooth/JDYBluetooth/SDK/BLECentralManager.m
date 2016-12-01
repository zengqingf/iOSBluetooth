//
//  BLECentralManager.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "BLECentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLECentralBrage : NSObject
@property (nonatomic, strong)BLEPeripheral *ble_peripheral;
@property (nonatomic, copy)void (^connectStateChangeBlock)(BLEPeripheral *peripheral, BLEConnectPeripheral state, NSError *error);
- (instancetype)initWithBLEPeripheral:(BLEPeripheral *)ble_peripheral;
@end

@implementation BLECentralBrage
- (instancetype)initWithBLEPeripheral:(BLEPeripheral *)ble_peripheral {
    self = [super init];
    if (self) {
        self.ble_peripheral = ble_peripheral;
    }
    return self;
}
@end


typedef void (^CentralStatusBlock)(BLEManagerState status);
typedef void (^DiscoverPeripheralBlock)(BLEPeripheral *ble_peripheral);
typedef void (^ScanCompleteBlock)(void);

@interface BLECentralManager()<CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *central_manager;
@property (nonatomic, copy)CentralStatusBlock central_status_block;
@property (nonatomic, strong) NSMutableDictionary *dic_discover_bleperipheral;
@property (nonatomic, copy)DiscoverPeripheralBlock discover_peripheral_block;
@property (nonatomic, copy)ScanCompleteBlock scan_complete_block;
@end

@implementation BLECentralManager

- (instancetype)initWithQueue:(dispatch_queue_t)queue updateState:(void (^)(BLEManagerState status))block {
    self = [super init];
    if (self) {
        self.central_status_block = block;
        self.central_manager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
        self.dic_discover_bleperipheral = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return self;
}

- (BOOL)scanWithTimeout:(NSTimeInterval)ti discoverPeripheral:(void (^)(BLEPeripheral *ble_peripheral))discoverPeripheralBlock complete:(void (^)(void))scanCompleteBlock {
    self.discover_peripheral_block = discoverPeripheralBlock;
    self.scan_complete_block = scanCompleteBlock;
    if (_isScanning || _state != BLEManagerStatePoweredOn) {
        return NO;
    }
    [self.central_manager scanForPeripheralsWithServices:nil options:nil];
    _isScanning = YES;
    
    if (ti > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScanning) object:nil];
        [self performSelector:@selector(stopScanning) withObject:nil afterDelay:ti];
    }
    return _isScanning;
}

- (void)stopScanning {
    if(!_isScanning) return;
    [self.central_manager stopScan];
    _isScanning = NO;
    if (_scan_complete_block) {
        _scan_complete_block();
    }
}


static NSString *peripheral_key = @"peripheral";
- (void) connectPerpheral:(BLEPeripheral *)ble_peripheral connectStateChangeBlock:(void (^)(BLEPeripheral *peripheral, BLEConnectPeripheral state, NSError *error)) block {
    
    CBPeripheral *peripheral = [ble_peripheral valueForKey:peripheral_key];
    BLECentralBrage *brage = [_dic_discover_bleperipheral objectForKey:peripheral];
    brage.connectStateChangeBlock = block;
    [_central_manager connectPeripheral:peripheral options:nil];
}

- (void)disConnectBT:(BLEPeripheral *)ble_peripheral  {
    CBPeripheral *peripheral = [ble_peripheral valueForKey:peripheral_key];
    [_central_manager cancelPeripheralConnection:peripheral];
}


//--------delegate-------

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    _state = [self bleStateFromCBState:central.state];
    if (_central_status_block) {
        _central_status_block(_state);
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    BLECentralBrage *ble_brage = [_dic_discover_bleperipheral objectForKey:peripheral];
    if (ble_brage) {
        static NSString *adv_key = @"advertisementData";
        [ble_brage.ble_peripheral setValue:advertisementData forKey:adv_key];
        
    } else {
        BLEPeripheral *ble_peripheral = [[BLEPeripheral alloc] initWithCBPeripheral:peripheral advertisementData:advertisementData];
        ble_brage = [[BLECentralBrage alloc] initWithBLEPeripheral:ble_peripheral];
    }
    [_dic_discover_bleperipheral setObject:ble_brage forKey:peripheral];
    if (_discover_peripheral_block) {
        _discover_peripheral_block(ble_brage.ble_peripheral);
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    BLECentralBrage *brage = [_dic_discover_bleperipheral objectForKey:peripheral];
    peripheral.delegate = (id<CBPeripheralDelegate>)(brage.ble_peripheral);
    
    static NSString *stServiceName = @"startdiscoverService";
   
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL startService = NSSelectorFromString(stServiceName);
    [brage.ble_peripheral performSelector:startService];
#pragma clang diagnostic pop
    
    
    brage.connectStateChangeBlock(brage.ble_peripheral, BLEConnectPeripheralSuccess, nil);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    BLECentralBrage *brage = [_dic_discover_bleperipheral objectForKey:peripheral];
    brage.connectStateChangeBlock(brage.ble_peripheral, BLEConnectPeripheralFail, error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    BLECentralBrage *brage = [_dic_discover_bleperipheral objectForKey:peripheral];
    brage.connectStateChangeBlock(brage.ble_peripheral, BLEConnectPeripheralDisconnected, error);
}

//-----------------util---------------------
- (BLEManagerState)bleStateFromCBState:(CBManagerState) state {
    BLEManagerState ble_state = BLEManagerStateUnknown;
    NSInteger t = state;
    ble_state = t;
    return ble_state;
}

@end

