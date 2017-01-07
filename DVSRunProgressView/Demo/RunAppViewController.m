//
//  RunAppViewController.m
//  DVSRunProgressView
//
//  Created by DevinShine on 17/1/7.
//  Copyright © 2017年 DevinShine. All rights reserved.
//

#import "RunAppViewController.h"
#import "DVSRunProgressView.h"
#import "UILabel+FlickerNumber.h"


#define RGBA(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGB(c)    RGBA(c,1)

@interface RunAppViewController ()
@property (weak, nonatomic) IBOutlet DVSRunProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation RunAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.type = DVSRunProgressViewTypeGradient;
    self.progressView.markCount = 45;
    self.progressView.duration = 1.0f;
    self.progressView.markHeight = 14;
    self.progressView.normalColor = RGB(0xE3E4E6);
    [self.progressView setEasyGradientColor:RGB(0x88BADE) endColor:RGB(0x80D0A9)];
}

- (IBAction)runAction:(id)sender {
    [_distanceLabel fn_setNumber:@12.99 duration:1.0f];
    [_progressView runAnimationWithPercent:0.8 completionBlock:^{
        // To do something
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
