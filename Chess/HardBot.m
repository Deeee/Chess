//
//  HardBot.m
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "HardBot.h"

@implementation HardBot
@synthesize manual;
@synthesize pawnValue;
-(void) botMove {
    if ([self isInCheck] == 2) {
        [self eliminateThreate];
    }
    if ([self scriptMove]) {
        
    }
    else {
        
    }
}
-(void) normalMove {
    NSMutableArray *edible = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p getSide] == 2) {
                for (NSMutableArray *j in self.pieceSet) {
                    for (Piece *t in j) {
                        if ([t getSide] == 1) {
                            if ([self validateMove:p to:t] && [self isUnchecked:p to:t]) {
                                [edible addObject:p];
                                [edible addObject:t];
                            }
                        }
                    }
                }
            }
        }
    }
    NSMutableArray *beEaten = [[NSMutableArray alloc]init];
}

-(void)eliminateThreate {
    if ([self.checkingPieces count] == 1) {
        Piece *cp = [self.checkingPieces objectAtIndex:0];
        for (NSMutableArray *i in self.pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 2) {
                    if ([self validateMove:p to:cp]) {
                        [self botMoveFrom:p to:cp];
                    }
                }
            }
        }
    }
    else {
        Piece *myKing = [self getBlackKing];
        for (NSMutableArray *i in self.pieceSet) {
            for (Piece *t in i) {
                if ([t getSide] != 2) {
                    if ([self isUnchecked:myKing to:t] && [self validateMove:myKing to:t]) {
                        [self botMoveFrom:myKing to:t];
                    }
                }
            }
        }
    }

}
-(BOOL) scriptMove {
    NSArray *readin = [manual outputScript];
    Piece *pi = [self getPieceAt:[[readin objectAtIndex:0] boardPointGetX] with:[[readin objectAtIndex:0] boardPointGetY]];
    Piece *t = [self getPieceAt:[[readin objectAtIndex:1] boardPointGetX] with:[[readin objectAtIndex:1] boardPointGetY]];
    if ([self validateMove:pi to:t]) {
        [self botMoveFrom:pi to:t];
        return true;
    }
    return false;
}

-(void) botMoveFrom:(Piece *)p to:(Piece *)t {
    NSLog(@"in bot move");
    UIImageView *tempImage2 = [t getImage];
    UIImageView *tempImage = [p getImage];
    NSLog(@"%@ take over %@, from %d %d, to %d %d",[p getName],[t getName],[p getX], [p getY],[t getX],[t getY]);
    [self imageTakeOver:tempImage takeOver:tempImage2];
    [t setName:[p getName]];
    [p setName: [NSMutableString stringWithFormat: @"empty"]];
    [t setSide:[p getSide]];
    [p setSide:0];
    
}

-(id) init{
    self = [super init];
    NSLog(@"initing hard board");
    manual = [[ChessManual alloc] initWithManualName:@"stoneWall" and:2];
    return self;
}
-(void) changeTerms {
    NSLog(@"in hard bot attack moves");
    //If there are unconfirmed move, reject term changing request.
    if ([self.undecidedMove count] == 0) {
        return;
    }
    
    if (self.terms == 1) {
        NSLog(@"yes term equals to 1");
        self.undecidedReturnTrue = 0;
        [self.undecidedMove removeAllObjects];
        self.terms = 2;
        [self checkStatus];
        [self botMove];
        self.terms = 1;
        return;
    }
    NSLog(@"change term error!");
    //    else {
    //        self.undecidedReturnTrue = 0;
    //        [self.undecidedMove removeAllObjects];
    //        self.terms = 1;
    //    }
}

-(void) addRelativeValue {
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece * p in i) {
            if ([[p getName] rangeOfString:@"pawn"].location != NSNotFound) {
                [p setRelativeValue:1];
            }
            else if ([[p getName] rangeOfString:@"knight"].location != NSNotFound) {
                [p setRelativeValue:3.2];
            }
            else if ([[p getName] rangeOfString:@"bishop"].location != NSNotFound) {
                [p setRelativeValue:3.33];
            }
            else if ([[p getName] rangeOfString:@"rook"].location != NSNotFound) {
                [p setRelativeValue:5.1];
            }
            else if ([[p getName] rangeOfString:@"queen"].location != NSNotFound) {
                [p setRelativeValue:8.8];
            }
            else if([[p getName] rangeOfString:@"king"].location != NSNotFound) {
                [p setRelativeValue:10];
            }
        }
    }
    pawnValue = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        NSMutableArray *subArray = [[NSMutableArray alloc] init];
        for (int j = 1; j < 8; i++) {
            [subArray addObject:0];
            if (i == 0 || i == 7) {
                if (j == 4) {
                    [subArray addObject:[NSNumber numberWithFloat:0.97]];
                }
                else if (j == 5) {
                    [subArray addObject:[NSNumber numberWithFloat:1.06]];
                }
                else {
                    [subArray addObject:[NSNumber numberWithFloat:0.9]];
                }
            }
            else if (i == 2 || i == 6) {
                if (j == 4) {
                    [subArray addObject:[NSNumber numberWithFloat:1.03]];
                }
                else if (j == 5) {
                    [subArray addObject:[NSNumber numberWithFloat:1.12]];
                }
                else {
                    [subArray addObject:[NSNumber numberWithFloat:0.95]];
                }
            }
            else if (i == 3 || i == 5) {
                if (j == 4) {
                    [subArray addObject:[NSNumber numberWithFloat:1.17]];
                }
                else if (j == 5) {
                    [subArray addObject:[NSNumber numberWithFloat:1.25]];
                }
                else if (j == 3) {
                    [subArray addObject:[NSNumber numberWithFloat:1.10]];
                }
                else {
                    [subArray addObject:[NSNumber numberWithFloat:1.05]];
                }
            }
            else {
                if (j == 4) {
                    [subArray addObject:[NSNumber numberWithFloat:1.27]];
                }
                else if (j == 5) {
                    [subArray addObject:[NSNumber numberWithFloat:1.40]];
                }
                else if (j == 3) {
                    [subArray addObject:[NSNumber numberWithFloat:1.20]];
                }
                else if (j == 2) {
                    [subArray addObject:[NSNumber numberWithFloat:1.15]];
                }
                else {
                    [subArray addObject:[NSNumber numberWithFloat:1.10]];
                }
            }
        }
    }
    
}

-(void) refreshRelativeValue {
    //depending on opening or ending refreshing pawn's value
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece * p in i) {
            if ([[p getName] rangeOfString:@"pawn"].location != NSNotFound) {
                
            }
        }
    }
    
}
@end
