//
//  DVSRunProgressView.m
//  DVSRunProgressView
//
//  Created by DevinShine on 17/1/7.
//  Copyright © 2017年 DevinShine. All rights reserved.
//

#import "DVSRunProgressView.h"

#define kMarkCountDefault 100
#define RGBA(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGB(c)    RGBA(c,1)

static inline CGFloat angle2Radian(CGFloat angle) {
    return  M_PI * angle / 180.0;
}

@interface DVSRunProgressView () <CAAnimationDelegate>
@property(nonatomic, strong) CALayer *normalLayer;
@property(nonatomic, strong) CALayer *selectLayer;
@property(nonatomic, strong) CAShapeLayer *gradientMaskLayer;
@property(nonatomic, strong) NSMutableArray *markPathArray;
@property(nonatomic, assign) CGFloat currentPercent;
@property(nullable, nonatomic, copy) DVSRunProgressViewCompletionBlock completionBlock;
@end

@implementation DVSRunProgressView
#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultData];
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaultData];
        [self configureUI];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"DVSCircleProgressView init error" reason:@"Use 'initWithFrame:' instead." userInfo:nil];
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Setter

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    [self reset];
    [self configureUI];
}

- (void)setEndAngle:(CGFloat)endAngle {
    _endAngle = endAngle;
    [self reset];
    [self configureUI];
}

- (void)setMarkCount:(NSUInteger)markCount {
    _markCount = markCount;
    [self reset];
    [self configureUI];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self reset];
    [self configureUI];
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    [self reset];
    [self configureUI];
}

- (void)setMarkHeight:(CGFloat)markHeight {
    _markHeight = markHeight;
    [self reset];
    [self configureUI];
}

- (void)setCircleRadiusOffset:(CGFloat)circleRadiusOffset {
    _circleRadiusOffset = circleRadiusOffset;
    [self reset];
    [self configureUI];
}

- (void)setGradientColors:(NSArray *)gradientColors {
    _gradientColors = [gradientColors copy];
    [self reset];
    [self configureUI];
}

- (void)setGradientLocations:(NSArray<NSNumber *> *)gradientLocations {
    _gradientLocations = gradientLocations;
    [self reset];
    [self configureUI];
}

- (void)setGradientStartPoint:(CGPoint)gradientStartPoint {
    _gradientStartPoint = gradientStartPoint;
    [self reset];
    [self configureUI];
}

- (void)setGradientEndPoint:(CGPoint)gradientEndPoint {
    _gradientEndPoint = gradientEndPoint;
    [self reset];
    [self configureUI];
}

- (void)setEasyGradientColor:(UIColor *)startColor
                    endColor:(UIColor *)endColor {
    _gradientColors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    _gradientLocations = @[@0.0,@1.0];
    _gradientStartPoint = CGPointMake(0.5, 0);
    _gradientEndPoint = CGPointMake(0.5, 1);
    _type = DVSRunProgressViewTypeGradient;
    [self reset];
    [self configureUI];
}

#pragma mark - Private

- (void)initDefaultData {
    _currentPercent = 0.f;
    _duration = 1.f;
    _type = DVSRunProgressViewTypeNormal;
    _startAngle = -225.0;
    _endAngle = 45.0;
    _markCount = kMarkCountDefault;
    _normalColor = RGB(0xE0E2E4);
    _selectColor = RGB(0x7DCFA7);
    _markHeight = 20.f;
    _circleRadiusOffset = -20.f;
    
    _gradientColors = @[(__bridge id)RGB(0xFF9B55).CGColor,(__bridge id)RGB(0x08BB08).CGColor,(__bridge id)RGB(0xB92501).CGColor];
    _gradientLocations = @[@0.0, @0.4, @1.0];
    _gradientStartPoint = CGPointMake(0.5, 0);
    _gradientEndPoint = CGPointMake(0.5, 1);
}

