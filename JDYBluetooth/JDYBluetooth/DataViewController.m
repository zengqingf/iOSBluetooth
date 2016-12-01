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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [_peripheral startReceiveDataWithBlock:^(NSData *data, NSError *error) {
        NSLog(@"收到数据");
        NSString *str = [BLETool hexStringWithData:data];
        _outTv.text = str;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
