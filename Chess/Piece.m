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
@synthesize value;
//0, is empty, 1 is white, 2 is black
@synthesize side;
@synthesize hasMoved;
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //    [aCoder encodeObject:self.pieceSet forKey:@"PROPERTY_KEY"];
    //    [aCoder encodeObject:self.isCastlePiecesMoved forKey:@"PROPERTY_KEY"];
    //    [aCoder encodeObject:self.checkingPieces forKey:@"PROPERTY_KEY"];
    [aCoder encodeObject:self forKey:@"PROPERTY_KEY"];
    //    [aCoder encodeObject:self.isCastled forKey:@"PROPERTY_KEY"];
    
    
    
}

-(id) copyWithZone:(NSZone *)zone {
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self = [aDecoder decodeObjectForKey:@"PROPERTY_KEY"];
        
        //        self.pieceSet = [aDecoder decodeObjectForKey:@"PROPERTY_KEY"];
        //        self.isCastlePiecesMoved = [aDecoder decodeObjectForKey:@"PROPERTY_KEY"];
        //        self.checkingPieces = [aDecoder decodeObjectForKey:@"PROPERTY_KEY"];
        
    }
    return self;
}
-(id) initWithImg:(UIImageView *)image and:(int)X with:(int)Y {
    self = [super init];
    self.img = image;
    self.hasMoved = 0;
    [self setLocation:X with:Y];
    return self;
}
-(id) initWithImg:(UIImageView *) image and:(NSMutableString *) name with:(int)X with:(int)Y with:(int)Side{
    self = [super init];
    self.img = image;
    [self setLocation:X with:Y];
    self.name = name;
    self.side = Side;
    self.hasMoved = 0;
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

-(double) getRelativeValue {
    return self.relativeValue;
}
-(Piece *)copyWithSelf
{
    // We'll ignore the zone for now
    Piece *another = [[Piece alloc] initWithImg:[self getImage] and:[self getName] with:[self getX] with:[self getY] with:[self getSide]];
    [another setRelativeValue:[self getRelativeValue]];
    another.hasMoved = self.hasMoved;
    return another;
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

-(NSString *) printInformation {
    NSLog(@"%@(%d,%d) side %d(value:%.2f)",[self getName], [self getX],[self getY], [self getSide],[self getRelativeValue]);
    return [NSString stringWithFormat:@"%@(%d,%d) side %d(value:%.2f)",[self getName], [self getX],[self getY], [self getSide],[self getRelativeValue]];
}

-(NSString *) printLocation{
    return [NSString stringWithFormat:@"(%d, %d)", [self getX]+1, [self getY]+1];
    
}


-(BOOL) isRook {
    if([self.getName rangeOfString:@"rook"].location != NSNotFound)
        return true;
    else return false;
}

-(BOOL) isQueen {
    if([self.getName rangeOfString:@"queen"].location != NSNotFound)
        return true;
    else return false;
}

-(BOOL) isPawn {
    if([self.getName rangeOfString:@"pawn"].location != NSNotFound)
        return true;
    else return false;
}

-(BOOL) isBishop {
    if([self.getName rangeOfString:@"bishop"].location != NSNotFound)
        return true;
    else return false;
}

-(BOOL) isKnight {
    if([self.getName rangeOfString:@"knight"].location != NSNotFound)
        return true;
    else return false;
}

-(BOOL) isKing {
    if([self.getName rangeOfString:@"king"].location != NSNotFound)
        return true;
    else return false;
}
-(BOOL) isEmpty {
    if([self.getName rangeOfString:@"empty"].location != NSNotFound)
        return true;
    else return false;
}
-(BOOL) hasPieceMoved {
    if (self.hasMoved == 0) {
        return false;
    }
    else {
        return true;
    }
}
-(BOOL) isWhite {
    if (side == 1) {
        return true;
    }
    else return false;
}
-(BOOL) isBlack {
    if (side == 2) {
        return true;
    }
    else return false;
}
@end
