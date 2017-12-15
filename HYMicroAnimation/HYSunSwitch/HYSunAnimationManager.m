//
//  HYSunAnimationManager.m
//  HYTinyAnimation
//
//  Created by 程宏愿 on 2017/11/16.
//  Copyright © 2017年 chy. All rights reserved.
//

#import "HYSunAnimationManager.h"

@interface HYSunAnimationManager()
/**
 *  时间间隔
 */
@property (nonatomic, assign) CGFloat  animationDuration;
@property (nonatomic, strong) NSArray *animationKeys;
@end

@implementation HYSunAnimationManager
/**
 *  init
 */
-(instancetype)initWithAnimationDuration:(CGFloat)duration{
    if (self = [super init]) {
        _animationDuration = duration;
    }
    return self;
}

-(NSArray *)animationKeys{
    if (_animationKeys == nil) {
        _animationKeys = @[@"HYSunAnimationStrokeRectKey",     //边框动画
                           @"HYSunAnimationSunMoveKey",        //圆移动动画
                           @"HYSunAnimationSunChangeColorKey", //滑动一半 颜色完全变黄  太阳月亮的颜色渐变
                           @"HYSunAnimationSunChangeShapeKey", //滑动一半 月亮<->太阳
                           @"HYSunAnimationCricleSmallSizeKey",//缩小
                           @"HYSunAnimationCricleBigSizeKey",//放大
                           @"HYSunAnimationCricleBackSizeKey", // 回到原来
                           ];
    }
    return _animationKeys;
}

-(CAAnimation *)getAnimationWithKey:(HYSunAnimationKey)HYSunAnimationKey object:(id)object{
    if (self.animationKeys[HYSunAnimationKey]) {
     CAAnimation *animation  =  [object animationForKey:self.animationKeys[HYSunAnimationKey]];
         return animation;
    }
    else{
        NSLog(@"%s 没有找到匹配HYSunAnimationKey",__func__);
        return nil;
    }
}

/**
 *  边框动画 这个动画有点投机取巧了 
 */
-(CAKeyframeAnimation *)addStrokeRectAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue{
    CGRect fromRValue = [fromValue CGRectValue];
    CGRect toRValue = [toValue CGRectValue];
    
    NSMutableArray * pathArr = [NSMutableArray array];
    if (fromRValue.size.width != 0) {//关
        
        CGFloat x = fromRValue.origin.x;
        CGFloat y = fromRValue.origin.y;
        CGFloat width = fromRValue.size.width;
        CGFloat height = fromRValue.size.height;
        int count = width/(height/20.0f);  //（height/20）边框的宽度
        CGFloat afterWidth = width;
        for (int i = 0; i<count; i++) {
           afterWidth = afterWidth - width/count;
            CGRect rect = CGRectMake(x, y, afterWidth, height);
            CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:rect.size].CGPath;
            [pathArr addObject:(__bridge id _Nonnull)(path)];
        }
    }
    else{//开
        CGFloat x = toRValue.origin.x;
        CGFloat y = toRValue.origin.y;
        CGFloat width = toRValue.size.width;
        CGFloat height = toRValue.size.height;
         int count = width/(height/20.0f);
        CGFloat afterWidth = 0.0;
        for (int i = 0; i<count; i++) {
            afterWidth = afterWidth + width/count;
            CGRect rect = CGRectMake(x, y, afterWidth, height);
            CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:rect.size].CGPath;
            [pathArr addObject:(__bridge id _Nonnull)(path)];

        }
        
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    animation.values = pathArr;
    animation.duration = _animationDuration *1.5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
   
    return animation;
}

/**
 *  圆圈移动动画
 */
-(id)sunAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue animationKey:(HYSunAnimationKey)animationKey{
    
    NSString *path;
    CFTimeInterval duration = 0.0;
    switch (animationKey) {
        case HYSunAnimationStrokeRectKey:{
            return [self addStrokeRectAnimationFromValue:fromValue toValue:toValue];
        }
            break;
            
        case HYSunAnimationSunMoveKey:{
            duration = _animationDuration * 2;
            path = @"position.x";
        }
            break;
        case HYSunAnimationSunChangeColorKey:{
            duration = _animationDuration;
            path = @"fillColor";
        }
            break;
        case HYSunAnimationSunChangeShapeKey:{
            duration = _animationDuration;
            path = @"centerX";
        }
            break;
        case HYSunAnimationCricleSmallSizeKey:{
            duration = _animationDuration;
            path = @"transform";
        }
            break;
        case HYSunAnimationCricleBigSizeKey:{
            duration = _animationDuration;
            path = @"transform";
        }
            break;
        case HYSunAnimationCricleBackSizeKey:{
            duration = _animationDuration;
            path = @"transform";
        }
            break;
        
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:path];
    animation.fromValue = fromValue;
    animation.duration = duration;
    animation.toValue = toValue;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
/**
 *  给shapelayer加上 动画
 */
-(void)animationObject:(id)object addAnimationFromValue:(NSValue *)fromValue toValue:(NSValue *)toValue delegate:(id)delegate animationKey:(HYSunAnimationKey)animationKey {
    if (animationKey == HYSunAnimationStrokeRectKey) {
        CAKeyframeAnimation * animation = [self addStrokeRectAnimationFromValue:fromValue toValue:toValue];
        animation.delegate = delegate;
        [object addAnimation:animation forKey:self.animationKeys[animationKey]];
    }
    else{
        CABasicAnimation * animation = [self sunAnimationFromValue :fromValue toValue:toValue animationKey:animationKey];
        animation.delegate = delegate;
        [object addAnimation:animation forKey:self.animationKeys[animationKey]];
    }
   
}

@end