- (void)configureUI{
    CGFloat perRadian = fabs(angle2Radian(_startAngle - _endAngle)) / _markCount;
    
    CGFloat width = self.frame.size.width;
    CGPoint centers = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    _markPathArray = @[].mutableCopy;
    for (int i = 0; i < _markCount; i++) {
        CGFloat start = (angle2Radian(_startAngle) + perRadian * i);
        // 除以2的话则是每个刻度之间相隔的刻度正好为一个刻度单位，如果除以 3 则相隔 2 个刻度单位，简单的说这个值越大，刻度的宽度越细
        CGFloat end   = start + perRadian / 3;
        UIBezierPath *markPath = [UIBezierPath bezierPathWithArcCenter:centers radius:width/2 + _circleRadiusOffset   startAngle:start endAngle:end clockwise:YES];
        [maskPath appendPath:markPath];
        // 将每个 path 添加到 array 当中，逐帧动画的时候使用，只有渐变动画才会需要用到逐帧动画这个方式
        [_markPathArray addObject:(__bridge id)((UIBezierPath *)[maskPath copy]).CGPath];
    }
    
    _normalLayer = [CALayer layer];
    _normalLayer.frame = self.bounds;
    _normalLayer.backgroundColor = _normalColor.CGColor;
    _normalLayer.mask = [self generateMaskLayerWithPath:maskPath];
    
    if (_type == DVSRunProgressViewTypeNormal) {
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:centers radius:width/2 - _circleRadiusOffset   startAngle:angle2Radian(_startAngle) endAngle:angle2Radian(_endAngle) clockwise:YES];
        CAShapeLayer *selectLayer = [CAShapeLayer layer];
        selectLayer.path = circlePath.CGPath;
        selectLayer.frame = self.bounds;
        selectLayer.fillColor = [UIColor clearColor].CGColor;
        selectLayer.lineWidth = _markHeight;
        selectLayer.strokeColor = _selectColor.CGColor;
        selectLayer.strokeEnd = 0.0;
        selectLayer.mask = [self generateMaskLayerWithPath:maskPath];
        _selectLayer = selectLayer;
    }else if(_type == DVSRunProgressViewTypeGradient){
        _gradientMaskLayer = [self generateMaskLayerWithPath:[UIBezierPath bezierPath]];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = _gradientColors;
        gradientLayer.locations = _gradientLocations;
        gradientLayer.startPoint = _gradientStartPoint;
        gradientLayer.endPoint = _gradientEndPoint;
        gradientLayer.mask = _gradientMaskLayer;
        _selectLayer = gradientLayer;
    }else {
        @throw [NSException exceptionWithName:@"_type error" reason:@"Use DVSRunProgressViewTypeGradient or DVSRunProgressViewTypeNormal instead." userInfo:nil];
    }
    
    [self.layer addSublayer:_normalLayer];
    [self.layer addSublayer:_selectLayer];
}

- (CAShapeLayer *)generateMaskLayerWithPath:(UIBezierPath *)path {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth   = _markHeight;
    return maskLayer;
}

- (NSArray *)generateMarkArrayToPercent:(CGFloat)percent {
    if (!_markPathArray || _markPathArray.count == 0) {
        return nil;
    }
    NSMutableArray *result = @[].mutableCopy;
    NSUInteger targetCount = _markPathArray.count * percent;
    for (int i = 0; i < targetCount; i++) {
        [result addObject:_markPathArray[i]];
    }
    return result;
}

- (void)reset {
    if (_normalLayer) {
        [_normalLayer removeFromSuperlayer];
        _normalLayer = nil;
    }
    
    if (_selectLayer) {
        [_selectLayer removeFromSuperlayer];
        _selectLayer = nil;
    }
    
    if (_markPathArray) {
        _markPathArray = nil;
    }
}

#pragma mark - Public

- (void)runAnimationWithPercent:(CGFloat)percent {
    [self runAnimationWithPercent:percent completionBlock:nil];
}

- (void)runAnimationWithPercent:(CGFloat)percent
                completionBlock:(DVSRunProgressViewCompletionBlock)block {
    // Check Valid
    if (percent < 0) {
        percent = 0;
    }else if(percent > 1) {
        percent = 1;
    }
    
    if (_type == DVSRunProgressViewTypeNormal) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:block];
        [CATransaction setAnimationDuration:_duration];
        ((CAShapeLayer *)_selectLayer).strokeEnd = percent;
        [CATransaction commit];
        
        _currentPercent = percent;
    }else if(_type == DVSRunProgressViewTypeGradient){
        _completionBlock = block;
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.delegate = self;
        anim.duration = _duration;
        anim.keyPath = @"path";
        anim.values = [self generateMarkArrayToPercent:percent];
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_gradientMaskLayer addAnimation:anim forKey:nil];
        
        _currentPercent = percent;
    }
}

#pragma mark - CAAnimationDelegate


- (void)animationDidStart:(CAAnimation *)anim {
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_completionBlock) {
        _completionBlock();
    }
}

@end
