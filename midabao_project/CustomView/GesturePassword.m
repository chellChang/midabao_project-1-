//
//  GesturePassword.m
//  GesturePassword
//
//  Created by Yuanin on 15/10/21.
//  Copyright © 2015年 Yuanin. All rights reserved.
//

#import "GesturePassword.h"

IB_DESIGNABLE @interface GestureItem: UIView

@property (strong, nonatomic, readwrite) UIColor *normalColor;
@property (strong, nonatomic, readwrite) UIColor *highlightColor;
@property (strong, nonatomic, readwrite) NSString *passwordPart;
@property (assign, nonatomic, readwrite) IBInspectable BOOL selected;

@property (assign, nonatomic) CGFloat *gradientColor;
@end

@implementation GestureItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        _gradientColor = NULL;
        _normalColor = [UIColor whiteColor];
        _highlightColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    [self setNeedsDisplay];
}

- (NSString *)description {
    
    return self.passwordPart;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    
    [self setNeedsDisplay];
}
- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    
    if (_gradientColor) {
        free(_gradientColor); _gradientColor = NULL;
    }
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 1);
    
    CGRect marginRect = CGRectMake(1, 1, rect.size.width - 2, rect.size.height - 2);
    
    if (self.selected) {
        CGContextSetStrokeColorWithColor(ctx, self.highlightColor.CGColor);

        //画出外圆
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextAddEllipseInRect(ctx, marginRect);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        CGContextRestoreGState(ctx);
        
        //画出实心圆
        CGContextSetFillColorWithColor(ctx, self.highlightColor.CGColor);
        CGFloat radius = 10; //内圆半径为外圆的1/4
        CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, radius, 0, 2*M_PI, 0);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        //画出渲染效果
//        {
//            1.0,1.0,1.0,1.0,//start color(r,g,b,alpha)
//            1.0,1.0,1.0,0.0//end color
//        };
//        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//        CGGradientRef gradient = CGGradientCreateWithColorComponents(space,[self gradientColor],NULL,2);  CGColorSpaceRelease(space),space=NULL;//release
//
//        CGPoint start = CGPointMake(rect.size.width/2, rect.size.height/2);
//        CGPoint end = start;
//        CGFloat startRadius = radius;
//        CGFloat endRadius= rect.size.width/3; //光晕半径为外圆的2/3
//        
//        CGContextDrawRadialGradient(ctx,gradient,start,startRadius,end,endRadius,0);
//        CGGradientRelease(gradient),gradient=nil;
        
    } else {
        CGContextSetStrokeColorWithColor(ctx, self.normalColor.CGColor);

        //外圆
//        CGContextAddEllipseInRect(ctx, marginRect);
//        CGContextDrawPath(ctx, kCGPathStroke);
        
        //内圆
        CGContextSetFillColorWithColor(ctx, self.normalColor.CGColor);
        CGFloat radius = 10; //内圆半径为外圆的1/4
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, rect.size.width/2, rect.size.height/2, radius, 0, 2*M_PI, 0);
//        CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, radius, 0, 2*M_PI, 0);
        CGContextAddPath(ctx, path);
        CGPathRelease(path);
//        [self.normalColor setFill];
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
}

- (CGFloat *)gradientColor {
    
    if (!_gradientColor) {
        const CGFloat *startColor = CGColorGetComponents( [self.highlightColor colorWithAlphaComponent:0.5].CGColor);
        const CGFloat *endColor = CGColorGetComponents( [self.highlightColor colorWithAlphaComponent:0.0].CGColor);
        
        CGFloat *result = malloc(8*sizeof(CGFloat));
        
        result[0] = startColor[0];
        result[1] = startColor[1];
        result[2] = startColor[2];
        result[3] = startColor[3];
        result[4] = endColor[0];
        result[5] = endColor[1];
        result[6] = endColor[2];
        result[7] = endColor[3];
        
        _gradientColor = result;
    }

    return _gradientColor;
}

- (void)dealloc {
    
    if (_gradientColor) {
        free(_gradientColor);
    }
}
@end



