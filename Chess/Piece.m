//
//  Piece.m
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Piece.h"

@implementation Piece
@synthesize VertLoc, ParaLoc;
@synthesize img;
@synthesize side;



-(id) initWithImg:(UIImageView *)image and:(int)Vertical with:(int)Parallel {
    self = [super init];
    self.img = image;
    [self setLocation:Vertical with:Parallel];
    return self;
}
-(id) initWithImg:(UIImageView *) image and:(NSMutableString *) name with:(int)Vertical with:(int)Parallel with:(int)Side{
    self = [super init];
    NSLog(@"here!!!!!!!!!!");
    self.img = image;
    [self setLocation:Vertical with:Parallel];
    self.name = name;
    self.side = Side;
    return self;
}

-(int) getVertical{
    return self.VertLoc;
}

-(int) getParallel{
    return self.ParaLoc;
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


-(void) setLocation:(int)Vertical with:(int)Parallel {
    VertLoc = Vertical;
    ParaLoc = Parallel;
}


@end
