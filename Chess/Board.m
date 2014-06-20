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
@synthesize white, black;
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
    terms = 1;
    [white setSide:1];
    [black setSide:2];
    return self;
}

-(void) setPieceOnBoard:(int)X with:(int)Y with:(Piece *)p{
    //NSLog(@"in set piece on board");
    [[pieceSet objectAtIndex:X] insertObject:p atIndex:Y];
}

-(NSMutableArray *) getPieceSet{
    return pieceSet;
}

-(void) changeTerms {
    if (terms == 1) {
        terms = 2;
    }
    else {
        terms = 1;
    }
}

-(BOOL) setMove:(Piece *) p to:(Piece *)t and:(int)isDebug{
    //NSLog(@"in board setMove");
    if ([p getSide] == [t getSide]) {
        return false;
    }
    if (isDebug == 1) {
        [self debugMove:p to:t];
        return true;
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
            return true;

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
            return true;

        }
    }
    //added this
    else {
        NSLog(@"requrie move returned false");
    }
    return false;

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
//return king from the board
-(Piece *)getBlackKing {
    for (NSMutableArray *i  in pieceSet) {
        for (Piece *p in i) {
            if ([[p getName] isEqualToString:[NSMutableString stringWithFormat:@"bking"]]) {
                return p;
            }
        }
    }
    NSLog(@"erro king doesnt exist");
    return nil;
}

-(Piece *)getWhiteKing {
    for (NSMutableArray *i  in pieceSet) {
        for (Piece *p in i) {
            if ([[p getName] isEqualToString:[NSMutableString stringWithFormat:@"king"]]) {
                return p;
            }
        }
    }
    NSLog(@"erro king doesnt exist");
    return nil;
}
-(BOOL) isChecked:(int)isDebug {
    if (isDebug == 1) {
        return false;
    }
    if (terms == 1) {
        
        Piece *temp = [self getWhiteKing];
        NSLog(@"");
        for (NSMutableArray *i in pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 2) {
                    if ([self requrieMove:p to:temp]) {
                        NSLog(@"white king checked by %@(%d,%d)",[p getName],[p getX],[p getY]);
                        return true;
                    }
                    else {
                        //NSLog(@"shouldnt reach here %@, (%d,%d)",[p getName],[p getX],[p getY]);
                    }
                }
            }
        }
        
    }
    else if(terms == 2){
        Piece *temp = [self getBlackKing];
        for (NSMutableArray *i in pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 1) {
                    if ([self requrieMove:p to:temp]) {
                        NSLog(@"black king checked");
                        return true;
                    }
                }

            }
        }
    }
    else {
        NSLog(@"terms erro!");
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
                //[self isAbleToBecomeQueenFor:pi to:t];
                return true;
            }
            else return false;
        }
        if ((([t getY] - [pi getY]) >= -2) && ([t getY] - [pi getY] < 0)&& ([t getX] - [pi getX] == 0)) {
            //[self isAbleToBecomeQueenFor:pi to:t];
            return true;
        }
        else return false;
    }
    else {
        if ([self isOppColor:pi and:t]) {
            if (([t getY] == [pi getY] - 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                //[self isAbleToBecomeQueenFor:pi to:t];
                return true;
            }
            else return false;
        }
        if ([t getY] - [pi getY] == -1 && ([t getX] - [pi getX] == 0)) {
            //[self isAbleToBecomeQueenFor:pi to:t];
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
                //[self isAbleToBecomeQueenFor:pi to:t];
                NSLog(@"valid white pawn move");
                return true;
            }
            else {
                //NSLog(@"not able to eat");
                return false;
            }
        }
        else if ((([t getY] - [pi getY]) <= 2) && ([t getY] - [pi getY] > 0)&& ([t getX] - [pi getX] == 0)) {
            //[self isAbleToBecomeQueenFor:pi to:t];
            NSLog(@"valid white pawn move to skewed side");
            return true;
        }
        else {
            //NSLog(@"skipping too much");
            return false;
        }
    }
    
    else {
        if ([self isOppColor:pi and:t]) {
            if (([t getY] == [pi getY] + 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                // attacks diagonally up one square.
                //[self isAbleToBecomeQueenFor:pi to:t];
                NSLog(@"valid white pawn eating move to skewed side");
                return true;
            }
            else {
                //NSLog(@"non original point unable to eat");
                return false;
            }
        }
        if ([t getY] - [pi getY] == 1 && ([t getX] - [pi getX] == 0)) {
            //[self isAbleToBecomeQueenFor:pi to:t];
            NSLog(@"valid white pawn eating move");
            return true;
        }
        else {
            //NSLog(@"non original point skipping too much");
            return false;
        }
    }
    NSLog(@"unexpected!");
    return false;
}

