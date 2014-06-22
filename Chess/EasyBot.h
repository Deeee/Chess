//
//  EasyBot.h
//  Chess
//
//  Created by Rohan Barman on 6/20/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Board.h"
#import <Foundation/Foundation.h>
#import "Piece.h"

@interface EasyBot : Board
-(NSMutableArray *) findAttack : (int) color;
-(NSMutableArray *) findWhitePawnAttack : (Piece*) pawn;
-(NSMutableArray *) findBlackPawnAttack : (Piece*) pawn;
-(NSMutableArray *)findRookAttack : (Piece*)rook;
-(NSMutableArray*)findBishopAttack :(Piece*)bishop;
-(NSMutableArray*)findQueenAttack: (Piece*)queen;
-(BOOL) isOnBoard : (Piece*) p;
-(NSMutableArray *)findKnightAttack : (Piece*) knight;
-(NSMutableArray*) findKingAttack : (Piece*) king;
@end
