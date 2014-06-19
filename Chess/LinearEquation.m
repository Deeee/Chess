//
//  LinearEquation.m
//  Chess
//
//  Created by Liu Di on 6/19/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "LinearEquation.h"

@implementation LinearEquation
@synthesize m, b;
-(id) initWith:(double)M and:(double)B{
    self = [super init];
    [self setValues:M and:B];
    return self;
}
-(void) setValues:(double)M and:(double)B{
    [self setM:M];
    [self setB:B];
}

-(void) solvingFromX1:(double)X1 andY1:(double)Y1 andX2:(double)X2 andY2:(double)Y2{
    m = (double)(Y1 - Y2) / (double)(X1 - X2);
    b = (double)Y1 - (double)X1 * m;
}

-(BOOL) isOnEQ:(double)X and:(double)Y {
    if ((double)Y == (m * (double)X + b)) {
        return true;
    }
    else return false;
}
-(double) getXbyY:(double)Y {
    return (Y - b)/m;
}
-(double) getYbyX:(double)X {
    return (X * m) + b;
}
@end
