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
    //NSLog(@"initing board");
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
    //NSLog(@"in set piece on board");
    [[pieceSet objectAtIndex:X] insertObject:p atIndex:Y];
}
-(NSMutableArray *) getPieceSet{
    return pieceSet;
}

-(void) setMove:(Piece *) p to:(Piece *)t {
    //NSLog(@"in board setMove");
    if ([p getSide] == [t getSide]) {
        return;
    }
    if ([self requrieMove:p to:t] == true) {
        //NSLog(@"%@ and p name %@",[t getName],[p getName]);
        if ([[t getName] isEqualToString:@"empty"] ) {
            //NSLog(@"yes it is equal to empty");
            UIImageView *tempImage = [t getImage];
            UIImageView *tempImage2 = [p getImage];
            NSLog(@"%@ take over %@, from %d %d, to %d %d",[p getName],[t getName],[p getX], [p getY],[t getX],[t getY]);
            [self imageExchange:tempImage with:tempImage2];
            [t setName:[p getName]];
            [p setName:[NSMutableString stringWithString:@"empty"]];
            [t setSide:[p getSide]];
            [p setSide:0];
            //[t setImg:[p getImage] and:[p getName]];
            //[p setImg:tempImage and:[NSMutableString stringWithString:@"empty"]];

        }
        else if([t getSide] != [p getSide]) {
            NSLog(@"t side isnt same to p side");
            UIImageView *tempImage2 = [t getImage];
            UIImageView *tempImage = [p getImage];
            NSLog(@"%@ take over %@, from %d %d, to %d %d",[p getName],[t getName],[p getX], [p getY],[t getX],[t getY]);
            [self imageTakeOver:tempImage takeOver:tempImage2];
            [t setName:[p getName]];
            [p setName: [NSMutableString stringWithFormat: @"empty"]];
            [t setSide:[p getSide]];
            [p setSide:0];

        }
    }
    //added this
    else {
        NSLog(@"requrie move returned false");
    }
    
}
-(void) imageTakeOver:(UIImageView *) a takeOver:(UIImageView *)b {
    b.image = a.image;
    a.image = [UIImage imageNamed:@"empty.png"];
}
-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b{
    //NSLog(@"in image exchange");
    UIImage *c = [a.image copy];
    //NSLog(@"after copy");
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

// if piece colors are different and not empty.
-(BOOL) isOppColor: (Piece *) pi and :(Piece *)t {
    return ([t getSide] != [pi getSide] && ([t getSide] != 0));
}

-(BOOL)blackPawnMove:(Piece *) pi to :(Piece *)t {
    if ([pi getY] == 6) {
        if ([self isOppColor:pi and:t]) {
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
        if ([self isOppColor:pi and:t]) {
            if (([t getY] == [pi getY] - 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                [self isAbleToBecomeQueenFor:pi to:t];
                return true;
            }
            else return false;
        }
        if ([t getY] - [pi getY] == -1 && ([t getX] - [pi getX] == 0)) {
            [self isAbleToBecomeQueenFor:pi to:t];
            NSLog(@"regular move by black");
            return true;
        }
        else return false;
    }
    NSLog(@"unexpected!");
    return false;

}

-(BOOL)whitePawnMove:(Piece *) pi to :(Piece *)t {
 
    if ([pi getY] == 1) {
        if ([self isOppColor:pi and:t]) {
            
            if (([t getY] == [pi getY] + 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                [self isAbleToBecomeQueenFor:pi to:t];
                return true;
            }
            else {
                NSLog(@"not able to eat");
                return false;
            }
        }
        else if ((([t getY] - [pi getY]) <= 2) && ([t getY] - [pi getY] > 0)&& ([t getX] - [pi getX] == 0)) {
            [self isAbleToBecomeQueenFor:pi to:t];
            return true;
        }
        else {
            NSLog(@"skipping too much");
            return false;
        }
    }
    
    else {
        if ([self isOppColor:pi and:t]) {
            if (([t getY] == [pi getY] + 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                // attacks diagonally up one square.
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

// valid rock moves for both colors
// helper function to rockMove()
-(BOOL)isValidRockMove:(Piece *)pi to : (Piece*) t {
    
    int startX = [pi getX];
    int startY = [pi getY];
    int endX = [t getX];
    int endY = [t getY];
    
    int xDiff = endX - startX;
    int yDiff = endY - startY;
    
    NSLog(@"xDiff : %d \t yDiff : %d\n",xDiff, yDiff);
    
    // all for loops within the inner if blocks are used to make sure that the piece is only going through
    // empty squares to reach the destination square.
    
    if((yDiff == 0) && (xDiff != 0)) {
        // rock is moving horizontal, along x axis
        // debug print statement :  NSLog(@" piece at %d, %d \t %d,%d \t side = %d\n",i,startY, [p getX], [p getY], [p getSide]);
            // need Piece* p = getPiece() etc.
        if(xDiff < 0) {
            for(int i = startX - 1; i > endX; i--)
                if([ [self getPieceAt:i with:startY] getSide] != 0)
                    return false;
        }
        else {
            for(int i = startX + 1; i < endX; i++)
                if([ [self getPieceAt:i with:startY] getSide] != 0)
                    return false;
        }
        return true;
    }
    else if((xDiff == 0) && (yDiff != 0)) {
        // rock is moving vertical, along y axis
        // debug print statement : NSLog(@" piece at %d,%d \t %d,%d \t side = %d\n",startX,i, [p getX], [p getY], [p getSide]);
        if(yDiff < 0) {
            for(int i = startY - 1; i > endY; i--)
                if([ [self getPieceAt:startX with:i] getSide] != 0)
                    return false;
        }
        else {
            for(int i = startY + 1; i < endY; i++)
                if([ [self getPieceAt:startX with:i] getSide] != 0)
                    return false;
        }
        return true;
    }
    else
        return false;

}

//rockMove for both colors
-(BOOL)rockMove:(Piece *)pi to :(Piece*)t {
    if(([pi getSide] != [t getSide]) && [self isValidRockMove:pi to:t]) {
        NSLog(@"valid rock move ");
        return true;
    }
    else {
        NSLog(@"invalid rock move");
        return false;
    }
}

// valid knight moves for both colors
// helper function to knightMove()
-(BOOL)isValidKnightMove:(Piece *)pi to :(Piece*)t {
    
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
    NSLog(@"xDiff : %d \t yDiff : %d\n",xDiff, yDiff);
    
    if(xDiff == 2 && yDiff == 1)
        return true;
    if(xDiff == 2 && yDiff == -1)
        return true;
    if(xDiff == -2 && yDiff == 1)
        return true;
    if(xDiff == -2 && yDiff == -1)
        return true;
    
    if(xDiff == 1 && yDiff == 2)
        return true;
    if(xDiff == 1 && yDiff == -2)
        return true;
    if(xDiff == -1 && yDiff == 2)
        return true;
    if(xDiff == -1 && yDiff == -2)
        return true;
    
    return false;
}

//knightMove works for both colors
-(BOOL)knightMove:(Piece *)pi to :(Piece *)t {
    if(([pi getSide] != [t getSide]) && [self isValidKnightMove:pi to:t]) {
        NSLog(@"valid knight move ");
        return true;
    }
    else {
        NSLog(@"invalid knight move");
        return false;
    }
}

//requrieMove ~ validating moves ?
-(BOOL) requrieMove:(Piece *) pi to:(Piece *)t {
    
    // might not need if statment to get color, piece methods could be color independent.
    
    //WHITE pieces
    if ([pi getSide] == 1) {
        //for white pawn
        if ([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
            return [self whitePawnMove:pi to:t];
        }
        else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {
        }
        else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {
            return [self knightMove:pi to:t];
        }
        else if([pi.getName rangeOfString:@"rock"].location != NSNotFound) {
            return [self rockMove:pi to:t];
        }
    }
    //BLACK PIECES
    else if([pi getSide] == 2){
        if ([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
            return [self blackPawnMove:pi to:t];
        }
        else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
            
        }
        else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {
            return [self knightMove:pi to:t];
        }
        else if([pi.getName rangeOfString:@"rock"].location != NSNotFound) {
            return [self rockMove:pi to:t];
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
