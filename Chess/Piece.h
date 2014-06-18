//
//  Piece.h
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Piece : NSObject
@property int VertLoc, ParaLoc;
@property UIImageView *img;
@property NSMutableString *name;
@property int side;
//Init
-(id) initWithImg:(UIImageView *) image and:(int)Vertical with:(int)Parallel;
-(id) initWithImg:(UIImageView *) image and:(NSMutableString *) name with:(int)Vertical with:(int)Parallel with:(int)Side;
//Setter
-(void) setLocation:(int)Vertical with:(int)Parallel;
-(void) setSide:(int)side;
-(void) setImg:(UIImageView *)image and:(NSMutableString *) name and:(int)Side;
//Getter
-(int) getParallel;
-(int) getVertical;
-(UIImageView *) getImage;
-(NSMutableString *) getName;
@end
