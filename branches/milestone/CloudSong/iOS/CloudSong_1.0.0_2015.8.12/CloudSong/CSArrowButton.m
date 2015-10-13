//
//  CSArrowButton.m
//  CloudSong
//
//  Created by youmingtaizi on 7/1/15.
//  Copyright (c) 2015 ethank. All rights reserved.
//

#import "CSArrowButton.h"

@interface CSArrowButton () {
    BOOL            _selected;
    UIImageView*    _arrowImageView;
}
@end

@implementation CSArrowButton

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_down"]];
        [self addSubview:_arrowImageView];
    }
    CGRect bounds = [[self titleForState:UIControlStateNormal] boundingRectWithSize:self.bounds.size
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:self.titleLabel.font}
                                                                            context:nil];
    CGFloat x = self.bounds.size.width - (self.bounds.size.width - bounds.size.width)/2;
    CGFloat arrowHeight = 5;
    CGFloat y = (self.bounds.size.height - arrowHeight)/2;
    _arrowImageView.frame = CGRectMake(x, y, 8, arrowHeight);
}

#pragma mark - Public Methods

- (void)selectedStateChanged {
    _selected = !_selected;
    if (_selected) {
        _arrowImageView.image = [UIImage imageNamed:@"schedule_up"];
    }
    else
        _arrowImageView.image = [UIImage imageNamed:@"schedule_down"];
}

@end
