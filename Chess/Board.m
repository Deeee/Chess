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
@synthesize isInCheck;
@synthesize undecidedMove;
@synthesize undecidedReturnTrue;
@synthesize isCastlePiecesMoved;
@synthesize mode;
@synthesize checkingPieces;
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
    undecidedMove = [[NSMutableArray alloc] init];
    isCastlePiecesMoved = [[NSMutableArray alloc] init];
    for (int i = 0; i < 6; i ++) {
        [isCastlePiecesMoved addObject: @(1)];
    }
    terms = 1;
    isInCheck = 0;
    undecidedReturnTrue = 0;
    [white setSide:1];
    [black setSide:2];
    checkingPieces = [[NSMutableArray alloc] init];
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
    //If there are unconfirmed move, reject term changing request.
    if ([undecidedMove count] == 0) {
        return;
    }
    if (terms == 1) {
        undecidedReturnTrue = 0;
        [undecidedMove removeAllObjects];
        terms = 2;
        
    }
    else {
        undecidedReturnTrue = 0;
        [undecidedMove removeAllObjects];
        terms = 1;
    }
}

-(NSString *) getImageNameFromPiece:(Piece *)p {
    if ([[p getName] rangeOfString:@"bpawn"].location != NSNotFound) {
        return @"bpawn.png";
    }
    else if ([[p getName] rangeOfString:@"bknight"].location != NSNotFound){
        return @"bknight.png";
    }
    else if ([[p getName] rangeOfString:@"brook"].location != NSNotFound) {
        return @"brook.png";
    }
    else if ([[p getName] rangeOfString:@"bqueen"].location != NSNotFound) {
        return @"bqueen.png";
    }
    else if ([[p getName] rangeOfString:@"bking"].location != NSNotFound) {
        return @"bking.png";
    }
    else if ([[p getName] rangeOfString:@"bbishop"].location != NSNotFound) {
        return @"bbishop.png";
    }
    else if ([[p getName] rangeOfString:@"pawn"].location != NSNotFound) {
        return @"pawn.png";
    }
    else if ([[p getName] rangeOfString:@"knight"].location != NSNotFound){
        return @"knight.png";
    }
    else if ([[p getName] rangeOfString:@"rook"].location != NSNotFound) {
        return @"rook.png";
    }
    else if ([[p getName] rangeOfString:@"queen"].location != NSNotFound) {
        return @"queen.png";
    }
    else if ([[p getName] rangeOfString:@"king"].location != NSNotFound) {
        return @"king.png";
    }
    else if ([[p getName] rangeOfString:@"bishop"].location != NSNotFound) {
        return @"bishop.png";
    }
    else if ([[p getName] rangeOfString:@"empty"].location != NSNotFound) {
        return @"empty.png";
    }
    else {
        NSLog(@"error from find image names, picece info printed as below");
        [p printInformation];
        NSLog(@"----------------------------------------");
        return nil;
    }
}
-(BOOL) setMove:(Piece *) p to:(Piece *)t and:(int)isDebug{
    //NSLog(@"in board setMove");
    if (isDebug == 1) {
        [self debugMove:p to:t];
        return true;
    }
    
    if ([undecidedMove count] == 2) {
        BoardPoint *savedP = [[BoardPoint alloc] initWith: [undecidedMove objectAtIndex:0]];
        BoardPoint *savedT = [[BoardPoint alloc] initWith:[undecidedMove objectAtIndex:1]];
        NSLog(@"undecidedmove equals to 2");
        if (![self comparePoints:[[BoardPoint alloc] initWith:t] to:savedP]  || ![self comparePoints:[[BoardPoint alloc] initWith:p] to:savedT]) {
            NSLog(@"undecidedmove false");
            undecidedReturnTrue = 0;
            return false;
        }
        else {
            Piece *tempP = [undecidedMove objectAtIndex:0];
            Piece *tempT = [undecidedMove objectAtIndex:1];
            NSLog(@"tempP");
            [tempP printInformation];
            NSLog(@"tempT");
            [tempT printInformation];
            NSLog(@"p :");
            [p printInformation];
            NSLog(@"t :");
            [t printInformation];
            [p setName:[tempT getName]];
            [p setSide:[tempT getSide]];
            [t setName:[tempP getName]];
            [t setSide:[tempP getSide]];
            [t getImage].image = [UIImage imageNamed:[self getImageNameFromPiece:tempP]];
            [p getImage].image = [UIImage imageNamed:[self getImageNameFromPiece:tempT]];

            [undecidedMove removeAllObjects];
            undecidedReturnTrue = 1;
            //i suspect that the image didnt get exchanged
            NSLog(@"undecidedmove true");
            return true;

        }
    }
    else {
        NSLog(@"undecidedmove is empty");

//        NSLog(@"saved piece p:");
//        [[undecidedMove objectAtIndex:0] printInformation];
//        NSLog(@"saved piece t:");
//        [[undecidedMove objectAtIndex:1] printInformation];

    }
    if ([p getSide] != [t getSide] && [self isUnchecked:p to:t] && [self validateMove:p to:t]) {
        //NSLog(@"%@ and p name %@",[t getName],[p getName]);
        [undecidedMove addObject:[p copyWithSelf]];
        [undecidedMove addObject:[t copyWithSelf]];
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
            NSLog(@"adding undecidedmoves");

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
            NSLog(@"adding undecidedmoves");

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

-(BOOL) isValidCoordinate:(int)x and :(int)y {
    if((x < 0) || (x > 7) || (y < 0) || (y > 7))
        return false;
    else return true;
}

-(BOOL) isAbleToPromote:(Piece *) pi to:(Piece *) t{
    if (([pi getSide] == 1) && ([t getY] == 7))
            return true;
    else if (([pi getSide] == 2) && ([t getY] == 0))
            return true;
    
    else {
        
    }
//    NSLog(@"last is not able to promote");
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

-(void) checkStatus {
    NSLog(@" in checkStatus");
    
    if (terms == 1) {
        NSLog(@"in is term 1");
        Piece *temp = [self getWhiteKing];
        NSLog(@"white king is %@(%d,%d)",[temp getName],[temp getX],[temp getY]);
        for (NSMutableArray *i in pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 2) {
                    if ([self validateMove:p to:temp]) {
                        NSLog(@"white king checked by %@(%d,%d)",[p getName],[p getX],[p getY]);
                        isInCheck = 1;
                        [checkingPieces addObject:p];
                    }
                    else {
                        isInCheck = 0;
                        //NSLog(@"shouldnt reach here %@, (%d,%d)",[p getName],[p getX],[p getY]);
                    }
                }
            }
        }
        
    }
    else if(terms == 2){
        NSLog(@"in is term 2");
        
        Piece *temp = [self getBlackKing];
        for (NSMutableArray *i in pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 1) {
                    if ([self validateMove:p to:temp]) {
                        NSLog(@"black king checked");
                        isInCheck = 2;
                        [checkingPieces addObject:p];
                    }
                    else {
                        isInCheck = 0;
                    }
                }
                
            }
        }
    }
    else {
        NSLog(@"terms erro!");
    }
}

