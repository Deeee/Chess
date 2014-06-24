//
//  BoardPoint.h
//  Chess
//
//  Created by Liu Di on 6/23/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
@interface BoardPoint : NSObject
@property int x;
@property int y;

-(id) initWith:(int)x and:(int)y;
-(id) initWith:(Piece *)pi;
@end
