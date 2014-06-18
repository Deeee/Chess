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
    pieceSet = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        NSMutableArray *v = [[NSMutableArray alloc] initWithCapacity:8];
        for (int j = 0; j < 8; j++) {
            Piece *p = [[Piece alloc]initWithImg:nil and:[NSMutableString stringWithString:@"empty"] with:j with:i with:0];
            [v addObject:p];
        }
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

-(void) setMove:(Piece *) p to:(Piece *)t {
    NSLog(@"in board setMove");
    
    if ([self requrieMove:p to:t] == true) {
        NSLog(@"%@ and p name %@",[t getName],[p getName]);
        if ([[t getName] isEqualToString:@"empty"] ) {
            NSLog(@"yes it is equal to empty");
            UIImageView *tempImage = [t getImage];
            UIImageView *tempImage2 = [p getImage];
            [self imageExchange:tempImage with:tempImage2];
            [t setName:[p getName]];
            [p setName:[NSMutableString stringWithString:@"empty"]];
            //[t setImg:[p getImage] and:[p getName]];
            //[p setImg:tempImage and:[NSMutableString stringWithString:@"empty"]];
            NSLog(@"%@ and p name %@",[t getName],[p getName]);

        }
    }
    
}

-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b{
    NSLog(@"in image exchange");
    UIImage *c = [a.image copy];
    NSLog(@"after copy");
    a.image = b.image;
    b.image = c;
}
-(BOOL) requrieMove:(Piece *) p to:(Piece *)t {

    return true;
}
- (BOOL) bot_requireMove:(Piece *) p to:(Piece *)t {
    return true;
}
-(Piece *) getPieceAt:(int)Vertical with:(int)Parallel {
    return pieceSet[Parallel][Vertical];
}
@end