-(BOOL) isAttackedHorizontal:(Piece*)king {
    //CHECKING FOR HORIZONTALS -> QUEEN OR ROOK.
    
    // left of king.
    //    NSLog(@" LEFT");
    for(int i = [king getX] - 1; i > -1; i--) {
        Piece* p = [self getPieceAt:i with:[king getY]];
        //        NSLog(@"   (%d,%d)\n",[p getX],[p getY]);
        if([self isSameColor:king and:p])
            break;
        else if([self isOppColor:king and:p] && ([p isRook] || [p isQueen])) {
            NSLog(@"is checked 1");
            return true;
        }
        else if([self isOppColor:king and:p])
            break;
    }
    // right of king.
    //    NSLog(@" RIGHT");
    for(int i = [king getX] + 1; i < 8; i++) {
        Piece* p = [self getPieceAt:i with:[king getY]];
        //        NSLog(@"   (%d,%d)\n",[p getX],[p getY]);
        if([self isSameColor:king and:p])
            break;
        else if([self isOppColor:king and:p] && ([p isRook] || [p isQueen])) {
            NSLog(@"is checked 2");
            return true;
        }
        else if([self isOppColor:king and:p])
            break;
    }
    // up of king.
    //    NSLog(@" UP");
    for(int i = [king getY] - 1; i > -1; i--) {
        Piece* p = [self getPieceAt:[king getX] with:i];
        //        NSLog(@"   (%d,%d)\n",[p getX],[p getY]);
        if([self isSameColor:king and:p])
            break;
        else if([self isOppColor:king and:p] && ([p isRook] || [p isQueen])) {
            NSLog(@"is checked 3");
            return true;
        }
        else if([self isOppColor:king and:p])
            break;
    }
    // down of king.
    //    NSLog(@" DOWN");
    for(int i = [king getY] + 1; i < 8; i++) {
        Piece* p = [self getPieceAt:[king getX] with:i];
        //        NSLog(@"   (%d,%d)\n",[p getX],[p getY]);
        if([self isSameColor:king and:p])
            break;
        else if([self isOppColor:king and:p] && ([p isRook] || [p isQueen])) {
            NSLog(@"is checked 4");
            return true;
        }
        else if([self isOppColor:king and:p])
            break;
    }
    return false;
}

