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
        Piece *p = [self getPieceAt:i with:tempY--];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;
        }
    }
    // up right attacks
    tempY = [bishop getY];
    for(int i = [bishop getX]; i < 9; i++) {
        Piece * p = [self getPieceAt:i with:tempY++];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;

        }
    }
    // down left attacks
    int tempX = [bishop getX];
    for(int i = [bishop getY]; i < 9; i++) {
        Piece* p = [self getPieceAt:tempX-- with:i];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            [attackCombo addObject:p];
            return attackCombo;

        }
    }
    // down right attacks
    tempX = [bishop getX];
    for(int i = [bishop getY]; i > -1; i--) {
        Piece* p = [self getPieceAt:tempX++ with:i];
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
    for(int i = [rook getX]; i < 9; i++) {
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
    for(int i = [rook getY]; i < 9; i++) {
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
    
    int kingY = [king getY]; int kingX = [king getX];
    
    Piece* kingMoves[] = {
        [self getPieceAt:kingX + 1 with:kingY],
        [self getPieceAt:kingX - 1 with:kingY],
        [self getPieceAt:kingX with:kingY + 1],
        [self getPieceAt:kingX with:kingY - 1],
        [self getPieceAt:kingX +1 with:kingY + 1],
        [self getPieceAt:kingX +1 with:kingY - 1],
        [self getPieceAt:kingX -1 with:kingY + 1],
        [self getPieceAt:kingX -1 with:kingY - 1],
    };
    
    for(int i = 0; i < 8; i++) {
        if([self isOnBoard:kingMoves[i]] && [self isOppColor:king and:kingMoves[i]]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",kingMoves[i], [kingMoves[i] getX], [kingMoves[i] getY],king, [king getX], [king getY]);
            [attackCombo addObject:kingMoves[i]];
            return attackCombo;
        }
    }
    return NULL;
}

-(NSMutableArray *)findKnightAttack : (Piece*) knight {
    
    int knightY = [knight getY]; int knightX = [knight getX];
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:knight];
    Piece* knightMoves[] = {
        [self getPieceAt:knightX + 2 with:knightY + 1],
        [self getPieceAt:knightX + 2 with:knightY - 1],
        [self getPieceAt:knightX - 2 with:knightY + 1],
        [self getPieceAt:knightX - 2 with:knightY - 1],
        
        [self getPieceAt:knightX + 1 with:knightY + 2],
        [self getPieceAt:knightX + 1 with:knightY - 2],
        [self getPieceAt:knightX - 1 with:knightY + 2],
        [self getPieceAt:knightX - 1 with:knightY - 2],
    };

    for(int i = 0; i < 8; i++) {
        if([self isOnBoard:knightMoves[i]] && [self isOppColor:knight and:knightMoves[i]]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",knightMoves[i], [knightMoves[i] getX], [knightMoves[i] getY],knight, [knight getX], [knight getY]);
//            return knightMoves[i];
            [attackCombo addObject:knightMoves[i]];
            return attackCombo;
        }
    }
    return NULL;
}

-(NSMutableArray *) findWhitePawnAttack : (Piece*) pawn {
    
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:pawn];
    
    if([pawn getX] == 0) {
        // upper right pawn
        Piece* leftDiag = [self getPieceAt:[pawn getX] + 1 with:[pawn getY] + 1];
        if([self isOppColor:pawn and:leftDiag] || [self isOnBoard:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:leftDiag];
            return attackCombo;
        }
    }
    else if([pawn getX] == 7) {
        // upper left pawn
        Piece* rightDiag = [self getPieceAt:[pawn getX] - 1 with: [pawn getY] + 1];
        if([self isOppColor:pawn and:rightDiag] && [self isOnBoard:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:rightDiag];
            return attackCombo;
        }
    }
    else {
        // all other pawns.
        Piece* leftDiag = [self getPieceAt:[pawn getX] + 1 with:[pawn getY] + 1];
        if([self isOppColor:pawn and:leftDiag] && [self isOnBoard:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:leftDiag];
            return attackCombo;
        }
        Piece* rightDiag = [self getPieceAt:[pawn getX] - 1 with: [pawn getY] + 1];
        if([self isOppColor:pawn and:rightDiag] && [self isOnBoard:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:rightDiag];
            return attackCombo;
        }
    }
    return NULL;
}
-(NSMutableArray *) findBlackPawnAttack : (Piece*) pawn {
    
    NSMutableArray* attackCombo = [[NSMutableArray alloc] initWithCapacity:2];
    [attackCombo addObject:pawn];
    
    if([pawn getX] == 0) {
        //bottom right pawn
        Piece* rightDiag = [self getPieceAt:[pawn getX] + 1 with: [pawn getY] -1 ];
        if([self isOppColor:pawn and:rightDiag] && [self isOnBoard:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:rightDiag];
            return attackCombo;
        }
    }
    else if([pawn getX] == 7) {
        //bottom left pawn
        Piece* leftDiag = [self getPieceAt:[pawn getX] - 1 with:[pawn getY] - 1];
        if([self isOppColor:pawn and:leftDiag] && [self isOnBoard:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:leftDiag];
            return attackCombo;
        }
    }
    else {
        // all other pawns.
        Piece* rightDiag = [self getPieceAt:[pawn getX] + 1 with: [pawn getY] -1 ];
        if([self isOppColor:pawn and:rightDiag] && [self isOnBoard:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:rightDiag];
            return attackCombo;
        }
        
        Piece* leftDiag = [self getPieceAt:[pawn getX] - 1 with:[pawn getY] - 1];
        if([self isOppColor:pawn and:leftDiag] && [self isOnBoard:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            [attackCombo addObject:leftDiag];
            return attackCombo;
        }
    }
    
    return NULL;
}

// finds a random move given the bot's color.
-(NSMutableArray *) findRandomMove :(int) color {
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *pi in i) {
            //check pieces only of the same color as the bot.
            if([pi getSide] == color) {
                NSMutableArray *availableMoves = [self AvailableMovesForOnePiece:pi];
                // if availableMoves has size of 0, move to the next piece in the for loop.
                if([availableMoves count] == 0)
                    continue;
                NSMutableArray *randomMove = [[NSMutableArray alloc] init];
                [randomMove addObject:[availableMoves  objectAtIndex:0]];
                [randomMove addObject:[availableMoves objectAtIndex:1]];                
                return randomMove;
            }
        }
    }
    return NULL;
}

@end
