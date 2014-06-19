//
//  Player.h
//  Chess
//
//  Created by Liu Di on 6/19/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property int side;
-(id) initWithSide:(int) s;
@end
