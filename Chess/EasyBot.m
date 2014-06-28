//
//  EasyBot.m
//  Chess
//
//  Created by Rohan Barman on 6/20/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "EasyBot.h"
// I am in the refactor branch right now.
@implementation EasyBot


// findAttack will return the first found instance of an attackCombo
    // an attack combo is an attacker piece (a)  and an enemy piece (e)
    // a is of the bot's color and e is of opposite color.
    // a and e are the first instance of an attackCombo - It is the first found in the for loop thus it is not necessarily the best attackCombo.

// Simple Implementation for EasyBot ...
    // If findAttack() returns a non NULL array, call setMove or a similar move function for Bot with (a) and (e).
        // (a) will move to eat (e).
    // Else findAttack() returns NULL which means that there is currently no such attackCombos on the current board scenario.
        // have a randomMove().
-(NSMutableArray *) findAttack : (int) color {
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *pi in i) {
            if([pi getSide] == 3 - color) {
                if([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
                    if([pi getSide] == 1)
                        return [self findWhitePawnAttack:pi];
                    else
                        return [self findBlackPawnAttack:pi];
                }
                else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {
                    return [self findKingAttack:pi];
                }
                else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {
                    return [self findQueenAttack:pi];
                }
                else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
                    return [self findBishopAttack:pi];
                }
                else if([pi.getName rangeOfString:@"rook"].location != NSNotFound) {
                    return [self findRookAttack:pi];
                }
                else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {
                    return [self findKnightAttack:pi];
                }
            }
            else {
                // this piece has same color as Color, do not search
            }
        }
    }
    return NULL;
}

-(NSMutableArray*)findQueenAttack: (Piece*)queen {
    NSMutableArray* array = [self findBishopAttack:queen];
    if(array != NULL)
        return array;
    else {
        array = [self findRookAttack:queen];
        if(array != NULL)
            return array;
        else
            return NULL;
    }
}

-(NSMutableArray*)findBishopAttack :(Piece*)bishop {
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:bishop];
    
    
    // up left attacks
    int tempY = [bishop getY];
    for(int i = [bishop getX]; i > -1; i--) {
        int place = tempY --;
        if(place < 0)
            break;
        Piece *p = [self getPieceAt:i with:place];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    // up right attacks
    tempY = [bishop getY];
    for(int i = [bishop getX]; i < 8; i++) {
        int place = tempY++;
        if(place > 7)
            break;
        Piece * p = [self getPieceAt:i with:place];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;

        }
    }
    // down left attacks
    int tempX = [bishop getX];
    for(int i = [bishop getY]; i < 8; i++) {
        int place = tempX --;
        if(place < 0)
            break;
        Piece* p = [self getPieceAt:place with:i];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;

        }
    }
    // down right attacks
    tempX = [bishop getX];
    for(int i = [bishop getY]; i > -1; i--) {
        int place = tempX ++;
        if(place < 7)
            break;
        Piece* p = [self getPieceAt:place with:i];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    return NULL;
}

