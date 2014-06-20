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
-(Piece *) findAttack : (int) color;
-(Piece *) findWhitePawnAttack : (Piece*) pawn;
-(Piece *) findBlackPawnAttack : (Piece*) pawn;
-(Piece *)findRookAttack : (Piece*)rook;
@end
