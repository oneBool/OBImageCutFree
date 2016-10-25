//
//  OBCutView.m
//  OBImageCutFree
//
//  Created by oneBool on 2016/10/24.
//  Copyright © 2016年 oneBool. All rights reserved.
//

#import "OBCutView.h"

@implementation OBCutView

{
    CGPoint points[5];
    CGPoint startingPoint;
    uint count;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.path = [UIBezierPath bezierPath];
        [self.path setLineWidth:self.linewidth];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.path = [UIBezierPath bezierPath];
        [self.path setLineWidth:self.linewidth];
    }
    NSLog(@"%f",self.linewidth);
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self.strokeColor setStroke];
    [[UIColor clearColor] setFill];
    [self.path stroke];
    [self.path fill];
}

-(UIColor *)strokeColor{
    if (_strokeColor == nil) {
        _strokeColor = [UIColor redColor];
    }
    return _strokeColor;
}

-(CGFloat)linewidth{
    if (_linewidth == 0) {
        _linewidth = 3;
    }
    return _linewidth;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.path removeAllPoints];
    count = 0;
    UITouch *touch = [touches anyObject];
    points[0] = [touch locationInView:self];
    [self.path moveToPoint:points[0]];
    startingPoint = points[0];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    count++;
    points[count] = p;
    
    if (count == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        [self.path addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        [self setNeedsDisplay];
        
        points[0] = points[3];
        points[1] = points[4];
        count = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.path addLineToPoint:startingPoint];
    [self setNeedsDisplay];
    count = 0;
    startingPoint = CGPointZero;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kOBTouchesEnd" object:nil];
}

@end
