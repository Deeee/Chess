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
-(void) setMove:(Piece *) p to:(Piece *)t;
-(BOOL) requrieMove:(Piece *) p to:(Piece *)t;
-(void) setPieceOnBoard:(int)Vertical with:(int)Parallel with:(Piece *)p;
-(NSMutableArray *) getPieceSet;
@end
