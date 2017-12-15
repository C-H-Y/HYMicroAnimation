//
//  HYSSSunLayer.m
//  HYTinyAnimation
//
//  Created by 程宏愿 on 2017/11/21.
//  Copyright © 2017年 chy. All rights reserved.
//

#import "HYSSSunLayer.h"

@implementation HYSSSunLayer
-(instancetype)init{
    if (self = [super init]) {
       
    }
    return self;
}
-(instancetype)initWithLayer:(HYSSSunLayer *)layer{
    if (self = [super initWithLayer:layer]) {
        self.centerX = layer.centerX;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{

    CGFloat w = self.frame.size.width;
   //半径是 sunlayer的1.3倍 记住这个值
    CGContextAddArc(ctx, _centerX, w/2.0f,w/2*1.3f, 0, 2*M_PI, 0);
    CGContextSetRGBFillColor(ctx, 26/255.0, 31/255.0, 36/255.0, 1);
    CGContextFillPath(ctx);
}

+(BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"centerX"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}
@end
