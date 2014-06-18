//
//  Board.m
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Board.h"

@implementation Board
@synthesize pieceSet;
-(id) init{
    self = [super init];
    NSLog(@"initing board");
    pieceSet = [[NSMutableArray alloc] initWithCapacity:64];
    for (int i = 0; i < 8; i++) {
        NSMutableArray *v = [[NSMutableArray alloc] initWithCapacity:8];
        [pieceSet addObject:v];
    }
    return self;
}
-(void) setPieceOnBoard:(int)Vertical with:(int)Parallel with:(Piece *)p{
    NSLog(@"in set piece on board");
    [[pieceSet objectAtIndex:Parallel] insertObject:p atIndex:Vertical];
}
-(NSMutableArray *) getPieceSet{
    return pieceSet;
}

-(void) setMove:(int)Vertical with:(int)Parallel with:(Piece *) p {
    if ([self requrieMove:Vertical with:Parallel with:p] == true) {
        if ([[pieceSet[Parallel][Vertical]getName] isEqualToString:@"empty"] ) {
            Piece *temp = [self getPieceAt:Vertical with:Parallel];
            UIImageView *tempImage = [temp getImage];
            [temp setImg:[p getImage] and:[p getName]];
            [p setImg:tempImage and:[NSMutableString stringWithString:@"empty"]];
        }
    }
    
}

-(BOOL) requrieMove:(int)Vertical with:(int)Parallel with:(Piece *)p{

    return true;
}

-(Piece *) getPieceAt:(int)Vertical with:(int)Parallel {
    return pieceSet[Parallel][Vertical];
}
@end
