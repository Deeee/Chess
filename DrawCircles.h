//
//  DrawCircles.h
//  Chess
//
//  Created by Liu Di on 6/21/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOSCircle.h"
@interface DrawCircles : UIView {
    NSMutableArray *totalCircles;
}
@property int drawColor;
- (void)drawRect:(CGRect)rect;
- (void) drawCircle;
- (void)drawOnSpot:(CGPoint)pt withSide:(int)side;
@end
