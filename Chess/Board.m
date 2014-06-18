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
@synthesize terms;
-(id) init{
    self = [super init];
    NSLog(@"initing board");
    pieceSet = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        NSMutableArray *v = [[NSMutableArray alloc] initWithCapacity:8];
        for (int j = 0; j < 8; j++) {
            Piece *p = [[Piece alloc]initWithImg:nil and:[NSMutableString stringWithString:@"empty"] with:i with:j with:0];
            [v addObject:p];
        }
        [pieceSet addObject:v];
    }
    terms = 0;
    return self;
}
-(void) setPieceOnBoard:(int)X with:(int)Y with:(Piece *)p{
    NSLog(@"in set piece on board");
    [[pieceSet objectAtIndex:X] insertObject:p atIndex:Y];
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
            [t setSide:[p getSide]];
            //[t setImg:[p getImage] and:[p getName]];
            //[p setImg:tempImage and:[NSMutableString stringWithString:@"empty"]];
            NSLog(@"%@ and p name %@",[t getName],[p getName]);

        }
        else if([t getSide] != [p getSide]) {
            NSLog(@"t side isnt same to p side");
            UIImageView *tempImage2 = [t getImage];
            UIImageView *tempImage = [p getImage];
            [self imageTakeOver:tempImage takeOver:tempImage2];
            [t setName:[p getName]];
            [p setName: [NSMutableString stringWithFormat: @"empty"]];
        }
    }
    
}
-(void) imageTakeOver:(UIImageView *) a takeOver:(UIImageView *)b {
    b.image = a.image;
    a.image = [UIImage imageNamed:@"empty.png"];
}
-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b{
    NSLog(@"in image exchange");
    UIImage *c = [a.image copy];
    NSLog(@"after copy");
    a.image = b.image;
    b.image = c;
}
-(BOOL) isAbleToBecomeQueenFor:(Piece *) pi to:(Piece *) t{
    if ([pi getSide] == 1) {
        if ([t getY] == 7) {
            [pi setName:[NSMutableString stringWithFormat: @"queen"]];
            return true;
        }
    }
    else if ([pi getSide] == 2) {
        if ([t getY] == 0) {
            [pi setName:[NSMutableString stringWithFormat: @"queen"]];
            return true;
        }
    }
    else {
        
    }
    return false;
}
-(BOOL) requrieMove:(Piece *) pi to:(Piece *)t {
    if ([pi getSide] == 1) {
        if ([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
            if ([pi getY] == 1) {
                if ([t getSide] != [pi getSide] && ([t getSide] != 0)) {
                    if (([t getY] == [pi getY] + 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                        [self isAbleToBecomeQueenFor:pi to:t];
                        return true;
                    }
                    else {
                        NSLog(@"not able to eat");
                        return false;
                    }
                }
                if ((([t getY] - [pi getY]) <= 2) && ([t getY] - [pi getY] > 0)&& ([t getX] - [pi getX] == 0)) {
                    [self isAbleToBecomeQueenFor:pi to:t];
                    return true;
                }
                else {
                    NSLog(@"skipping too much");
                    return false;
                }
            }
            else {
                if ([t getSide] != [pi getSide] && ([t getSide] != 0)) {
                    if (([t getY] == [pi getY] + 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                        [self isAbleToBecomeQueenFor:pi to:t];
                        return true;
                    }
                    else {
                        NSLog(@"non original point unable to eat");
                        return false;
                    }
                }
                if ([t getY] - [pi getY] == 1 && ([t getX] - [pi getX] == 0)) {
                    [self isAbleToBecomeQueenFor:pi to:t];
                    return true;
                }
                else {
                    NSLog(@"non original point skipping too much");
                    return false;
                }
            }
            NSLog(@"unexpected!");
            return false;
        }
        else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"rock"].location != NSNotFound) {
            
        }
    }
    else if([pi getSide] == 2){
        if ([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
            if ([pi getY] == 6) {
                if ([t getSide] != [pi getSide] && ([t getSide] != 0)) {
                    if (([t getY] == [pi getY] - 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                        [self isAbleToBecomeQueenFor:pi to:t];
                        return true;
                    }
                    else return false;
                }
                if ((([t getY] - [pi getY]) >= -2) && ([t getY] - [pi getY] < 0)&& ([t getX] - [pi getX] == 0)) {
                    [self isAbleToBecomeQueenFor:pi to:t];
                    return true;
                }
                else return false;
            }
            else {
                if ([t getSide] != [pi getSide] && ([t getSide] != 0)) {
                    if (([t getY] == [pi getY] - 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                        [self isAbleToBecomeQueenFor:pi to:t];
                        return true;
                    }
                    else return false;
                }
                if ([t getY] - [pi getY] == -1 && ([t getX] - [pi getX] == 0)) {
                    [self isAbleToBecomeQueenFor:pi to:t];
                    return true;
                }
                else return false;
            }
            NSLog(@"unexpected!");
            return false;
        }
        else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"rock"].location != NSNotFound) {
            
        }
    }
    else {
        
    }
    return true;
}
- (BOOL) bot_requireMove:(Piece *) p to:(Piece *)t {
    return true;
}
-(Piece *) getPieceAt:(int)X with:(int)Y {
    return [[pieceSet objectAtIndex:X] objectAtIndex:Y];
}
@end