-(BOOL) isAttackedDiagonal:(Piece*)king {
    //CHECKING FOR DIAGONALS
    
    // up left attacks
    //    NSLog(@"  UP LEFT");
    int tempY = [king getY];
    for(int i = [king getX] - 1; i > -1; i--) {
        int place = --tempY;
        if([self isValidCoordinate:i and:place]) {
            Piece *p = [self getPieceAt:i with:place];
            //            [p printInformation];
            if([self isSameColor:king and:p])
                break;
            else if(([self isOppColor:king and:p] && [p isBishop]) || ([self isOppColor:king and:p] && [p isQueen])) {
                NSLog(@"is checked 5");
                return true;
            }
            else if([self isOppColor:king and:p])
                break;
        }
    }
    
    // up right attacks
    //    NSLog(@"  UP RIGHT");
    tempY = [king getY];
    for(int i = [king getX] + 1; i < 8; i++) {
        int place = --tempY;
        if([self isValidCoordinate:i and:place]) {
            Piece * p = [self getPieceAt:i with:place];
            //            [p printInformation];
            if([self isSameColor:king and:p])
                break;
             else if(([self isOppColor:king and:p] && [p isBishop]) || ([self isOppColor:king and:p] && [p isQueen])) {
                NSLog(@"is checked 6");
                return true;
            }
            else if([self isOppColor:king and:p])
                break;
        }
    }
    
    // down left attacks
    //    NSLog(@"  DOWN LEFT");
    int tempX = [king getX];
    for(int i = [king getY] + 1; i < 8; i++) {
        int place = --tempX;
        if([self isValidCoordinate:place and:i]) {
            Piece* p = [self getPieceAt:place with:i];
            //            [p printInformation];
            if([self isSameColor:king and:p])
                break;
             else if(([self isOppColor:king and:p] && [p isBishop]) || ([self isOppColor:king and:p] && [p isQueen])) {
                NSLog(@"is checked 7");
                return true;
            }
            else if([self isOppColor:king and:p])
                break;
        }
    }
    
    // down right attacks
    //    NSLog(@"  DOWN RIGHT");
    tempX = [king getX];
    for(int i = [king getY] + 1; i < 8; i++) {
        int place = ++tempX;
        if([self isValidCoordinate:place and:i]) {
            Piece* p = [self getPieceAt:place with:i];
            //            [p printInformation];
            if([self isSameColor:king and:p])
                break;
            else if(([self isOppColor:king and:p] && [p isBishop]) || ([self isOppColor:king and:p] && [p isQueen])) {
                NSLog(@"is checked 8");
                return true;
            }
            else if([self isOppColor:king and:p])
                break;
        }
    }
    
    //CHECKING FOR PAWNS
    Piece* pawn;
    // black king against white pawns.
    if([king getSide] == 2) {
        
        int x = [king getX] + 1;
        int y = [king getY] -1;
        if([self isValidCoordinate:x and:y]) {
            pawn = [self getPieceAt:x with:y];
            if([pawn isPawn] && [self isOppColor:king and:pawn]) {
                NSLog(@"is checked 9");
                return true;
            }
        }
        
        x = [king getX] - 1;
        y = [king getY] -1;
        if([self isValidCoordinate:x and:y]) {
            pawn = [self getPieceAt:x with:y];
            if([pawn isPawn] && [self isOppColor:king and:pawn]) {
                NSLog(@"is checked 10");
                return true;
            }
        }
    }
    // white king against black pawns.
    else if([king getSide] == 1) {
        
        int x = [king getX] + 1;
        int y = [king getY] + 1;
        
        if([self isValidCoordinate:x and:y]) {
            pawn = [self getPieceAt:x with:y];
            if([pawn isPawn] && [self isOppColor:king and:pawn]) {
                NSLog(@"is checked 11");
                return true;
            }
        }
        x = [king getX] - 1;
        y = [king getY] + 1;
        
        if([self isValidCoordinate:x and:y]) {
            pawn = [self getPieceAt:x with:y];
            if([pawn isPawn] && [self isOppColor:king and:pawn]) {
                NSLog(@"is checked 12");
                return true;
            }
        }
    }
    else
        ;
    return false;
}