// helper function to rockMove()
// TODO : implement queenMove with isPieceBlocked() for clarity.
-(BOOL)isValidRockMove:(Piece *)pi to : (Piece*) t {
    
    int startX = [pi getX];
    int startY = [pi getY];
    int endX = [t getX];
    int endY = [t getY];
    
    int xDiff = endX - startX;
    int yDiff = endY - startY;
    
    NSLog(@"xDiff : %d \t yDiff : %d -- isValidRockMove\n",xDiff, yDiff);
    
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

// helper function for moveBishop()
-(BOOL)isValidBishopMove:(Piece *)pi to : (Piece*) t{

    int startX = [pi getX];
    int startY = [pi getY];
    int endX = [t getX];
    int endY = [t getY];
    
    int xDiff = endX - startX;
    int yDiff = endY - startY;
    
    NSLog(@"xDiff : %d \t yDiff : %d -- isValidBishopMove\n",xDiff, yDiff);
//    NSLog(@"from (%d,%d) to (%d,%d)\n",startX,startY,endX,endY);
    
    //moving diagonally means that the abs of diff for both axis must be same.
    if(!(ABS(xDiff) == ABS(yDiff)))
        return false;

    // all for loops within if blocks are used to make sure that the piece is only going through
    // empty squares to reach the destination square.
    
    //General print debug statement for for
        //NSLog(@" piece at %d,%d \t %d,%d \t side = %d\n",i,idx, [p getX], [p getY], [p getSide]);
        // must create Piece *p = getPiece();

    if (xDiff < 0 && yDiff < 0) {
        // left up diagonal
        int idx = startY - 1;
        for(int i = startX - 1; i > endX; i--)
            if([[self getPieceAt:i with:idx--] getSide] != 0)
                return false;
    }
    else if(xDiff < 0 && yDiff > 0) {
        //left down diagaonal
        int idx = startY + 1;
        for(int i = startX - 1; i > endX; i--)
            if([[self getPieceAt:i with:idx++] getSide] != 0)
                return false;
        }
    else if(xDiff > 0 && yDiff < 0 ) {
        // right up diagaonal
        int idx = startY - 1;
        for(int i = startX + 1; i < endX; i++)
            if([[self getPieceAt:i with:idx--] getSide] != 0)
                return false;
    }
    else {
        //right down diagonal.
        int idx = startY + 1;
        for(int i = startX + 1; i < endX; i++)
            if([[self getPieceAt:i with:idx++] getSide] != 0)
                return false;
    }
    return true;
}

-(BOOL)bishopMove:(Piece *)pi to :(Piece*)t {
    if(([pi getSide] != [t getSide]) && [self isValidBishopMove:pi to:t]) {
        NSLog(@"valid bishop move ");
        return true;
    }
    else {
        NSLog(@"invalid bishop move");
        return false;
    }
}

// valid knight moves for both colors
// helper function to knightMove()
-(BOOL)isValidKnightMove:(Piece *)pi to :(Piece*)t {
    
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
    NSLog(@"xDiff : %d \t yDiff : %d -- isValidKnightMove\n",xDiff, yDiff);
    
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
-(BOOL)knightMove:(Piece *)pi to:(Piece *)t {
    if(([pi getSide] != [t getSide]) && [self isValidKnightMove:pi to:t]) {
        NSLog(@"valid knight move ");
        return true;
    }
    else {
        NSLog(@"invalid knight move");
        return false;
    }
}
//Need implementation on every piece type that requires block check
-(BOOL)isPieceBlocked:(Piece *)pi to:(Piece *)t {
    NSLog(@"in testing blocking");
    if ([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
        LinearEquation *le = [[LinearEquation alloc]initWith:0 and:0];
        [le solvingFromX1:[pi getX] andY1:[pi getY] andX2:[t getX] andY2:[t getY]];
        if ([pi getX] > [t getX]) {
            for (int i = [pi getX] - 1;i != [t getX]; i--) {
                if (![[[self getPieceAt:i with:[le getYbyX:i]] getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]]) {
                    return true;
                }
            }
        }
        else {
            for (int i = [pi getX] + 1;i != [t getX]; i++) {
                if (![[[self getPieceAt:i with:[le getYbyX:i]] getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]]) {
                    return true;
                }
            }
        }
        return false;
    }
    return false;
}
//helpful function for bishop moves
-(BOOL)isValidBishopMove1:(Piece *)pi to:(Piece *)t {
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
    NSLog(@"xDiff : %d \t yDiff : %d\n",xDiff, yDiff);
    if (ABS(xDiff) == ABS(yDiff) && ![self isPieceBlocked:pi to:t]) {
        return true;
    }
    else {
        NSLog(@"invalid bishop move");
        return false;
    }
}
//main function for checking bishop moves
-(BOOL)bishopMove1:(Piece *)pi to :(Piece *)t {
    if (([pi getSide] != [t getSide]) && [self isValidBishopMove:pi to:t]) {
        NSLog(@"valid bishop move");
        return true;
    }
    else {
        NSLog(@"invalid bishop move");
        return false;
    }
}
// helper function for queenMove();
// TODO : implement queenMove with isPieceBlocked() for clarity.
-(BOOL) isValidQueenMove:(Piece *)pi to: (Piece *)t {
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
    NSLog(@"xDiff : %d \t yDiff : %d -- isValidQueenMove\n",xDiff, yDiff);
    
    if(![self isValidKnightMove:pi to:t]) {
        if(ABS(xDiff) == ABS(yDiff))
            return [self isValidBishopMove:pi to:t];
        else
            return [self isValidRockMove:pi to:t];
    }
    else {
        NSLog(@"invalid queen move -- isValidQueenMove");
        return false;
    }
}

-(BOOL)queenMove:(Piece *)pi to :(Piece *)t {
    if (([pi getSide] != [t getSide]) && [self isValidQueenMove:pi to:t]) {
        NSLog(@"valid queen move");
        return true;
    }
    else {
        NSLog(@"invalid queen move -- queenMove");
        return false;
    }
}

-(BOOL)kingMove:(Piece *)pi to:(Piece *)t {
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
    if ([pi getSide] != [t getSide] && (ABS(xDiff) <= 1 && ABS(yDiff) <= 1)) {
        NSLog(@"kingmove approved %d,%d",xDiff, yDiff);
        return true;
    }
    else return false;
}
-(BOOL) isUnchecked:(Piece *)pi to:(Piece *)t {
    if ([pi getSide] == [t getSide]) {
        return false;
    }
        int tempSideT = [t getSide];
    int tempSideP = [pi getSide];
    NSMutableString *tempNameP = [NSMutableString stringWithString:[pi getName]];
        NSMutableString *tempNameT = [NSMutableString stringWithString:[t getName]];
        [t setName:[pi getName]];
        [pi setName:[NSMutableString stringWithString:@"empty"]];
        [t setSide:[pi getSide]];
        [pi setSide:0];
    if ([self isChecked]) {
            [t setSide:tempSideT];
            [t setName:tempNameT];
            [pi setSide:tempSideP];
            [pi setName:tempNameP];
            return false;
        }
        else {
            [t setSide:tempSideT];
            [t setName:tempNameT];
            [pi setSide:tempSideP];
            [pi setName:tempNameP];
            return true;
        }

}
//requrieMove ~ validating moves ?
-(BOOL) requrieMove:(Piece *) pi to:(Piece *)t {
//    if (isDebug == 1) {
//        return true;
//    }
    // moves for all pieces except pawns are color independent.
    if ([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
        if([pi getSide] == 1) {
            if([self whitePawnMove:pi to:t]) {
                NSLog(@"valid white pawn move");
                if ([self isUnchecked:pi to:t]) {
                    return true;
                }
                else return false;
            }
            else return false;
        }
        else if([pi getSide] == 2) {
            if([self blackPawnMove:pi to:t]) {
                NSLog(@"valid black pawn move");
                if ([self isUnchecked:pi to:t]) {
                    return true;
                }
                else return false;
            }
            else return false;
        }
        else
            ;
    }
    else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {
        if ([self kingMove:pi to:t]) {
            if ([self isUnchecked:pi to:t]) {
                return true;
            }
            else return false;
        }
        return false;
    }
    else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {
        if ([self queenMove:pi to:t]) {
            if ([self isUnchecked:pi to:t]) {
                return true;
            }
            else false;
        }
        else return false;
    }
    else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
        if ([self bishopMove:pi to:t]) {
            NSLog(@"valid bishop move");
            if ([self isUnchecked:pi to:t]) {
                return true;
            }
            else return false;
        }
        return false;
    }
    else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {
        if ([self knightMove:pi to:t]) {
            NSLog(@"valid knight move");
            if ([self isUnchecked:pi to:t]) {
                return true;
            }
            else return false;
        }
        return false;
    }
    else if([pi.getName rangeOfString:@"rock"].location != NSNotFound) {
        if ([self rockMove:pi to:t]) {
            NSLog(@"valid rock");
            if ([self isUnchecked:pi to:t]) {
                return true;
            }
            else return false;
        }
        return false;
    }
    else {
        NSLog(@"expected");
        return false;
    }
    return false;
}

-(BOOL) bot_requireMove:(Piece *) p to:(Piece *)t {
    return true;
}
-(Piece *) getPieceAt:(int)X with:(int)Y {
    return [[pieceSet objectAtIndex:X] objectAtIndex:Y];
}
-(void) debugMove:(Piece *)p to:(Piece *)t {
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
    else {
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
@end
