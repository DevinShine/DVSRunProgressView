//
//  RunProgressExampleController.m
//  DVSRunProgressView
//
//  Created by DevinShine on 17/1/7.
//  Copyright © 2017年 DevinShine. All rights reserved.
//

#import "RunProgressExampleController.h"
#import "DVSRunProgressView.h"

@interface RunProgressExampleController ()
@property(nonatomic, strong) DVSRunProgressView *runProgressView;
@end

@implementation RunProgressExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _runProgressView = [[DVSRunProgressView alloc]initWithFrame:CGRectMake(100, 180, 200, 200)];
    _runProgressView.type = DVSRunProgressViewTypeNormal;
    _runProgressView.markCount = 45;
    _runProgressView.duration = 1.0f;
    _runProgressView.markHeight = 14;
    _runProgressView.selectColor = [UIColor blueColor];
    
    [self.view addSubview:_runProgressView];

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_runProgressView runAnimationWithPercent:0.8];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