-(BOOL) isAttackedByKnight:(Piece*)king {
    
    //CHECKING FOR KNIGHTS , there can be at most 8 knight locations that can attack one square.
    int kingY = [king getY];
    int kingX = [king getX];
    
    NSMutableArray * possibleKnights = [[NSMutableArray alloc] init];
    
    if([self isValidCoordinate:kingX + 2 and:kingY + 1])
        [possibleKnights addObject:[self getPieceAt:kingX + 2 with:kingY + 1]];
    
    if([self isValidCoordinate:kingX + 2 and:kingY - 1])
        [possibleKnights addObject:[self getPieceAt:kingX + 2 with:kingY - 1]];
    
    if([self isValidCoordinate:kingX -2 and:kingY + 1])
        [possibleKnights addObject:[self getPieceAt:kingX -2 with:kingY + 1]];
    
    if([self isValidCoordinate:kingX -2 and:kingY - 1])
        [possibleKnights addObject:[self getPieceAt:kingX -2 with:kingY - 1]];
    
    if([self isValidCoordinate:kingX + 1 and:kingY + 2])
        [possibleKnights addObject:[self getPieceAt:kingX + 1 with:kingY + 2]];
    
    if([self isValidCoordinate:kingX + 1 and:kingY - 2])
        [possibleKnights addObject:[self getPieceAt:kingX + 1 with:kingY - 2]];
    
    if([self isValidCoordinate:kingX - 1 and:kingY + 2])
        [possibleKnights addObject:[self getPieceAt:kingX - 1 with:kingY + 2]];
    if([self isValidCoordinate:kingX - 1 and:kingY - 2])
        [possibleKnights addObject:[self getPieceAt:kingX - 1 with:kingY - 2]];
    
    
    for(int i = 0; i < [possibleKnights count]; i++)
        if([possibleKnights[i] isKnight] && [self isOppColor:king and:possibleKnights[i]])
            return true;
    
    return false;
}

-(BOOL) isAttacked:(Piece*) p {
    if([self isAttackedHorizontal:p])
        return true;
    else {
        if([self isAttackedDiagonal:p])
            return true;
        else {
            if([self isAttackedByKnight:p])
                return true;
            else
                return false;
        }
    }
    return false;
}

-(BOOL) isChecked {
    
    Piece* king;
    if(terms == 1)
        king = [self getWhiteKing];
    else if(terms == 2)
        king = [self getBlackKing];
    else
        ;
    NSLog(@"king is %@ at (%d,%d)\n",[king getName],[king getX],[king getY]);
    return [self isAttacked:king];

//    for (NSMutableArray *i in pieceSet) {
//        for (Piece * p in i){
//            if([p getSide] == [king getSide]){
//                if([self validateMove:p to:king]){
//                    NSLog(@"white king checked by %@(%d,%d)",[p getName],[p getX],[p getY]);
//                    return true;
//                }
//            }
//        }
//    }
//    return false;
}

// if piece colors are different and not empty.
-(BOOL) isOppColor: (Piece *) pi and :(Piece *)t {
    return ([t getSide] != [pi getSide] && ([t getSide] != 0));
}

-(BOOL) isSameColor: (Piece *)pi and :(Piece *)t {
    return [t getSide] == [pi getSide] ;
}


-(BOOL)blackPawnMove:(Piece *) pi to :(Piece *)t {
    if ([pi getY] == 6) {
        if ([self isOppColor:pi and:t]) {
            if (([t getY] == [pi getY] - 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1)))
                return true;
            
            else return false;
        }
        if ((([t getY] - [pi getY]) >= -2) && ([t getY] - [pi getY] < 0)&& ([t getX] - [pi getX] == 0))
            return true;
        
        else
            return false;
    }
    else {
        if ([self isOppColor:pi and:t]) {
            if (([t getY] == [pi getY] - 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1)))
                return true;
            
            else
                return false;
        }
        if ([t getY] - [pi getY] == -1 && ([t getX] - [pi getX] == 0)) {
            NSLog(@"regular move by black");
            return true;
        }
        else
            return false;
    }
    NSLog(@"unexpected!");
    return false;
}

