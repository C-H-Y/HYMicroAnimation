//
//  HYSunSwith.h
//  HYTinyAnimation
//
//  Created by 程宏愿 on 2017/11/14.
//  Copyright © 2017年 chy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HYSunSwitchDelegate;
IB_DESIGNABLE
@interface HYSunSwitch : UIView
/**
 *  开关状态 默认NO  default NO
 */
@property (nonatomic, assign)IBInspectable BOOL on;
/**
 *  动画时间参数   animation duration  default 0.25s
 */
@property (nonatomic, assign)IBInspectable  CGFloat animationDuration;

@property (nonatomic, weak) IBOutlet id<HYSunSwitchDelegate> delegate;
-(void)setOn:(BOOL)on animated:(BOOL)animated;
@end
@protocol HYSunSwitchDelegate <NSObject>
-(void)sunSwitchDidTap:(HYSunSwitch *)sunSwitch;

-(void)sunSwitchAnimationDidStop:(HYSunSwitch *)sunSwitch;

-(void)sunSwitch:(HYSunSwitch *)sunSwitch valueDidChanged:(BOOL)on;

@end