@interface GestureLine : UIView

@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGPoint lastPoint;

@property (strong, nonatomic) NSMutableArray<NSValue *> *lineThroughThePoint;
@end

@implementation GestureLine
@synthesize lineThroughThePoint = _lineThroughThePoint;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _lineWidth = 5;
        _lineColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}
- (void)setLineWidth:(CGFloat )lineWidth {
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}
- (void)setLineThroughThePoint:(NSMutableArray<NSValue *> *)lineThroughThePoint {
    _lineThroughThePoint = lineThroughThePoint;
    
    [self setNeedsDisplay];
}
- (void)setLastPoint:(CGPoint)lastPoint {
    _lastPoint = lastPoint;
    
    [self setNeedsDisplay];
}

- (NSMutableArray<NSValue *> *)lineThroughThePoint {
    
    if (!_lineThroughThePoint) {
        _lineThroughThePoint = [[NSMutableArray alloc] init];
    }
    return _lineThroughThePoint;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    if (self.lineThroughThePoint.count) {
        
        for (NSInteger i = 0; i < self.lineThroughThePoint.count; ++i) {
            CGPoint point = [self.lineThroughThePoint[i] CGPointValue];
            
            if ( 0 == i) {
                CGContextMoveToPoint(ctx, point.x, point.y);
            } else {
                CGContextAddLineToPoint(ctx, point.x, point.y);
            }
        }
        CGContextAddLineToPoint(ctx, self.lastPoint.x, self.lastPoint.y);
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
}

@end





#define ITEM_COUNT 9
#define LINE_COUNT (ITEM_COUNT/3)

@interface GesturePassword()

@property (copy, nonatomic, readwrite) void(^completionBlock)( NSString *, GestureCompletionType);

@property (strong, nonatomic, readwrite) NSMutableArray<GestureItem *> *items;

@property (strong, nonatomic, readwrite) NSMutableArray<GestureItem *> *selectedItems;
@property (assign, nonatomic, readwrite) CGPoint lastPoint;

@property (strong, nonatomic) GestureLine *line;
@end

@implementation GesturePassword

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initializeGesturePassword];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeGesturePassword];
}

//////IB
- (void)prepareForInterfaceBuilder {
    
    [self initializeGesturePassword];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(-self.x, -self.y, UISCREEN_WIDTH, UISCREEN_HEIGHT);
    for (GestureItem *item in self.items) {
        
        item.frame = [self calculateRectOfItemWithIndex:item.tag];
    }
}

#pragma mark -  publick method
- (void)setCompletionBlock:( void(^)(  NSString *, GestureCompletionType ) ) completionBlock {
    
    @synchronized(self) {
        _completionBlock = [completionBlock copy];
    }
}

- (void)clear {
    
    ////iOS 7.1无效的方法
    //[self.selectedItems makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    [self.selectedItems enumerateObjectsUsingBlock:^(GestureItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [self.selectedItems removeAllObjects];
    [self.line.lineThroughThePoint removeAllObjects];
    [self.line setNeedsDisplay];
}

#pragma mark - private method
- (void)initializeGesturePassword {
    
    _itemLength = 50;

    _unSelectedColor = [UIColor whiteColor];
    _selectedColor = [UIColor whiteColor];
    _lineColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.values = [self defaulrValues];
    [self addSubview:self.line];
}
- (CGRect)calculateRectOfItemWithIndex:(NSUInteger)index {
    
    CGRect square = [self squareOfAspectFit];
    NSInteger distance = [self calculateDistanceOfItem];
//    NSInteger self.itemLength = ( CGRectGetWidth(square) - distance*(LINE_COUNT + 1) )/LINE_COUNT;
    
    CGRect frame = CGRectMake( ( index%(NSInteger)LINE_COUNT)*(self.itemLength + distance) + distance + square.origin.x,
                                ( index/(NSInteger)LINE_COUNT)*(self.itemLength + distance) + distance + square.origin.y,
                                self.itemLength, self.itemLength );
    
    return frame;
}
- (CGFloat)calculateDistanceOfItem {
    
    return ([self squareOfAspectFit].size.width - self.itemLength*LINE_COUNT ) / (LINE_COUNT + 1);
}
- (CGRect)squareOfAspectFit {
    
    CGFloat minLength = ( CGRectGetWidth(self.frame) >= CGRectGetHeight(self.frame) ) ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame);
    
    return CGRectMake( (CGRectGetWidth(self.frame) - minLength)/2, (CGRectGetHeight(self.frame) - minLength)/2,
                      minLength, minLength);
}
- (NSArray<NSString *> *)defaulrValues {
    
    return @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
}


