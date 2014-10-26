//
//  HardBot.h
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "BoardViewController.h"
#import "ChessManual.h"
@interface HardBot : Board
@property ChessManual *manual;
@property Piece *botTempRook;
@property Piece *oriTempRook;
@property Piece *imagineP;
@property Piece *imagineT;
@property int ifThink;
-(NSString *) botMove;
-(NSString *) scriptMove:(NSArray *)readin;
-(void) changeTerms;
-(void) botMoveFrom:(Piece *)p to:(Piece *)t;
-(double)thinkAhead:(Piece *)p to:(Piece *)t;

//-(void) imagineMove:(Piece *)p to:(Piece *)t;
//-(void) undoImagineMove:(Piece *)p to:(Piece *)t;
-(HardBot *) imagineMoveOnBoard:(Piece *)p to:(Piece *)t;
-(HardBot *) copySelf;
-(void) pieceTakeoverFrom:(Piece *)p to:(Piece *)t;
-(NSMutableArray *)getAllMoves:(int)side;
-(NSMutableArray *) findBestMove:(NSMutableArray *)allMoves;
-(NSMutableArray *)bestMoveForOnePiece:(NSMutableArray *)allMoves Steps:(int)step;
-(int) boardEvaluationPiece:(Piece *) pi isCastled:(int)isCastled isEndGame:(int)isEndGame bishopCount:(int)bishopCount insufficientMaterial:(int)insuffcientMaterial;
-(int) totalBoardValue:(int)side;

-(Piece *) getPieceAt:(int)X with:(int)Y;
@end
