//
//  CircleExampleController.m
//  DVSRunProgressView
//
//  Created by DevinShine on 17/1/7.
//  Copyright © 2017年 DevinShine. All rights reserved.
//

#import "CircleExampleController.h"
#define RGBA(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGB(c)    RGBA(c,1)
#define BackgroundColor RGB(0xD58989)

@interface CircleExampleController ()
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property(nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation CircleExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int width = self.circleView.bounds.size.width;
    int radius = width/2 - 20;
    CGPoint centers = CGPointMake(self.circleView.bounds.size.width / 2, self.circleView.bounds.size.height / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centers radius:radius startAngle:-M_PI endAngle:M_PI clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineCap = kCALineCapRound;
    maskLayer.lineWidth = 10;
    maskLayer.strokeEnd = 0.5;
    
    CAShapeLayer *colorLayer = [CAShapeLayer layer];
    colorLayer.frame = self.circleView.bounds;
    colorLayer.backgroundColor = BackgroundColor.CGColor;
    
    
    colorLayer.mask = maskLayer;
    
    [self.circleView.layer addSublayer:colorLayer];
    
    _maskLayer = maskLayer;
}

- (IBAction)increaseAction:(id)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.f];
    _maskLayer.strokeEnd = 1.f;
    [CATransaction commit];
}

- (IBAction)decreaseAction:(id)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.f];
    _maskLayer.strokeEnd = 0.3f;
    [CATransaction commit];
}

@end
