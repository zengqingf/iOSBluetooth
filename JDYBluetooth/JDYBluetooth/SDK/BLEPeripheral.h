//
//  BLEPeripheral.h
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;//这个也得删掉
typedef NS_ENUM(NSInteger, BLEPeripheralState) {
    BLEPeripheralStateDisconnected = 0,
    BLEPeripheralStateConnecting,
    BLEPeripheralStateConnected,
    BLEPeripheralStateDisconnecting NS_AVAILABLE(NA, 9_0),
};

typedef NS_ENUM(NSInteger, BLECharacteristicWriteType) {
    BLECharacteristicWriteWithResponse = 0,
    BLECharacteristicWriteWithoutResponse,
};

@interface BLEPeripheral : NSObject

@property(retain, readonly) NSString *name;
@property(readonly) BLEPeripheralState state;

@property (readonly) BOOL canReceiveData;//是否可以接收消息
@property (readonly) BOOL canSendData;//是否可以发送消息

//如果type的类型是CBCharacteristicWriteWithResponse ，消息发送完成之后block会执行，否则block不执行
//实际发送数据过程中发现data超过60个字节之后蓝牙会产生异常，建议超过50个字节的数据进行拆包分批次发送
- (void)sendData:(NSData *)data type:(BLECharacteristicWriteType) type sendMessageCompleteBlock:(void (^)(NSError * error))block;
//监控蓝牙外设发过来的消息
- (void)startReceiveDataWithBlock:(void (^)(NSData *data, NSError *error))block;



//下面方法都要删掉
- (instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData;
- (void)startdiscoverService;
- (void)setPeripheral:(CBPeripheral *)peripheral;
- (CBPeripheral *)getPeripheral;

- (NSDictionary *)getAdvertisementData;

@end
