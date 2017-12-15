//
//  HYSunSwith.m
//  HYTinyAnimation
//
//  Created by 程宏愿 on 2017/11/14.
//  Copyright © 2017年 chy. All rights reserved.
//

#import "HYSunSwitch.h"
#import "HYSunAnimationManager.h"
#import "HYSSSunLayer.h"
@interface HYSunSwitch()<CAAnimationDelegate>

/**
 *   switch backgroundView
 */
@property (nonatomic, weak) UIView *backgroundView;
/**
 *  backgroudView上的 一层shapeLayer
 */
@property (nonatomic, weak) CAShapeLayer *backgroundLayer;
/**
 *
 */
@property (nonatomic, weak) CAShapeLayer *fillLayer;

/**
 *  太阳
 */
@property (nonatomic, weak) CAShapeLayer *cricleLayer;
/**
 *  太阳上的阴影
 */
@property (nonatomic ,weak) HYSSSunLayer *sunLayer;
@property (nonatomic, strong) HYSunAnimationManager *animationManager;

/**
 *  太阳颜色
 */
@property (nonatomic, strong)  UIColor *onSunColor;
/**
 *  月亮颜色
 */
@property (nonatomic, strong) UIColor *offSunColor;

/**
 *  动画正在执行
 */
@property (nonatomic, assign) BOOL isAnimating;
/**
 *  圆的原始位置
 */
@property (nonatomic, assign) CGPoint criclePosition;
/**
 *  圆的最初大小
 */
@property (nonatomic,assign) CGRect cricleBounds;
/**
 *  边框高度
 */
@property (nonatomic, assign) CGFloat  space;


@end
@implementation HYSunSwitch
#pragma mark --init
/**
 * 代码创建
 */
-(instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
/**
 *  xib加载
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}
//禁用 背景颜色
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    return;
}
-(void)setAnimationDuration:(CGFloat)animationDuration{
    _animationDuration = animationDuration;
    _animationManager = [[HYSunAnimationManager alloc] initWithAnimationDuration:animationDuration];
}
-(void)setOn:(BOOL)on{
    if (on !=_on) {
        _on = on;
        if (on) {
            _backgroundLayer.frame = _backgroundView.bounds;
            _backgroundLayer.path = [UIBezierPath bezierPathWithRoundedRect: _backgroundLayer.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii: _backgroundLayer.frame.size].CGPath;
            _cricleLayer.position = CGPointMake(_fillLayer.bounds.size.width - _criclePosition.x +_space*2, _criclePosition.y);
            CGFloat w = _cricleBounds.size.width;
            _sunLayer.centerX = w +w*1.3f;
            _cricleLayer.fillColor = _onSunColor.CGColor;
            [self.sunLayer setNeedsDisplay];
        }else{
            _backgroundLayer.frame = CGRectMake(0, 0, 0, 0);
            _cricleLayer.position = CGPointMake(_criclePosition.x, _criclePosition.y);
            CGFloat w = _cricleBounds.size.width;
            _sunLayer.centerX = w;
            [self.sunLayer setNeedsDisplay];
        }
    }
}
-(void)setOn:(BOOL)on animated:(BOOL)animated{
    if (on !=_on) {
        if (animated) {
            [self tapSwitch];
        }else{
            [self setOn:on];
        }
    }
    
}
/**
 *  懒加载
 */
-(UIView *)backgroundView{
    if (!_backgroundView) {
        UIView *backgroundView = ({
            UIView *view=[UIView new];
            view.frame = self.bounds;
            view.layer.cornerRadius = self.frame.size.height/2;
            view.layer.masksToBounds = YES;
            view.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:68.0/255.0 blue:78.0/255.0 alpha:1.0];
            [self addSubview:view];
            view;
        });
        
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

-(void)setupView{

    CAShapeLayer *strokeLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(0, 0, 0, 0);
        layer.fillColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:30.0/255.0 alpha:1.0].CGColor;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:layer.frame.size].CGPath;
        
        [self.backgroundView.layer addSublayer:layer];
        layer;
    });
    
    CGFloat space = self.backgroundView.frame.size.height/20.0f;//边框宽度百分比变化
    CGRect rect = CGRectMake(space, space, self.backgroundView.frame.size.width-2*space, self.backgroundView.frame.size.height-2*space);
    
    CAShapeLayer *fillLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.bounds = rect;
        layer.position = self.backgroundView.center;
        layer.fillColor = [UIColor colorWithRed:26/255.0 green:31/255.0 blue:36/255.0 alpha:1.0].CGColor;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:rect.size].CGPath;
        [self.backgroundView.layer addSublayer:layer];
        layer;
    });
    //sun
    CGRect cricleBounds = CGRectMake(0, 0, (rect.size.height-2*3*space), (rect.size.height-2*3*space));
    CAShapeLayer * cricleLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.bounds = cricleBounds;
        layer.position = CGPointMake(rect.size.height/2+space,rect.size.height/2+space);
        layer.fillColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor;
        layer.path = [UIBezierPath bezierPathWithOvalInRect:cricleBounds].CGPath;
        [fillLayer addSublayer:layer];
        layer;
    });
    //这里加了0.5是为了 sunlayer 不能完全覆盖cricleLayer 会有个小边
    CGRect sunRect = CGRectMake(0, 0, cricleBounds.size.width+0.5, cricleBounds.size.height+0.5);
    HYSSSunLayer *sunLayer = ({
        HYSSSunLayer *layer = [HYSSSunLayer layer];
//        layer.backgroundColor = [UIColor colorWithRed:26/255.0 green:31/255.0 blue:36/255.0 alpha:1.0].CGColor;
        layer.frame = sunRect;
        layer.cornerRadius = sunRect.size.height/2;
        layer.masksToBounds = YES;
        layer.centerX = sunRect.size.width;
        [cricleLayer addSublayer:layer];
        layer;
    });
    [sunLayer setNeedsDisplay];
    
    //property init
    _space = space;
    _criclePosition = cricleLayer.position;
    _cricleBounds = cricleBounds;
    _sunLayer = sunLayer;
    _cricleLayer = cricleLayer;
    _fillLayer = fillLayer;
    _backgroundLayer = strokeLayer;
    _animationDuration = 0.25f;
    _animationManager = [[HYSunAnimationManager alloc] initWithAnimationDuration:_animationDuration];
    _on = NO;
    _onSunColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:30.0/255.0 alpha:1.0];
    _offSunColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSwitch)]];
    
}

