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


-(void) setLocation:(int)Vertical with:(int)Parallel {
    VertLoc = Vertical;
    ParaLoc = Parallel;
}

-(id) initWithImg:(UIImageView *)image and:(int)Vertical with:(int)Parallel {
    self = [super init];
    self.img = image;
    [self setLocation:Vertical with:Parallel];
    return self;
}
-(id) initWithImg:(UIImageView *) image and:(NSMutableString *) name with:(int)Vertical with:(int)Parallel{
    self = [super init];
    NSLog(@"here!!!!!!!!!!");
    self.img = image;
    [self setLocation:Vertical with:Parallel];
    self.name = name;
    return self;
}

-(int) getVertical{
    return self.VertLoc;
}

-(int) getParallel{
    return self.ParaLoc;
}

-(UIImageView *) getImage {
    return self.img;
}
-(void) setImg:(UIImageView *)image and:(NSMutableString *) name{
    self.img = image;
    self.name = name;
}

-(NSMutableString *) getName{
    return self.name;
}

@end
