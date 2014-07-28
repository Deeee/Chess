//
//  DrawValues.m
//  Chess
//
//  Created by Liu Di on 7/14/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "DrawValues.h"

@implementation DrawValues

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawOnSpot:(CGPoint) pt withValues:(double)value{
    NSLog(@"in draw on spot on %.2f %.2f, side is %.2f", pt.x, pt.y, value);
    //{
    //    // loop through the touches
    //    for (UITouch *touch in touches)
    //    { // Get location of Touch
    //        CGPoint location = [touch locationInView:self];
    //
    //    // Set the circle outerline-colour
    NSString *str = [NSString stringWithFormat:@"%.2f",value];
    [str drawInRect:CGRectMake(pt.x, pt.y, 10, 10) withAttributes:nil];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
