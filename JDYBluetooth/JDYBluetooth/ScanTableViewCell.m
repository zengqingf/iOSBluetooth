//
//  ScanTableViewCell.m
//  JDYBluetooth
//
//  Created by zengqingfu on 2016/11/30.
//  Copyright © 2016年 zengqingfu. All rights reserved.
//

#import "ScanTableViewCell.h"


typedef void (^BtnClickBlock)(NSIndexPath *indexPath);
@interface ScanTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (nonatomic, copy) BtnClickBlock btnclickblock;
@property (strong) NSIndexPath *indexPath;
@end

@implementation ScanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"23");
    }
    return self;
}

- (void)setupIndexPath:(NSIndexPath *)indexPath name:(NSString *)name connectState:(BOOL)connected clickBlock:(void (^)(NSIndexPath *))btnClickBlock {
    
    static NSString *conn = @"连接";
    static NSString *unconn = @"断开";
    
    _nameLabel.text = name;
    
    if (connected) {
        [_connectBtn setTitle:unconn forState:UIControlStateNormal];
    } else {
        [_connectBtn setTitle:conn forState:UIControlStateNormal];
    }
    _indexPath = indexPath;
    _btnclickblock = btnClickBlock;
}

- (IBAction)btnAction:(id)sender {
    
    _btnclickblock(_indexPath);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
