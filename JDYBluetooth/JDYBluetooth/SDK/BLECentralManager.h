//
//  BLECentralManager.h
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "BLEPeripheral.h"

typedef NS_ENUM(NSInteger, BLEManagerState) {
    BLEManagerStateUnknown = 0,
    BLEManagerStateResetting,
    BLEManagerStateUnsupported,
    BLEManagerStateUnauthorized,
    BLEManagerStatePoweredOff,
    BLEManagerStatePoweredOn,
};

typedef NS_ENUM(NSInteger, BLEConnectPeripheral) {
    BLEConnectPeripheralDisconnected = 0,
    BLEConnectPeripheralSuccess,
    BLEConnectPeripheralFail,
};

@interface BLECentralManager : NSObject

@property(nonatomic, assign, readonly) BLEManagerState state;
@property(nonatomic, assign, readonly) BOOL isScanning;

- (instancetype)initWithQueue:(dispatch_queue_t)queue updateState:(void (^)(BLEManagerState state))block;

//返回值YES 表示真实的调用了扫描方法
//返回值NO 表示由于正在扫描或者蓝牙未打开导致不能调用扫描方法
//超时后，会自动调用停止扫描
- (BOOL)scanWithTimeout:(NSTimeInterval)ti
     discoverPeripheral:(void (^)(BLEPeripheral *peripheral))discoverPeripheralBlock
               complete:(void (^)(void))scanCompleteBlock;
- (void)stopScanning;//停止扫描
//已经连接的蓝牙是搜索不到的，调用此方法可以获取
- (NSArray<BLEPeripheral *> *)retrieveConnectedPeripherals;


//连接
- (void) connectPerpheral:(BLEPeripheral *)peripheral connectStateChangeBlock:(void (^)(BLEPeripheral *peripheral, BLEConnectPeripheral state, NSError *error)) block;
//断开连接
- (void)disConnectBT:(BLEPeripheral *)peripheral;

@end