//点击事件
-(void)tapSwitch{
    
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    //边框
    [_animationManager animationObject:_backgroundLayer addAnimationFromValue:[NSValue valueWithCGRect:(_on ? _backgroundView.bounds :CGRectMake(0, 0, 0, 0))] toValue:[NSValue valueWithCGRect:(_on? CGRectMake(0, 0, 0, 0) : _backgroundView.bounds)] delegate:self animationKey:HYSunAnimationStrokeRectKey];
   
    //太阳移动 莫名其妙的space
    [_animationManager animationObject:_cricleLayer addAnimationFromValue:@(_on ? _fillLayer.bounds.size.width - _criclePosition.x +_space*2: _criclePosition.x) toValue:@(_on ? _criclePosition.x : _fillLayer.bounds.size.width - _criclePosition.x + _space*2) delegate:self animationKey:HYSunAnimationSunMoveKey];
    
    //太阳改变颜色
    [_animationManager animationObject:_cricleLayer addAnimationFromValue:(id)(_on ? _onSunColor : _offSunColor).CGColor toValue:(id)(_on ? _offSunColor : _onSunColor).CGColor delegate:self animationKey:HYSunAnimationSunChangeColorKey];
    //太阳 <->月亮
    CGFloat w = _cricleBounds.size.width + 0.5;
    [_animationManager animationObject:_sunLayer addAnimationFromValue:@(_on ? w +w/2.0f*1.3f: w) toValue:@(_on ? w : w + w/2.0f*1.3f) delegate:self animationKey:HYSunAnimationSunChangeShapeKey];
    
    //到中间变小
    [_animationManager animationObject:_cricleLayer addAnimationFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 0)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0)]  delegate:self animationKey:HYSunAnimationCricleSmallSizeKey];
    
    //代理方法
    if ([self.delegate respondsToSelector:@selector(sunSwitchDidTap:)]) {
        [self.delegate sunSwitchDidTap:self];
    }
}

#pragma mark -- CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (flag) {
        
         CGFloat  w = _cricleBounds.size.width+0.5;
        //不能直接用HYSunAnimationSunChangeShapeKey获取anim
        if (anim == [_animationManager getAnimationWithKey:HYSunAnimationSunChangeShapeKey object:_sunLayer]) {
            //形状变化动画结束 固定
         
            _sunLayer.centerX =_on ? w : w + w/2*1.3f;
            [_sunLayer setNeedsDisplay];
            
        }else if(anim == [_animationManager getAnimationWithKey:HYSunAnimationCricleSmallSizeKey object:_cricleLayer]){
            //缩小之后变大
            [_animationManager animationObject:_cricleLayer addAnimationFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 0)] delegate:self animationKey:HYSunAnimationCricleBigSizeKey];
        }else if(anim == [_animationManager getAnimationWithKey:HYSunAnimationCricleBigSizeKey object:_cricleLayer]){
            //从变大 到回复原状
            [_animationManager animationObject:_cricleLayer addAnimationFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 0)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1 ,1, 0)] delegate:self animationKey:HYSunAnimationCricleBackSizeKey];
            _isAnimating = NO;
            _on = !_on;
            [_sunLayer removeAllAnimations];
            if ([self.delegate respondsToSelector:@selector(sunSwitchAnimationDidStop:)]){
                [self.delegate sunSwitchAnimationDidStop:self];
            }
            
            if ([self.delegate respondsToSelector:@selector(sunSwitch: valueDidChanged:)]) {
                [self.delegate sunSwitch:self valueDidChanged:_on];
            }
        }
    }
}
-(void)dealloc{
    _delegate = nil;
}
@end
