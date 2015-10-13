//
//  NBMerchantPromotView.m
//  NoodleBar
//
//  Created by sen on 5/30/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "NBMerchantPromotView.h"
#import "NBCommon.h"


@interface NBMerchantPromotView ()
//@property(nonatomic, assign) BOOL didSetupConstraint;
@property(nonatomic, strong) NSMutableArray *buttons;
@end

@implementation NBMerchantPromotView




- (void)updateConstraints
{
//    if (!self.didSetupConstraint) {
        for (int i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
            if (i % 2 == 0) { // 第一列
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self);
                }];
            }else // 第二列
            {
                UIButton *lastButton = self.buttons[i-1];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastButton.mas_right);
                }];
            }
            
            if (i < 2) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button.superview).offset(10.0);
                }];

            }else
            {
                UIButton *lastButton = self.buttons[i-2];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastButton.mas_bottom).offset(16.0);
                }];
            }
//            if (lastRowButton == nil) { // 第一行
//                                lastRowButton = button;
//                
//            }else // 不是第一行
//            {
//                
//            }
            
        }
//        self.didSetupConstraint = YES;
//    }
    [super updateConstraints];
}

#pragma mark - Public Methods
- (void)setItems:(NSArray *)items
{
    _items = items;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttons = [NSMutableArray arrayWithCapacity:_items.count];
    for (int i = 0; i < _items.count; i++) {
        NBMerchantPromotModel *item = _items[i];
        UIButton *promotButton = [[UIButton alloc] init];
        promotButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        promotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        promotButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [promotButton setTitleColor:HEX_COLOR(0x777777) forState:UIControlStateNormal];
        switch (item.promottype) {
            case NBPromotTypeReduce:
            {
                [promotButton setImage:[UIImage imageNamed:@"merchant_list_reduce"] forState:UIControlStateNormal];
                [promotButton setTitle:[NSString stringWithFormat:@"满%@减%@",item.enoughmoney,item.discountmoney] forState:UIControlStateNormal];
                break;
            }
            case NBPromotTypeNew:
            {
                [promotButton setImage:[UIImage imageNamed:@"merchant_list_reduce"] forState:UIControlStateNormal];
                [promotButton setTitle:[NSString stringWithFormat:@"新用户优惠"] forState:UIControlStateNormal];
                break;
            }
            default:
                [promotButton setImage:[UIImage imageNamed:@"merchant_list_reduce"] forState:UIControlStateNormal];
                [promotButton setTitle:[NSString stringWithFormat:@"新用户优惠"] forState:UIControlStateNormal];
                break;
        }
        [self addSubview:promotButton];
        [self.buttons addObject:promotButton];
    }
    [self updateConstraints];
}
@end
