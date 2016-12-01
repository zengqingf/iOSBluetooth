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
@property (weak, nonatomic) IBOutlet UILabel *connectingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) BtnClickBlock btnclickblock;
@property (strong) NSIndexPath *indexPath;
@property (assign)BOOL connected;
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
    _connected = connected;
    self.backView.hidden = YES;
    if (connected) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        _rightConstraint.constant = -33;
        [_connectBtn setTitle:unconn forState:UIControlStateNormal];
    } else {
        self.accessoryType=UITableViewCellAccessoryNone;
        [_connectBtn setTitle:conn forState:UIControlStateNormal];
        _rightConstraint.constant = 0;
    }
    _indexPath = indexPath;
    _btnclickblock = btnClickBlock;
}

- (IBAction)btnAction:(id)sender {
    self.backView.hidden = NO;
    static NSString *conning = @"正在连接...";
    static NSString *unconning = @"正在断开...";
    if (!_connected) {
        _connectingLabel.text = conning;
    } else {
        _connectingLabel.text = unconning;
    }
    
    _btnclickblock(_indexPath);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
