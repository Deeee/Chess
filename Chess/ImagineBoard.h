//
//  ImagineBoard.h
//  Chess
//
//  Created by Liu Di on 11/14/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagineBoard : NSObject
@property BOOL isWhiteCastled;
@property BOOL isBlackCastled;
@property int isInCheck;
@property int ifThink;
@end