-(NSMutableArray*)findRookAttack : (Piece*)rook {
    
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:rook];
    
    // left horizontal attacks
    for(int i = [rook getX]; i > -1; i--) {
        Piece* p = [self getPieceAt:i with:[rook getY]];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    // right horizontal attacks
    for(int i = [rook getX]; i <8; i++) {
        Piece* p = [self getPieceAt:i with:[rook getY]];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    // up vertical attacks
    
    for(int i = [rook getY]; i > -1; i--) {
        Piece* p = [self getPieceAt:[rook getX] with:i];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    
    // down vertical attacks
    for(int i = [rook getY]; i < 8; i++) {
        Piece* p = [self getPieceAt:[rook getX] with:i];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    return NULL;
}

// returns true if piece p has valid board coordinates : (9,1) is invald and returns false.
-(BOOL) isOnBoard : (Piece*) p {
    if(([p getX] < 0) || ([p getY] > 8))
        return false;
    else
        return true;
}

-(NSMutableArray*) findKingAttack : (Piece*) king {
    
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:king];
    NSMutableArray* kingMoves = [[NSMutableArray alloc] init];
    
    
    int kingX = [king getX];
    int kingY = [king getY];
    
    if([self isValidCoordinate:kingX + 1 and:kingY])
        [kingMoves addObject:[self getPieceAt:kingX + 1 with:kingY]];
    if([self isValidCoordinate:kingX - 1 and:kingY])
        [kingMoves addObject:[self getPieceAt:kingX - 1 with:kingY]];
    if([self isValidCoordinate:kingX and:kingY + 1])
        [kingMoves addObject:[self getPieceAt:kingX with:kingY + 1]];
    if([self isValidCoordinate:kingX and:kingY - 1])
        [kingMoves addObject:[self getPieceAt:kingX with:kingY - 1]];
    if([self isValidCoordinate:kingX + 1 and:kingY + 1])
        [kingMoves addObject:[self getPieceAt:kingX + 1 with:kingY + 1]];
    if([self isValidCoordinate:kingX + 1 and:kingY - 1])
        [kingMoves addObject:[self getPieceAt:kingX + 1 with:kingY - 1]];
    if([self isValidCoordinate:kingX - 1 and:kingY + 1])
        [kingMoves addObject:[self getPieceAt:kingX - 1 with:kingY + 1]];
    if([self isValidCoordinate:kingX - 1 and:kingY - 1])
        [kingMoves addObject:[self getPieceAt:kingX - 1 with:kingY - 1]];

    for(int i = 0; i < [kingMoves count]; i++) {
        if([self isOppColor:king and:[kingMoves objectAtIndex:i]]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",kingMoves[i], [kingMoves[i] getX], [kingMoves[i] getY],king, [king getX], [king getY]);
            [attackCombo addObject:[kingMoves objectAtIndex:i]];
            return attackCombo;
        }
    }
    return NULL;
}

-(NSMutableArray *)findKnightAttack : (Piece*) knight {

    int knightX = [knight getX];
    int knightY = [knight getY];

    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:knight];
    NSMutableArray* knightMoves = [[NSMutableArray alloc] init];
    
    if([self isValidCoordinate:knightX + 1 and:knightY])
        [knightMoves addObject:[self getPieceAt:knightX + 1 with:knightY]];
    if([self isValidCoordinate:knightX - 1 and:knightY])
        [knightMoves addObject:[self getPieceAt:knightX - 1 with:knightY]];
    if([self isValidCoordinate:knightX and:knightY + 1])
        [knightMoves addObject:[self getPieceAt:knightX with:knightY + 1]];
    if([self isValidCoordinate:knightX and:knightY - 1])
        [knightMoves addObject:[self getPieceAt:knightX with:knightY - 1]];
    if([self isValidCoordinate:knightX + 1 and:knightY + 1])
        [knightMoves addObject:[self getPieceAt:knightX + 1 with:knightY + 1]];
    if([self isValidCoordinate:knightX + 1 and:knightY - 1])
        [knightMoves addObject:[self getPieceAt:knightX + 1 with:knightY - 1]];
    if([self isValidCoordinate:knightX - 1 and:knightY + 1])
        [knightMoves addObject:[self getPieceAt:knightX - 1 with:knightY + 1]];
    if([self isValidCoordinate:knightX - 1 and:knightY - 1])
        [knightMoves addObject:[self getPieceAt:knightX - 1 with:knightY - 1]];

    
    for(int i = 0; i < [knightMoves count]; i++)
        if([self isOppColor:knight and:[knightMoves objectAtIndex:i]]){
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",knightMoves[i], [knightMoves[i] getX], [knightMoves[i] getY],knight, [knight getX], [knight getY]);
            [attackCombo addObject:knightMoves[i]];
            return attackCombo;

        }
    return NULL;
}

-(NSMutableArray *) findWhitePawnAttack : (Piece*) pawn {
    
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:pawn];
    int x, y;
    
    // check eating to right.
    x = [pawn getX] + 1;
    y = [pawn getY] + 1;
    
    if([self isValidCoordinate:x and:y]){
        Piece * p = [self getPieceAt:x with:y];
        if([self isOppColor:pawn and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    
    // check eating to left
    x = [pawn getX] - 1;
    y = [pawn getY] + 1;
    
    if([self isValidCoordinate:x and:y]){
        Piece * p = [self getPieceAt:x with:y];
        if([self isOppColor:pawn and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    return NULL;
}
-(NSMutableArray *) findBlackPawnAttack : (Piece*) pawn {
    
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:pawn];
    int x, y;
    
    //check eating to right.
    x = [pawn getX] + 1;
    y = [pawn getY] - 1;
    if([self isValidCoordinate:x and:y]){
        Piece * p = [self getPieceAt:x with:y];
        if([self isOppColor:pawn and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    
    //check eating to left.
     x = [pawn getX] - 1;
     y = [pawn getY] - 1;
    
    if([self isValidCoordinate:x and:y]){
        Piece * p = [self getPieceAt:x with:y];
        if([self isOppColor:pawn and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    
    
    return NULL;
}

// finds a random move given the bot's color.
-(NSMutableArray *) findRandomMove :(int) color {
    
    NSMutableArray * randomMove = [[NSMutableArray alloc]init];
    NSMutableArray * botPieces = [[NSMutableArray alloc]init];
    
    for (NSMutableArray *i in [self getPieceSet])
        for (Piece *pi in i)
            //check pieces only of the same color as the bot.
            if([pi getSide] == color)
                [botPieces addObject:pi];
    
    Piece* randomPiece;
    NSMutableArray *availableMoves;
    int numMoves = 1;
    // while loop will get a randomPiece and set available moves, making sure that the randomPiece has available moves.
    while(true) {
        NSLog(@"in while loop 1");
        randomPiece = [botPieces objectAtIndex:arc4random_uniform([botPieces count])];
        availableMoves = [self AvailableMovesForOnePiece:randomPiece];
        numMoves = [availableMoves count];
        if(numMoves > 0)
            break;
    }
    
    int randNum = 2 * arc4random_uniform( numMoves/ 2);
    
    [randomMove addObject:[availableMoves objectAtIndex:randNum]];
    [randomMove addObject:[availableMoves objectAtIndex:randNum + 1]];
    return randomMove;
}
-(void) changeTerms {
    NSLog(@"in easy bot attack moves");
    //If there are unconfirmed move, reject term changing request.
    if ([self.undecidedMove count] == 0) {
        return;
    }
    if (self.terms == 1) {
        NSLog(@"yes term equals to 1");
        self.undecidedReturnTrue = 0;
        [self.undecidedMove removeAllObjects];
        self.terms = 2;
        NSMutableArray *attackMoves = [self findRandomMove:2];
        [[attackMoves objectAtIndex:0] printInformation];
        [[attackMoves objectAtIndex:1] printInformation];
        [self botMoveFrom:[attackMoves objectAtIndex:0] to:[attackMoves objectAtIndex:1]];
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
@end
