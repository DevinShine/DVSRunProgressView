//
//  DVSRunProgressView.h
//  DVSRunProgressView
//
//  Created by DevinShine on 17/1/7.
//  Copyright © 2017年 DevinShine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Progress type
typedef NS_OPTIONS(NSUInteger, DVSRunProgressViewType){
    DVSRunProgressViewTypeNormal = 0,
    DVSRunProgressViewTypeGradient,
};

/** The block invoked in animation completion */
typedef void(^DVSRunProgressViewCompletionBlock)(void);

IB_DESIGNABLE

@interface DVSRunProgressView : UIView

/** The basic duration of the object. Defaults to 1. */
@property(nonatomic, assign) IBInspectable CFTimeInterval duration;

/** The start angle. (e.g. 225) */
@property(nonatomic, assign) IBInspectable CGFloat startAngle;

/** The end angle. (e.g. 45) */
@property(nonatomic, assign) IBInspectable CGFloat endAngle;

/** The radius offset. */
@property(nonatomic, assign) IBInspectable CGFloat circleRadiusOffset;

/** The maximum number of objects the mark should hold. */
@property(nonatomic, assign) IBInspectable NSUInteger markCount;

/** The mark height */
@property(nonatomic, assign) IBInspectable CGFloat markHeight;

/** The normal color */
@property(nonatomic, strong) IBInspectable UIColor *normalColor;

/** The select color */
@property(nonatomic, strong) IBInspectable UIColor *selectColor;

/** The progress type  */
@property(nonatomic, assign) DVSRunProgressViewType type;

/** The color array in gradient mode, which is equivalent to the colors of CAGradientLayer */
@property(nonatomic, nullable, copy) NSArray *gradientColors;

/** The array of positions in the gradient mode, which is equivalent to the locations of the CAGradientLayer  */
@property(nonatomic, nullable, copy) NSArray<NSNumber *> *gradientLocations;

/** The startPoint in gradient mode, which is equivalent to the startPoint of CAGradientLayer  */
@property(nonatomic, assign) IBInspectable CGPoint gradientStartPoint;

/** The endPoint in gradient mode, which is equivalent to the endPoint of CAGradientLayer  */
@property(nonatomic, assign) IBInspectable CGPoint gradientEndPoint;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

#pragma mark - Access Methods

///=============================================================================
/// @name Access Methods
///=============================================================================

/**
 Runs the animation based on a given percentage value
 @param percent The interval is [0,1].
 */
- (void)runAnimationWithPercent:(CGFloat)percent;

/**
 Runs the animation based on a given percentage value
 @param percent   The interval is [0,1].
 @param block     A completion block when animation completion.
 */
- (void)runAnimationWithPercent:(CGFloat)percent
                completionBlock:(nullable DVSRunProgressViewCompletionBlock)block;

/**
 Set the start color and end color, the type will be change Gradient.
 The locations will become [0,1]. The start and end points will become [0.5,0] and [0.5,1].
 @param startColor   The start color
 @param endColor     The end color
 */
- (void)setEasyGradientColor:(UIColor *)startColor
                    endColor:(UIColor *)endColor;
@end

NS_ASSUME_NONNULL_END
