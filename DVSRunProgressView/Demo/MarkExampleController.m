//
//  MarkExampleController.m
//  DVSRunProgressView
//
//  Created by DevinShine on 17/1/7.
//  Copyright © 2017年 DevinShine. All rights reserved.
//

#import "MarkExampleController.h"
#define RGBA(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGB(c)    RGBA(c,1)
#define BackgroundColor RGB(0xD58989)

@interface MarkExampleController ()
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UIView *markAnimationView;
@property(nonatomic, strong) CALayer *normalLayer;

@end

@implementation MarkExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int width = self.markView.bounds.size.width;
    int radius = width/2 - 20;
    CGPoint centers = CGPointMake(self.markView.bounds.size.width / 2, self.markView.bounds.size.height / 2);
    
    // 1.
    CALayer *normalLayer = [CALayer layer];
    normalLayer.frame = self.markView.bounds;
    normalLayer.backgroundColor = BackgroundColor.CGColor;
    
    // 2.
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    int markCount = 90;
    CGFloat startRadian = - (225.0 / 180.0 * M_PI);
    CGFloat endRadian = 45.0 / 180.0 * M_PI;
    CGFloat perRadian = fabs(startRadian - endRadian) / markCount;
    for (int i = 0; i < markCount; i++) {
        CGFloat start = (startRadian + perRadian * i);
        CGFloat end   = start + perRadian / 2;
        UIBezierPath *markPath = [UIBezierPath bezierPathWithArcCenter:centers radius:radius   startAngle:start endAngle:end clockwise:YES];
        [maskPath appendPath:markPath];
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth   = 10.f;
    // 3.
    normalLayer.mask = maskLayer;
    
    [self.markView.layer addSublayer:normalLayer];
    
    [self initAnimationView];
}

- (void)initAnimationView {
    int width = self.markAnimationView.bounds.size.width;
    int radius = width/2 - 20;
    CGPoint centers = CGPointMake(self.markAnimationView.bounds.size.width / 2, self.markAnimationView.bounds.size.height / 2);
    
    // 5.
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    int markCount = 90;
    CGFloat startRadian = - (225.0 / 180.0 * M_PI);
    CGFloat endRadian = 45.0 / 180.0 * M_PI;
    CGFloat perRadian = fabs(startRadian - endRadian) / markCount;
    for (int i = 0; i < markCount; i++) {
        CGFloat start = (startRadian + perRadian * i);
        CGFloat end   = start + perRadian / 2;
        UIBezierPath *markPath = [UIBezierPath bezierPathWithArcCenter:centers radius:radius   startAngle:start endAngle:end clockwise:YES];
        [maskPath appendPath:markPath];
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth   = 10.f;
    
    // 4.
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:centers radius:radius startAngle:-M_PI endAngle:M_PI clockwise:YES];
    CAShapeLayer *selectLayer = [CAShapeLayer layer];
    selectLayer.path = circlePath.CGPath;
    selectLayer.frame = self.markAnimationView.bounds;
    selectLayer.fillColor = [UIColor clearColor].CGColor;
    selectLayer.lineWidth = 10.f;
    selectLayer.strokeColor = BackgroundColor.CGColor;
    selectLayer.strokeEnd = 1.0;
    // 6.
    selectLayer.mask = maskLayer;
    
    [self.markAnimationView.layer addSublayer:selectLayer];
}
@end
