//
//  CSPaletteView.m
//  CloudSong
//
//  Created by sen on 15/7/7.
//  Copyright (c) 2015年 ethank. All rights reserved.
//

#import "CSPaletteView.h"
#import "CSDefine.h"

@interface CSPaletteView ()
/** 线条字典数组 每个字典存放着线条颜色color、粗细width、轨迹path*/
@property(nonatomic, strong) NSMutableArray *lines;

@end


@implementation CSPaletteView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSMutableArray *)lines
{
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *line = [NSMutableDictionary dictionaryWithCapacity:3]; // 线条字典 存放着线条颜色color、粗细width、轨迹path
    NSMutableArray *path = [NSMutableArray array]; // 路径数组,记录的线条经过的point
    CGPoint point = [[touches anyObject] locationInView:self]; // 当前手指所在的点
    [path addObject:NSStringFromCGPoint(point)];
    line[@"color"] = self.lineColor;
    line[@"width"] = [NSNumber numberWithFloat:self.lineWidth];
    line[@"path"] = path;
    // 记录这条轨迹
    [self.lines addObject:line];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSMutableArray *path = self.lines.lastObject[@"path"];
    [path addObject:NSStringFromCGPoint(point)];
    [self setNeedsDisplay];
}

- (BOOL)isMultipleTouchEnabled
{
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    for (NSDictionary *line in self.lines) {
        NSArray *path = line[@"path"];
        UIColor *color = line[@"color"];
        float width = [line[@"width"] floatValue];
        [color set];
        UIBezierPath *pathLine = [UIBezierPath bezierPath];
        CGPoint startPoint = CGPointFromString(path.firstObject);
        [pathLine moveToPoint:startPoint];
        for (int i = 1; i < path.count; i++) {
            CGPoint nextPoint = CGPointFromString(path[i]);
            [pathLine addLineToPoint:nextPoint];
        }
        pathLine.lineWidth = width;

        pathLine.lineJoinStyle = kCGLineJoinRound; //拐角的处理
        pathLine.lineCapStyle = kCGLineCapRound; //最后点的处理
        [pathLine stroke];
    }
}

#pragma mark - Public Methods
/** 清空画板 */
- (void)clear
{
    if (self.lines.count > 0) {
        [self.lines removeAllObjects];
        [self setNeedsDisplay];
    }
}

/** 返回上一步 */
- (void)previous
{
    if (self.lines.count > 0) {
        [self.lines removeLastObject];
        [self setNeedsDisplay];
    }
    
}

- (UIImage *)getImageFromPalette
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
