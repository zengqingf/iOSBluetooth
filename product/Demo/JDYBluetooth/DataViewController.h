//
//  DataViewController.h
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/12/1.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface DataViewController : UIViewController
@property(strong)BLEPeripheral *peripheral;
@end
