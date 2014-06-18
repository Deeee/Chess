//
//  Piece.m
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Piece.h"

@implementation Piece
@synthesize x, y;
@synthesize img;
@synthesize side;



-(id) initWithImg:(UIImageView *)image and:(int)X with:(int)Y {
    self = [super init];
    self.img = image;
    [self setLocation:X with:Y];
    return self;
}
-(id) initWithImg:(UIImageView *) image and:(NSMutableString *) name with:(int)X with:(int)Y with:(int)Side{
    self = [super init];
    self.img = image;
    [self setLocation:X with:Y];
    self.name = name;
    self.side = Side;
    return self;
}

-(int) getY{
    return self.y;
}

-(int) getX{
    return self.x;
}

-(UIImageView *) getImage {
    //printf("in piece get image\n");
    return self.img;
}
-(NSMutableString *) getName {
    return self.name;
}

-(int) getSide {
    return self.side;
}

-(void) setImg:(UIImageView *)image and:(NSMutableString *) name and:(int)Side{
    self.img = image;
    self.name = name;
    self.side = Side;
}


-(void) setLocation:(int)X with:(int)Y {
    x = X;
    y = Y;
}


@end