-(BOOL)whitePawnMove:(Piece *) pi to :(Piece *)t {
    
    if ([pi getY] == 1) {
        if ([self isOppColor:pi and:t]) {
            
            if (([t getY] == [pi getY] + 1) && ([t getX] == ([pi getX] + 1) ||[t getX] == ([pi getX] - 1))) {
                NSLog(@"valid white pawn move");
                return true;
            }
            else {
                return false;
            }
        }
        else if ((([t getY] - [pi getY]) <= 2) && ([t getY] - [pi getY] > 0)&& ([t getX] - [pi getX] == 0)) {
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
                NSLog(@"valid white pawn eating move to skewed side");
                return true;
            }
            else {
                //NSLog(@"non original point unable to eat");
                return false;
            }
        }
        if ([t getY] - [pi getY] == 1 && ([t getX] - [pi getX] == 0)) {
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

// helper function to rookMove()
// TODO : implement queenMove with isPieceBlocked() for clarity.
-(BOOL)isValidrookMove:(Piece *)pi to : (Piece*) t {
    
    int startX = [pi getX];
    int startY = [pi getY];
    int endX = [t getX];
    int endY = [t getY];
    
    int xDiff = endX - startX;
    int yDiff = endY - startY;
    
//    NSLog(@"xDiff : %d \t yDiff : %d -- isValidrookMove\n",xDiff, yDiff);
    
    // all for loops within the inner if blocks are used to make sure that the piece is only going through
    // empty squares to reach the destination square.
    
    if((yDiff == 0) && (xDiff != 0)) {
        // rook is moving horizontal, along x axis
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
        // rook is moving vertical, along y axis
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

//rookMove for both colors
-(BOOL)rookMove:(Piece *)pi to :(Piece*)t {
    if(([pi getSide] != [t getSide]) && [self isValidrookMove:pi to:t]) {
//        NSLog(@"valid rook move ");
        return true;
    }
    else {
//        NSLog(@"invalid rook move");
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
    
//    NSLog(@"xDiff : %d \t yDiff : %d -- isValidBishopMove\n",xDiff, yDiff);
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
        //NSLog(@"valid bishop move ");
        return true;
    }
    else {
//        NSLog(@"invalid bishop move");
        return false;
    }
}

// helper function to knightMove()
-(BOOL)isValidKnightMove:(Piece *)pi to :(Piece*)t {
    
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
//    NSLog(@"xDiff : %d \t yDiff : %d -- isValidKnightMove\n",xDiff, yDiff);
    
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

-(BOOL)knightMove:(Piece *)pi to:(Piece *)t {
    if(([pi getSide] != [t getSide]) && [self isValidKnightMove:pi to:t]) {
//        NSLog(@"valid knight move ");
        return true;
    }
    else {
//        NSLog(@"invalid knight move");
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
//helper function for bishop moves
-(BOOL)isValidBishopMove1:(Piece *)pi to:(Piece *)t {
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
//    NSLog(@"xDiff : %d \t yDiff : %d\n",xDiff, yDiff);
    if (ABS(xDiff) == ABS(yDiff) && ![self isPieceBlocked:pi to:t]) {
        return true;
    }
    else {
//        NSLog(@"invalid bishop move");
        return false;
    }
}
//main function for checking bishop moves
-(BOOL)bishopMove1:(Piece *)pi to :(Piece *)t {
    if (([pi getSide] != [t getSide]) && [self isValidBishopMove:pi to:t]) {
//        NSLog(@"valid bishop move");
        return true;
    }
    else {
//        NSLog(@"invalid bishop move");
        return false;
    }
}
// helper function for queenMove();
// TODO : implement queenMove with isPieceBlocked() for clarity.
-(BOOL) isValidQueenMove:(Piece *)pi to: (Piece *)t {
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
//    NSLog(@"xDiff : %d \t yDiff : %d -- isValidQueenMove\n",xDiff, yDiff);
    
    if(![self isValidKnightMove:pi to:t]) {
        if(ABS(xDiff) == ABS(yDiff))
            return [self isValidBishopMove:pi to:t];
        else
            return [self isValidrookMove:pi to:t];
    }
    else {
//        NSLog(@"invalid queen move -- isValidQueenMove");
        return false;
    }
}

-(BOOL)queenMove:(Piece *)pi to :(Piece *)t {
    if (([pi getSide] != [t getSide]) && [self isValidQueenMove:pi to:t]) {
//        NSLog(@"valid queen move");
        return true;
    }
    else {
//        NSLog(@"invalid queen move -- queenMove");
        return false;
    }
}

-(BOOL)kingMove:(Piece *)pi to:(Piece *)t {
    //isCastlePiecesMoved --> initialized all to 1, if 1, meaning it has not moved yet.
        // LWR, WK, RWR
        // LBR, BK, RBR
    int xDiff = [t getX] - [pi getX];
    int yDiff = [t getY] - [pi getY];
    
    
    if ([pi getSide] != [t getSide] && (ABS(xDiff) <= 1 && ABS(yDiff) <= 1) && [self isValidCoordinate:[t getX] and:[t getY]]) {
//        NSLog(@"kingmove approved %d,%d",xDiff, yDiff);
        return true;
    }
    
    //check for castling.
    
    
    return false;
}

-(BOOL) isPermaChecked{
    for (NSMutableArray *i in pieceSet) {
        for (Piece *pi in i) {
            if ([pi getSide] == terms) {
                for (NSMutableArray *j in pieceSet) {
                    for (Piece *t in j) {
                        
                        if ([pi getSide] != [t getSide] && [self validateMove:pi to:t] && [self isUnchecked:pi to:t]) {
                            NSLog(@"*1%@(%d, %d) can be moved to %@(%d, %d) to uncheck", [pi getName],[pi getX],[pi getY],[t getName],[t getX],[t getY]);
                            return false;
                        }
                    }
                }
            }
        }
    }
    NSLog(@"%d is perma checked", terms);
    return true;
}

-(BOOL) isUnchecked:(Piece *)pi to:(Piece *)t {
    if ([pi getSide] == [t getSide]) {
        return false;
    }
    NSLog(@"isunchecked.");
    int tempSideT = [t getSide];
    int tempSideP = [pi getSide];
    NSMutableString *tempNameP = [NSMutableString stringWithString:[pi getName]];
    NSMutableString *tempNameT = [NSMutableString stringWithString:[t getName]];
    [t setName:[pi getName]];
    [pi setName:[NSMutableString stringWithString:@"empty"]];
    [t setSide:[pi getSide]];
    [pi setSide:0];
    if ([self isChecked] ) {
        [t setSide:tempSideT];
        [t setName:tempNameT];
        [pi setSide:tempSideP];
        [pi setName:tempNameP];
        NSLog(@"ischecked return false");
        return false;
    }
    else {
        [t setSide:tempSideT];
        [t setName:tempNameT];
        [pi setSide:tempSideP];
        [pi setName:tempNameP];
        NSLog(@"isunchecked return true");
        return true;
    }
    
}
//requrieMove ~ validating moves ?
-(BOOL) validateMove:(Piece *) pi to:(Piece *)t {
    //    if (isDebug == 1) {
    //        return true;
    //    }

    if ([pi isPawn]) {
        if([pi getSide] == 1) {
            if([self whitePawnMove:pi to:t]) {
                //NSLog(@"valid white pawn move");
                return true;
            }
            else return false;
        }
        else if([pi getSide] == 2) {
            if([self blackPawnMove:pi to:t]) {
                //NSLog(@"valid black pawn move");
                return true;
            }
            else return false;
        }
        else
            ;
    }
    else if ([pi isKing]) {
        if ([self kingMove:pi to:t]) {
            return true;
        }
        return false;
    }
    else if([pi isQueen]) {
        if ([self queenMove:pi to:t]) {

            return true;
        }
        else return false;
    }
    else if([pi isBishop]) {
        if ([self bishopMove:pi to:t]) {

            return true;
        }
        return false;
    }
    else if([pi isKnight]) {
        if ([self knightMove:pi to:t]) {
            return true;
        }
        return false;
    }
    else if([pi isRook]) {
        if ([self rookMove:pi to:t]) {
            return true;
        }
        return false;
    }
    else {
        NSLog(@"unexpected");
        return false;
    }
    return false;
}

-(BOOL) bot_validateMove:(Piece *) p to:(Piece *)t {
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
-(BOOL) comparePoints:(BoardPoint *)x to:(BoardPoint *)y {
    if (x.x  == y.x && x.y == y.y) {
        return true;
    }
    else {
        return false;
    }
    
}

-(NSMutableArray *)AvailableMovesForOnePiece:(Piece *)pi{
    NSMutableArray *availableMovesArray = [[NSMutableArray alloc] init];
    NSLog(@"in availabie moves %@ requiring ava moves", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide]) {
//                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                if ([self validateMove:pi to:t]) {
//                    NSLog(@"#2%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                    [availableMovesArray addObject:pi];
                    [availableMovesArray addObject:t];
                    
                }
            }
        }
    }
    return availableMovesArray;
}
@end
