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
@property int terms;
@property Player *white;
@property Player *black;
@property int isInCheck;
@property NSMutableArray *undecidedMove;
@property int undecidedReturnTrue;
-(BOOL) setMove:(Piece *) p to:(Piece *)t and:(int)isDebug;
-(BOOL) requireMove:(Piece *) pi to:(Piece *)t;
-(void) setPieceOnBoard:(int)X with:(int)Y with:(Piece *)p;
-(NSMutableArray *) getPieceSet;
-(void) imageTakeOver:(UIImageView *) a takeOver:(UIImageView *)b;
-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b;
-(BOOL) isAbleToBecomeQueenFor:(Piece *) pi to:(Piece *) t;
-(BOOL) isOppColor: (Piece *) pi and :(Piece *)t;
-(Piece *) getPieceAt:(int)X with:(int)Y;
-(void) changeTerms;


-(BOOL)blackPawnMove:(Piece *) pi to :(Piece *)t;
-(BOOL)whitePawnMove:(Piece *) pi to :(Piece *)t;

-(BOOL)knightMove:(Piece *)pi to :(Piece *)t;
-(BOOL)isValidKnightMove:(Piece *)pi to :(Piece*)t;

-(BOOL)isValidBishopMove:(Piece *)pi to:(Piece *)t;
-(BOOL)bishopMove:(Piece *)pi to :(Piece *)t;

-(void) debugMove:(Piece *)p to:(Piece *)t;
-(BOOL) isChecked;
-(BOOL) isUnchecked:(Piece *)pi to:(Piece *)t;
-(BOOL) isPermaChecked;
-(void) checkStatus;
-(BOOL) comparePoints:(BoardPoint *)x to:(BoardPoint *)y;


-(Piece *)getWhiteKing;
-(Piece *)getBlackKing;
@end
