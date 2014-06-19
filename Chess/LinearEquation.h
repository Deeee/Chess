//
//  LinearEquation.h
//  Chess
//
//  Created by Liu Di on 6/19/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinearEquation : NSObject
@property double m, b;
-(id) initWith:(double)M and:(double)B;
-(void) setValues:(double)M and:(double)B;
-(void) solvingFromX1:(double)X1 andY1:(double)Y1 andX2:(double)X2 andY2:(double)Y2;
-(BOOL) isOnEQ:(double)X and:(double)Y;
-(double) getXbyY:(double) Y;
-(double) getYbyX:(double) X;
@end
