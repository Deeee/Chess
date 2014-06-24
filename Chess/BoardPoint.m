//
//  BoardPoint.m
//  Chess
//
//  Created by Liu Di on 6/23/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "BoardPoint.h"

@implementation BoardPoint
@synthesize x = _x;
@synthesize y = _y;

-(id) initWith:(int)x and:(int)y {
    self = [super init];
    _x = x;
    _y = y;
    return self;
}
-(id) initWith:(Piece *)pi {
    self = [super init];
    _x = [pi getX];
    _y = [pi getY];
    return self;
}

@end
