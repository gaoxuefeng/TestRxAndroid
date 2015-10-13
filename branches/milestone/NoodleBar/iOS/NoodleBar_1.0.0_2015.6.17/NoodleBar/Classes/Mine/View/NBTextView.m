//
//  NBTextView.m
//  NoodleBar
//
//  Created by sen on 15/4/21.
//  Copyright (c) 2015年 sen. All rights reserved.
//

#import "NBTextView.h"
#import "NBCommon.h"
#define TOP_MARGIN 15
#define LEFT_MARGIN 12
#define BOTTOM_MARGIN 15
#define RIGHT_MARGIN 12
@interface NBTextView ()
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation NBTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置垂直方向弹簧效果
        self.returnKeyType = UIReturnKeyDone;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = NO;
        self.textContainerInset = UIEdgeInsetsMake(TOP_MARGIN, LEFT_MARGIN, BOTTOM_MARGIN, RIGHT_MARGIN);
        //        self.scrollEnabled = NO;
        // 添加一个显示提醒文字的label(显示占位文字的label)
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.numberOfLines = 0;
        
        // 设置文字默认颜色
        placeHolderLabel.textColor = [UIColor grayColor];
        [self addSubview:placeHolderLabel];
        self.placeHolderLabel = placeHolderLabel;
        
        // 设置文字默认字体
        self.font = [UIFont systemFontOfSize:13];
        placeHolderLabel.font = self.font;
        
        // 设置文字按钮改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

// 监听文字发生改变
- (void)TextDidChange
{
    self.placeHolderLabel.hidden = self.text.length;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = [placeHolder copy];
    
    // 设置文字
    self.placeHolderLabel.text = placeHolder;
    self.placeHolderLabel.numberOfLines = 0;
    
    // 从新计算
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self TextDidChange];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeHolderLabel.y = TOP_MARGIN;
    self.placeHolderLabel.x = LEFT_MARGIN + 5;
    self.placeHolderLabel.width = self.width - 2 * self.placeHolderLabel.x;
    
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placeHolderLabel.width, MAXFLOAT);
    self.placeHolderLabel.height = [NSString sizeWithString:self.placeHolder font:self.placeHolderLabel.font maxSize:maxSize].height;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    
    // 设置颜色
    self.placeHolderLabel.textColor = placeHolderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeHolderLabel.font = font;
    
    [self setNeedsDisplay];
}

@end
