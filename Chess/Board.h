//
//  Board.h
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "LinearEquation.h"
#import "Player.h"
#import "BoardPoint.h"

@interface Board : NSObject
@property NSMutableArray* pieceSet;
@property Piece *tempRook;
@property Piece *oriRook;
@property int terms;
@property Player *white;
@property Player *black;
@property int isInCheck;
@property NSMutableArray *undecidedMove;
@property int undecidedReturnTrue;
@property NSMutableArray *isCastlePiecesMoved;
@property int mode;
@property NSMutableArray *checkingPieces;
@property int isCastled;

-(BOOL) setMove:(Piece *) p to:(Piece *)t and:(int)isDebug;
-(void) setPieceOnBoard:(int)X with:(int)Y with:(Piece *)p;

-(void) changeTerms;

-(BOOL) validateMove:(Piece *) pi to:(Piece *)t;
-(BOOL) comparePoints:(BoardPoint *)x to:(BoardPoint *)y;
-(BOOL) isOppColor: (Piece *) pi and :(Piece *)t;
-(BOOL) isAbleToPromote:(Piece *) pi to:(Piece *) t;
-(void) imageTakeOver:(UIImageView *) a takeOver:(UIImageView *)b;
-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b;
-(BOOL) isValidCoordinate:(int)x and :(int)y;

-(BOOL)blackPawnMove:(Piece *) pi to :(Piece *)t;
-(BOOL)whitePawnMove:(Piece *) pi to :(Piece *)t;

-(BOOL)knightMove:(Piece *)pi to :(Piece *)t;
-(BOOL)isValidKnightMove:(Piece *)pi to :(Piece*)t;

-(BOOL)isValidBishopMove:(Piece *)pi to:(Piece *)t;
-(BOOL)bishopMove:(Piece *)pi to :(Piece *)t;

-(BOOL) isAttacked:(Piece*)piece and :(int) color;
-(BOOL) isAttackedHorizontal:(Piece*)piece and :(int) color;
-(BOOL) isAttackedDiagonal:(Piece*)piece and :(int)color;
-(BOOL) isAttackedByKnight:(Piece*)piece and :(int) color;

-(void) debugMove:(Piece *)p to:(Piece *)t;
-(BOOL) isChecked;
-(BOOL) isUnchecked:(Piece *)pi to:(Piece *)t;
-(BOOL) isPermaChecked;
-(void) checkStatus;

-(NSString *) getImageNameFromPiece:(Piece *)p;
-(Piece *) getPieceAt:(int)X with:(int)Y;
-(NSMutableArray *) getPieceSet;
-(NSMutableArray *) AvailableMovesForOnePiece:(Piece *)pi;
-(BOOL)kingCanCastle:(Piece *)pi to :(Piece *)t;
-(void) castlingMove:(Piece *)p to:(Piece *)t;

-(Piece *)getWhiteKing;
-(Piece *)getBlackKing;
@end
