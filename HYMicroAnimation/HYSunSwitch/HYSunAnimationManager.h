//
//  HYSunAnimationManager.h
//  HYTinyAnimation
//
//  Created by 程宏愿 on 2017/11/16.
//  Copyright © 2017年 chy. All rights reserved.
//HYSunAnimationKey


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYSunAnimationKey) { //枚举和.m数组要对应
    HYSunAnimationStrokeRectKey,//默认从0开始
    HYSunAnimationSunMoveKey,
    HYSunAnimationSunChangeColorKey,
    HYSunAnimationSunChangeShapeKey,
    HYSunAnimationCricleSmallSizeKey,
    HYSunAnimationCricleBigSizeKey,
    HYSunAnimationCricleBackSizeKey,
};

@interface HYSunAnimationManager : NSObject
/**
 *  根据HYSunAnimationKey 获取动画
 */
-(CAAnimation *)getAnimationWithKey:(HYSunAnimationKey)HYSunAnimationKey object:(id)object;
/**
 *  根据动画时间初始化
 */
-(instancetype)initWithAnimationDuration:(CGFloat)duration;
/**
 *  添加动画
 */
-(void)animationObject:(id)object addAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue delegate:(id)delegate animationKey:(HYSunAnimationKey)animationKey;
@end
