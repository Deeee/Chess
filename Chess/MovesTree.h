//
//  MovesTree.h
//  Chess
//
//  Created by Liu Di on 7/18/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HardBot.h"
@interface MovesTree : NSObject{
    
}

-(void) buildTree:(HardBot *)board;

@end

//
@interface node : NSObject {
    double nodeValue;
    NSMutableArray *move;
    NSMutableArray *next;
}
@end

@implementation node
-(id) init{
    self = [super init];
    nodeValue = 0;
    move = [[NSMutableArray alloc] init];
    next = [[NSMutableArray alloc] init];
    return self;
}

@end