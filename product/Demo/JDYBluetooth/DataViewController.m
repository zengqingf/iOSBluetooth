//
//  DataViewController.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/12/1.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "DataViewController.h"
#import "BLETool.h"

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet UITextView *inputTv;
@property (weak, nonatomic) IBOutlet UITextView *outTv;


@end

@implementation DataViewController
- (void)dealloc {
    NSLog(@"data -dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self receiveData];
}
- (IBAction)sendAction:(id)sender {
    
    NSString *content = _inputTv.text;
    NSData *data = [BLETool dataWithHexString:content];
    [_peripheral sendData:data type:BLECharacteristicWriteWithResponse sendMessageCompleteBlock:^(NSError *error) {
        NSLog(@"发送完成");
    }];
    
}

- (void)receiveData {
    __weak __typeof(self)weakSelf = self;
    [_peripheral startReceiveDataWithBlock:^(NSData *data, NSError *error) {
        NSString *str = [BLETool hexStringWithData:data];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.outTv.text = str;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
