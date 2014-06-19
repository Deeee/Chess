//
//  Player.m
//  Chess
//
//  Created by Liu Di on 6/19/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize side;

-(id) initWithSide:(int)s {
    self = [super init];
    side = s;
    return self;
}
@end
