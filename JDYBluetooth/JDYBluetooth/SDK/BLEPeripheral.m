//
//  BLEPeripheral.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//
//0x28自定义服务
#define kJDYServiceUUID @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"

//0x2d Write
#define kJDYWriteUUID @"49535343-8841-43F4-A8D4-ECBE34729BB3"

//0x2f Write Without Resq
#define kJDYWriteNoResqUUID @"xxxx"

//0x2A Notify
#define kJDYNotifyUUID @"49535343-1E4D-4BD9-BA61-23C647249616"

//0x31 Notify&Write
#define kJDYNotifyWriteUUID @"xxx"

#import "BLEPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>


typedef void (^ReceiveDataBlock)(NSData *data, NSError *error);
typedef void (^SendDataCompleteBlock)(NSError *error);

@interface BLEPeripheral()<CBPeripheralDelegate>

@property(nonatomic, strong) CBPeripheral * peripheral;
@property (nonatomic, copy) NSDictionary *advertisementData;

//UUID
@property (nonatomic, strong)CBUUID *mJDYServiceUUID;
@property (nonatomic, strong)CBUUID *mJDYNofifyUUID;
@property (nonatomic, strong)CBUUID *mJDYWriteUUID;

//特征值
@property (nonatomic, strong)CBCharacteristic *mJDYNotifyCharacteristic;
@property (nonatomic, strong)CBCharacteristic *mJDYWriteCharacteristic;

//block
@property (nonatomic, copy) ReceiveDataBlock receiveDataBlock;
@property (nonatomic, copy) SendDataCompleteBlock sendDataCompleteBlock;

@end

@implementation BLEPeripheral

- (NSString *)name {
    return _peripheral.name;
}
- (BLEPeripheralState)state {
    NSInteger st = _peripheral.state;
    return st;
}
- (instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData {
    self = [super init];
    if (self) {
        self.peripheral = peripheral;
        self.advertisementData = advertisementData;
        self.mJDYServiceUUID = [CBUUID UUIDWithString:kJDYServiceUUID];
        self.mJDYNofifyUUID  = [CBUUID UUIDWithString:kJDYNotifyUUID];
        self.mJDYWriteUUID   = [CBUUID UUIDWithString:kJDYWriteUUID];
        [_peripheral addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [_peripheral removeObserver:self forKeyPath:@"state"];
}

- (void)sendData:(NSData *)data type:(BLECharacteristicWriteType) type sendMessageCompleteBlock:(void (^)(NSError *))block {
    if (_mJDYWriteCharacteristic) {
        self.sendDataCompleteBlock = block;
        [_peripheral writeValue:data forCharacteristic:_mJDYWriteCharacteristic type:(CBCharacteristicWriteType)type];
    }
}

- (void)setReceiveMessageBlock:(void (^)(NSData *data, NSError *error))block {
    self.receiveDataBlock = block;
}


- (void)setPeripheral:(CBPeripheral *)peripheral {
    self.peripheral = peripheral;
}

- (CBPeripheral *)getPeripheral {
    return _peripheral;
}

- (void)setAdvertisementData:(NSDictionary *)advertisementData {
    self.advertisementData = advertisementData;
}
- (NSDictionary *)getAdvertisementData {
    return _advertisementData;
}

- (void)startdiscoverService {
    [self bt_disconnected];
    [_peripheral discoverServices:@[_mJDYServiceUUID]];
}

- (void)bt_disconnected {
    _canReceiveData = NO;
    _canSendData = NO;
    if (_mJDYNotifyCharacteristic.isNotifying) {
        [_peripheral setNotifyValue:NO forCharacteristic:_mJDYNotifyCharacteristic];
    }
    _mJDYNotifyCharacteristic = nil;
    _mJDYWriteCharacteristic = nil;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"num"] && object == _peripheral) {
        NSString *nStr = [change valueForKey:@"new"];
        NSInteger t = nStr.integerValue;
        if (t != CBPeripheralStateConnected) {
            [self bt_disconnected];
        }
    }
}

//-----------------------------delegate-------------
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID.data isEqualToData:_mJDYServiceUUID.data]) {
            [_peripheral discoverCharacteristics:@[_mJDYNofifyUUID, _mJDYWriteUUID] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    for (CBCharacteristic *c in service.characteristics) {
        if ([c.UUID.data isEqualToData:_mJDYNofifyUUID.data]) {
            self.mJDYNotifyCharacteristic = c;
            [_peripheral setNotifyValue:YES forCharacteristic:c];
            _canReceiveData = YES;
            continue;
        }else if ([c.UUID.data isEqualToData:_mJDYWriteUUID.data]) {
            self.mJDYWriteCharacteristic = c;
            _canSendData= YES;
            continue;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (_receiveDataBlock) {
        _receiveDataBlock(characteristic.value, error);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (_sendDataCompleteBlock) {
        _sendDataCompleteBlock(error);
    }
}

@end
