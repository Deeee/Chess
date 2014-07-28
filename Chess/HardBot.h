//
//  HardBot.h
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Board.h"
#import "ChessManual.h"

@interface HardBot : Board<NSCopying>
@property ChessManual *manual;
@property Piece *botTempRook;
@property Piece *oriTempRook;
@property Piece *imagineP;
@property Piece *imagineT;
@property int imagineCastleMoveCheck;
@property int steps;
-(void) botMove;
-(BOOL) scriptMove;
-(void) changeTerms;
-(void) botMoveFrom:(Piece *)p to:(Piece *)t;
-(double)thinkAhead:(Piece *)p to:(Piece *)t;

//-(void) imagineMove:(Piece *)p to:(Piece *)t;
//-(void) undoImagineMove:(Piece *)p to:(Piece *)t;
-(HardBot *) imagineMoveOnBoard:(Piece *)p to:(Piece *)t;
-(HardBot *) copySelf;
-(void) pieceTakeoverFrom:(Piece *)p to:(Piece *)t;
-(NSMutableArray *)getAllMoves;
-(NSMutableArray *)bestMoveForOnePiece:(NSMutableArray *)allMoves Steps:(int)step;
@end
