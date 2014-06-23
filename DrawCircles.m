//
//  DrawCircles.m
//  Chess
//
//  Created by Liu Di on 6/21/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "DrawCircles.h"
#define MINRADIUS 10

#define MAXRADIUS 30
@implementation DrawCircles
@synthesize drawColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        totalCircles = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor clearColor];
    }
    drawColor = 0;
    return self;
}
- (void)drawRect:(CGRect)rect {
    [self drawCircle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawCircle
{
    NSLog(@"draw color is %d",drawColor);
    // Get the Graphics Context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the circle outerline-width
    CGContextSetLineWidth(context, 10.0);
    //    // Set the circle outerline-colour
    if (drawColor == 1) {
        [[UIColor redColor] set];
    }
    else {
        [[UIColor greenColor] set];
    }

    
    // Loop through the circles and Draw these Circles to the view
    for (IOSCircle *circle in totalCircles)
    {
        // Create Circle
        CGContextAddArc(context, circle.circleCenter.x, circle.circleCenter.y, circle.circleRadius, 0.0, M_PI * 2.0, YES);
        
        // Draw
        CGContextStrokePath(context); 
    }
}
- (void)drawOnSpot:(CGPoint) pt withSide:(int)side{
    NSLog(@"in draw on spot on %.2f %.2f, side is %d", pt.x, pt.y, side);
//{
//    // loop through the touches
//    for (UITouch *touch in touches)
//    { // Get location of Touch
//        CGPoint location = [touch locationInView:self];
//
//    // Set the circle outerline-colour
    if (side == 1) {
        
        drawColor = 1;
    }
    else {
        drawColor = 2;
    }
//        // Create a new iOSCircle Object
        IOSCircle *newCircle = [[IOSCircle alloc] init];
//        
//        // Set the Center of the Circle
        newCircle.circleCenter = pt;
//        
//        // Set a random Circle Radius
        newCircle.circleRadius = 10;
//        
//        // Add the Circle Object to the Array
        [totalCircles addObject:newCircle];
//        
//        // update the view 
        [self setNeedsDisplay];
//    }
}
@end
