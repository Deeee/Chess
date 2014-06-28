//
//  HardBot.m
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "HardBot.h"

@implementation HardBot
@synthesize manual;

-(void) scriptMove {
    NSArray *readin = [manual outputScript];
    Piece *pi = [self getPieceAt:[[readin objectAtIndex:0] boardPointGetX] with:[[readin objectAtIndex:0] boardPointGetY]];
    Piece *t = [self getPieceAt:[[readin objectAtIndex:1] boardPointGetX] with:[[readin objectAtIndex:1] boardPointGetY]];
    [self botMoveFrom:pi to:t];
}

-(void) botMoveFrom:(Piece *)p to:(Piece *)t {
    NSLog(@"in bot move");
    UIImageView *tempImage2 = [t getImage];
    UIImageView *tempImage = [p getImage];
    NSLog(@"%@ take over %@, from %d %d, to %d %d",[p getName],[t getName],[p getX], [p getY],[t getX],[t getY]);
    [self imageTakeOver:tempImage takeOver:tempImage2];
    [t setName:[p getName]];
    [p setName: [NSMutableString stringWithFormat: @"empty"]];
    [t setSide:[p getSide]];
    [p setSide:0];
    
}

-(id) init{
    self = [super init];
    NSLog(@"initing hard board");
    manual = [[ChessManual alloc] initWithManualName:@"stoneWall" and:2];
    return self;
}
-(void) changeTerms {
    NSLog(@"in hard bot attack moves");
    //If there are unconfirmed move, reject term changing request.
    if ([self.undecidedMove count] == 0) {
        return;
    }
    
    if (self.terms == 1) {
        NSLog(@"yes term equals to 1");
        self.undecidedReturnTrue = 0;
        [self.undecidedMove removeAllObjects];
        self.terms = 2;
        [self scriptMove];
        self.terms = 1;
        return;
    }
    NSLog(@"change term error!");
    //    else {
    //        self.undecidedReturnTrue = 0;
    //        [self.undecidedMove removeAllObjects];
    //        self.terms = 1;
    //    }
}
@end
