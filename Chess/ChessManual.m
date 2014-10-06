//
//  ChessManual.m
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "ChessManual.h"

@implementation ChessManual
@synthesize manualName = _manualName;
@synthesize side = _side;
@synthesize currentScript = _currentScript;
@synthesize currentStep;
-(id) initWithManualName:(NSString *) name and:(int) side{
    self = [super init];
    _manualName = name;
    _side = side;
    currentStep = 0;
    _currentScript = [[NSMutableArray alloc] init];
    [self loadScript:name];
    return self;
}

-(BoardPoint *) makeBoardPointX:(int)x andY:(int)y {
    BoardPoint *bp = [[BoardPoint alloc] initWith:x and:y];
    return bp;
}

-(NSArray *) outputScript {
    NSArray *result;
    if ([_currentScript count] == 0) {
        NSLog(@"asking for a empty script");
        return nil;
    }
    else {
        if ([_currentScript count] <= currentStep) {
            return nil;
        }
        result = [_currentScript subarrayWithRange:NSMakeRange(currentStep, 2)];
        currentStep += 2;
    }
    return result;
}

-(void) loadScriptStoneOpening {
    [_currentScript addObject:[self makeBoardPointX:4 andY:6]];
    [_currentScript addObject:[self makeBoardPointX:4 andY:4]];
    
    [_currentScript addObject:[self makeBoardPointX:3 andY:6]];
    [_currentScript addObject:[self makeBoardPointX:3 andY:5]];
    
    [_currentScript addObject:[self makeBoardPointX:2 andY:7]];
    [_currentScript addObject:[self makeBoardPointX:4 andY:5]];
    
//    [_currentScript addObject:[self makeBoardPointX:3 andY:6]];
//    [_currentScript addObject:[self makeBoardPointX:3 andY:4]];
    
    [_currentScript addObject:[self makeBoardPointX:2 andY:6]];
    [_currentScript addObject:[self makeBoardPointX:2 andY:4]];
    
    [_currentScript addObject:[self makeBoardPointX:1 andY:7]];
    [_currentScript addObject:[self makeBoardPointX:2 andY:5]];
    
    [_currentScript addObject:[self makeBoardPointX:3 andY:7]];
    [_currentScript addObject:[self makeBoardPointX:1 andY:7]];
    
    [_currentScript addObject:[self makeBoardPointX:5 andY:6]];
    [_currentScript addObject:[self makeBoardPointX:5 andY:5]];
    
//    [_currentScript addObject:[self makeBoardPointX:4 andY:6]];
//    [_currentScript addObject:[self makeBoardPointX:4 andY:4]];
    
    [_currentScript addObject:[self makeBoardPointX:2 andY:5]];
    [_currentScript addObject:[self makeBoardPointX:3 andY:3]];
    
    [_currentScript addObject:[self makeBoardPointX:6 andY:7]];
    [_currentScript addObject:[self makeBoardPointX:4 andY:6]];
    if (_side == 1) {
        NSLog(@"side is 1");
        //TODO: add script for white side.
    }

}
-(void) loadScript:(NSString *)name {
    if ([name isEqualToString:@"stoneWall"]) {
//        NSLog(@"loading stoneWall....");
        [self loadScriptStoneOpening];
    }
    else {
        NSLog(@"cannot find the script named %@, error!",name);
    }
}
@end
