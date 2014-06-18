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
-(void) setMove:(int)Vertical with:(int)Parallel with:(Piece *)des;
-(BOOL) requrieMove:(int)Vertical with:(int)Parallel with:(Piece *)p;
-(void) setPieceOnBoard:(int)Vertical with:(int)Parallel with:(Piece *)p;
-(NSMutableArray *) getPieceSet;
@end
