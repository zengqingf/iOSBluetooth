//
//  ScanTableViewCell.h
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanTableViewCell : UITableViewCell
- (void)setupIndexPath:(NSIndexPath *)indexPath name:(NSString *)name connectState:(BOOL)connected clickBlock:(void (^)(NSIndexPath *indexPath))btnClickBlock;
@end
