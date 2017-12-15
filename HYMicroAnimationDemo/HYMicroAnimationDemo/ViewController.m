//
//  ViewController.m
//  HYTinyAnimation
//
//  Created by 程宏愿 on 2017/10/24.
//  Copyright © 2017年 chy. All rights reserved.
//

#import "ViewController.h"
#import "HYSunSwitch.h"
@interface ViewController ()<HYSunSwitchDelegate>
@property (nonatomic, weak) HYSunSwitch * sunwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //黑色背景更清楚
    UIView *sunSuperView = [[UIView alloc]initWithFrame:CGRectMake(70, 200, 220, 120)];
    sunSuperView.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"黑色背景效果更好";
    [sunSuperView addSubview:label];
    HYSunSwitch * sunSwitch = [[HYSunSwitch alloc] initWithFrame:CGRectMake(30 ,30, 120, 60)];
    sunSwitch.delegate = self;
    _sunwitch = sunSwitch;
    [sunSuperView addSubview:sunSwitch];
    [self.view addSubview:sunSuperView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark ---HYSunSwitchDelegate
-(void)sunSwitchDidTap:(HYSunSwitch *)sunSwitch{
    NSLog(@"sunSwitch 点击了");
}
-(void)sunSwitchAnimationDidStop:(HYSunSwitch *)sunSwitch{
    NSLog(@"sunSwitch 动画结束");
}
-(void)sunSwitch:(HYSunSwitch *)sunSwitch valueDidChanged:(BOOL)on{
    NSLog(@"sunSwitch 的值%d",on);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
