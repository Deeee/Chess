//
//  Board.h
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
@interface Board : NSObject
@property NSMutableArray* pieceSet;
@property int terms;
-(void) setMove:(Piece *) p to:(Piece *)t;
-(BOOL) requrieMove:(Piece *) p to:(Piece *)t;
-(void) setPieceOnBoard:(int)X with:(int)Y with:(Piece *)p;
-(NSMutableArray *) getPieceSet;
-(void) imageTakeOver:(UIImageView *) a takeOver:(UIImageView *)b;
-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b;
-(BOOL) isAbleToBecomeQueenFor:(Piece *) pi to:(Piece *) t;
@end
