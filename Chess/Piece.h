//
//  Piece.h
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Piece : NSObject <NSCopying>
@property int x, y;
@property UIImageView *img;
@property NSMutableString *name;
@property int side;
@property double relativeValue;
@property int hasMoved;
@property int value;
//Init
-(id) initWithImg:(UIImageView *) image and:(int)X with:(int)Y;
-(id) initWithImg:(UIImageView *) image and:(NSMutableString *) name with:(int)X with:(int)Y with:(int)Side;
//Setter
-(void) setLocation:(int)X with:(int)Y;
-(void) setSide:(int)side;
-(void) setImg:(UIImageView *)image and:(NSMutableString *) name and:(int)Side;
//Getter
-(int) getX;
-(int) getY;
-(UIImageView *) getImage;
-(NSMutableString *) getName;
-(Piece *)copyWithSelf;
-(int) getSide;
-(NSString *) printInformation;
-(double) getRelativeValue;
-(NSString *) printLocation;

-(BOOL) isPawn;
-(BOOL) isRook;
-(BOOL) isQueen;
-(BOOL) isBishop;
-(BOOL) isKnight;
-(BOOL) isKing;
-(BOOL) isEmpty;
-(BOOL) hasPieceMoved;
-(BOOL) isWhite;
-(BOOL) isBlack;
@end
