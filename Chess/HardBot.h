//
//  HardBot.h
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Board.h"
#import "ChessManual.h"

@interface HardBot : Board
@property ChessManual *manual;
@property Piece *botTempRook;
@property Piece *oriTempRook;
@property Piece *imagineP;
@property Piece *imagineT;
@property int imagineCastleMoveCheck;
-(void) botMove;
-(BOOL) scriptMove;
-(void) changeTerms;
-(void) botMoveFrom:(Piece *)p to:(Piece *)t;
-(void) addRelativeValue;
-(double)thinkAhead:(Piece *)p to:(Piece *)t;
-(void) imagineMove:(Piece *)p to:(Piece *)t;
-(void) undoImagineMove:(Piece *)p to:(Piece *)t;
@end