#pragma mark - touch
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    if ( 1 == touch.tapCount) {
        CGPoint point = [touch locationInView:self];
        
        [self IntersectsViewWithPoint:point];
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    if ( 1 == touch.tapCount) {
        CGPoint point = [touch locationInView:self];
        [self IntersectsViewWithPoint:point];
        self.line.lastPoint = [self convertPoint:point toView:self.line];
        [self setNeedsDisplay];
    }
    return [super continueTrackingWithTouch:touch withEvent:event];
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    [self completionTouch];
}
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event {
    
    [self completionTouch];
}
- (void)completionTouch {
    
    if (self.completionBlock && self.selectedItems.count) {
        
        self.completionBlock([self.selectedItems componentsJoinedByString:self.separatedString],
                             (self.selectedItems.count >= self.minPasswordLength) ? kGestureCompletionSuccess : kGestureCompletionNotEnough);
    }
}


- (void)IntersectsViewWithPoint:(CGPoint)point {
    
    for (GestureItem *item in self.items) {
        
        if (item.selected) continue;
        
        CGFloat viewRatio = CGRectGetWidth(item.frame)/2;
        CGFloat distance = sqrt( pow(item.center.x - point.x, 2) + pow(item.center.y - point.y, 2) );
        
        if (distance < viewRatio) {
            item.selected = YES;
            [self.selectedItems addObject:item];
            [self.line.lineThroughThePoint addObject:[NSValue valueWithCGPoint:[self convertPoint:item.center toView:self.line]]];
            break;
        }
    }
}

#pragma mark - getter & setter
- (void)setValues:(NSArray<NSString *> *)values {
    
    if (values.count < ITEM_COUNT) return;
    
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    _values = values;
    [lock unlock];
    
    for (GestureItem *item in self.items) {
        
        item.passwordPart = values[item.tag];
    }
}
- (void)setItemLength:(CGFloat)itemLength {
    _itemLength = itemLength;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    self.line.lineWidth = lineWidth;
}
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    self.line.lineColor = lineColor;
}
- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
    
    [self.items enumerateObjectsUsingBlock:^(GestureItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            obj.normalColor = unSelectedColor;
        });
    }];
}
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    
    [self.items enumerateObjectsUsingBlock:^(GestureItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            obj.highlightColor = selectedColor;
        });
    }];
}

- (GestureLine *)line {
    if (!_line) {
        _line = [[GestureLine alloc] init];
    }
    return _line;
}
- (NSMutableArray<GestureItem *> *)items {
    
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < ITEM_COUNT; ++i ) {
            GestureItem *item = [[GestureItem alloc] init];
            
            item.normalColor = self.unSelectedColor;
            item.highlightColor = self.selectedColor;
            item.tag = i;
            
            [self  addSubview:item];
            [_items addObject:item];
        }
    }
    return _items;
}
- (NSMutableArray *)selectedItems {
    
    if (!_selectedItems) {
        _selectedItems = [[NSMutableArray alloc] init];
    }
    return _selectedItems;
}
- (NSString *)separatedString {
    
    if (!_separatedString) {
        _separatedString = @"";
    }
    return _separatedString;
}
- (NSUInteger)minPasswordLength {
    
    if (!_minPasswordLength) {
        _minPasswordLength = 1;
    }
    return _minPasswordLength;
}

@end




