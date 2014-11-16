//
//  ImaginePiece.h
//  Chess
//
//  Created by Liu Di on 11/14/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImaginePiece : NSObject
@property int x, y;
@property int side;
@property double relativeValue;
@property int hasMoved;
@property NSString *name;

@end
