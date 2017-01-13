# DVSRunProgressView

Inspired by the [works](https://dribbble.com/shots/3186995-THe-application-of-movement) of [Xerxes](https://dribbble.com/W_e_i)

可以阅读我的文章了解具体制作思路。[Read my article](http://www.jianshu.com/p/db242a4a5038)

![6](http://o6lbfzf4d.bkt.clouddn.com/2017-01-07-6.gif)



Features
==============
- Support pure color and gradient color.
- Can be used in Interface Builder.

Requirements
==============
- iOS 9.0+
- Xcode 8

Usage
==============

- By coding.

```objc
DVSRunProgressView *runProgressView;
runProgressView = [[DVSRunProgressView alloc]initWithFrame:CGRectMake(100, 180, 200, 200)];
runProgressView.type = DVSRunProgressViewTypeNormal;
runProgressView.markCount = 45;
runProgressView.duration = 1.0f;
runProgressView.markHeight = 14;
runProgressView.selectColor = [UIColor blueColor];

double delayInSeconds = 1.0;
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
   [runProgressView runAnimationWithPercent:0.8];
});
```

- By using Storyboard or XIB.
![](http://o6lbfzf4d.bkt.clouddn.com/2017-01-07-10.png)


Customize
==============

```objc
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
```

Demo
==============
There is a demo project added to this repository, so you can see how it works.

License
==============
DVSRunProgressView is provided under the MIT license. See LICENSE file for details.

