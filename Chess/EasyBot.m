//
//  EasyBot.m
//  Chess
//
//  Created by Rohan Barman on 6/20/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "EasyBot.h"

@implementation EasyBot

// will return the first Piece* p that can be be attacked where p is of the opposite color of our side.
// returns NULL if there is no piece that can be attacked
// Uses : EasyBot will get p and setMove() with p.
-(Piece *) findAttack : (int) color {
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *pi in i) {
            if([pi getSide] == 3 - color) {
                if([pi.getName rangeOfString:@"pawn"].location != NSNotFound) {
                    if([pi getSide] == 1)
                        return [self findWhitePawnAttack:pi];
                    else
                        return [self findBlackPawnAttack:pi];
                }
                else if([pi.getName rangeOfString:@"king"].location != NSNotFound) {}
                else if([pi.getName rangeOfString:@"queen"].location != NSNotFound) {}
                else if([pi.getName rangeOfString:@"bishop"].location != NSNotFound) {
                    return [self findBishopAttack:pi];
                }
                else if([pi.getName rangeOfString:@"rook"].location != NSNotFound) {
                    return [self findRookAttack:pi];
                }
                else if([pi.getName rangeOfString:@"knight"].location != NSNotFound) {}
            }
            else {
                // this piece has same color as Color, do not search
            }
        }
    }
    return NULL;
}

-(Piece*)findBishopAttack :(Piece*)bishop {
    // up left attacks
    int tempY = [bishop getY];
    for(int i = [bishop getX]; i > -1; i--) {
        Piece *p = [self getPieceAt:i with:tempY--];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            return p;
        }
    }
    // up right attacks
    tempY = [bishop getY];
    for(int i = [bishop getX]; i < 9; i++) {
        Piece * p = [self getPieceAt:i with:tempY++];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            return p;
        }
    }
    // down left attacks
    int tempX = [bishop getX];
    for(int i = [bishop getY]; i < 9; i++) {
        Piece* p = [self getPieceAt:tempX-- with:i];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            return p;
        }
    }
    // down right attacks
    tempX = [bishop getX];
    for(int i = [bishop getY]; i > -1; i--) {
        Piece* p = [self getPieceAt:tempX++ with:i];
        if([self isOppColor:bishop and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],bishop, [bishop getX], [bishop getY]);
            return p;
        }
    }
    return NULL;
}

-(Piece *)findRookAttack : (Piece*)rook {
    // left horizontal attacks
    for(int i = [rook getX]; i > -1; i--) {
        Piece* p = [self getPieceAt:i with:[rook getY]];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            return p;
        }
    }
    // right horizontal attacks
    for(int i = [rook getX]; i < 9; i++) {
        Piece* p = [self getPieceAt:i with:[rook getY]];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            return p;
        }
    }
    // up vertical attacks
    
    for(int i = [rook getY]; i > -1; i--) {
        Piece* p = [self getPieceAt:[rook getX] with:i];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            return p;
        }
    }
    
    // down vertical attacks
    for(int i = [rook getY]; i < 9; i++) {
        Piece* p = [self getPieceAt:[rook getX] with:i];
        if([self isOppColor:rook and:p]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",p, [p getX], [p getY],rook, [rook getX], [rook getY]);
            return p;
        }
    }
    return NULL;
}

-(Piece *) findWhitePawnAttack : (Piece*) pawn {
    if([pawn getX] == 0) {
        // upper right pawn
        Piece* leftDiag = [self getPieceAt:[pawn getX] + 1 with:[pawn getY] + 1];
        if([self isOppColor:pawn and:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            return leftDiag;
        }
    }
    else if([pawn getX] == 7) {
        // upper left pawn
        Piece* rightDiag = [self getPieceAt:[pawn getX] - 1 with: [pawn getY] + 1];
        if([self isOppColor:pawn and:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            return rightDiag;
        }
    }
    else {
        // all other pawns.
        Piece* leftDiag = [self getPieceAt:[pawn getX] + 1 with:[pawn getY] + 1];
        if([self isOppColor:pawn and:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            return leftDiag;
        }
        Piece* rightDiag = [self getPieceAt:[pawn getX] - 1 with: [pawn getY] + 1];
        if([self isOppColor:pawn and:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            return rightDiag;
        }
    }
    return NULL;
}
-(Piece *) findBlackPawnAttack : (Piece*) pawn {
    
    if([pawn getX] == 0) {
        //bottom right pawn
        Piece* rightDiag = [self getPieceAt:[pawn getX] + 1 with: [pawn getY] -1 ];
        if([self isOppColor:pawn and:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            return rightDiag;
        }
    }
    else if([pawn getX] == 7) {
        //bottom left pawn
        Piece* leftDiag = [self getPieceAt:[pawn getX] - 1 with:[pawn getY] - 1];
        if([self isOppColor:pawn and:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            return leftDiag;
        }
    }
    else {
        // all other pawns.
        Piece* rightDiag = [self getPieceAt:[pawn getX] + 1 with: [pawn getY] -1 ];
        if([self isOppColor:pawn and:rightDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",rightDiag, [rightDiag getX], [rightDiag getY],pawn, [pawn getX], [pawn getY]);
            return rightDiag;
        }
        
        Piece* leftDiag = [self getPieceAt:[pawn getX] - 1 with:[pawn getY] - 1];
        if([self isOppColor:pawn and:leftDiag]) {
            NSLog(@"can attack %@ at (%d,%d)\t by %@ at (%d,%d)\n",leftDiag, [leftDiag getX], [leftDiag getY],pawn, [pawn getX], [pawn getY]);
            return leftDiag;
        }
    }
    
    return NULL;
}



@end
