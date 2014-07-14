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
@synthesize botTempRook;
@synthesize oriTempRook;
@synthesize imagineP;
@synthesize imagineT;
@synthesize imagineCastleMoveCheck;
-(void) botMove {
    [self addRelativeValue];
//    [self normalMove];
    if ([self isInCheck] == 2) {
        [self eliminateThreate];
    }
//    else if ([self scriptMove]) {
//        
//    }
    else {
        NSLog(@"start normal move!");
        [self normalMove];
    }
}
//imagine move doesnt do castle moves ##
-(BOOL)isTakenInMove:(Piece *)pi to:(Piece *)tp {
    
    int isTaken = 0;
    [self imagineMove:pi to:tp];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if (isTaken == 0 && ([t getSide] != [tp getSide]) && ([t getSide] != 0)) {
                if ([self validateMove:t to:tp] && [self isUnchecked:t to:tp]) {
                    isTaken = 1;
                }
            }
        }
    }
    [self undoImagineMove:tp to:pi];
    if (isTaken == 1) {
        NSLog(@"%@(%d,%d) will be taken by others in the move to %@(%d,%d)",[pi getName],[pi getX],[pi getY],[tp getName],[tp getX],[tp getY]);
        return true;
    }
    else return false;
}

-(NSMutableArray *)isGuardingPiece:(Piece *)pi{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if ([t getSide] == 2) {
                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi]) {
                    [tempArray addObject:t];
                }
            }
        }
    }
    return tempArray;
}

-(BOOL)isSafeTaking:(Piece *)pi and:(Piece *)t {
    if (!([self validateMove:t to:pi] && [self isUnchecked:t to:pi])) {
        return true;
    }
    else return false;
}

-(NSMutableArray *)isTakingPiece:(Piece *)pi {
    NSLog(@"in is taking piece for %@(%d,%d)",[pi getName],[pi getX],[pi getY]);
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] && [t getSide] != 0) {
                if ([self validateMove:pi to:t] && [self isUnchecked:pi to:t] && [self isSafeTaking:pi and:t] && ![self isTakenInMove:pi to:t]) {
                    [tempArray addObject:t];
                }
            }
        }
    }
    return tempArray;
}
//-(BOOL)isWorthTaken:(Piece *)pi to:(Piece *)t {
//    if ([pi getSide] == [t getSide]) {
//        return false;
//    }
//    NSLog(@"isWorthTaken.");
//    int tempSideT = [t getSide];
//    int tempSideP = [pi getSide];
//    NSMutableString *tempNameP = [NSMutableString stringWithString:[pi getName]];
//    NSMutableString *tempNameT = [NSMutableString stringWithString:[t getName]];
//    [t setName:[pi getName]];
//    [pi setName:[NSMutableString stringWithString:@"empty"]];
//    [t setSide:[pi getSide]];
//    [pi setSide:0];
//    NSMutableArray *isTakenArray = [self isGettingTaken:pi];
//    NSMutableArray *isGuardArray = [self isGuardingPiece:pi];
//    if ([isTakenArray count] == 0 ) {
//        [t setSide:tempSideT];
//        [t setName:tempNameT];
//        [pi setSide:tempSideP];
//        [pi setName:tempNameP];
//        NSLog(@"ischecked return false");
//        return false;
//    }
//    else {
//        [t setSide:tempSideT];
//        [t setName:tempNameT];
//        [pi setSide:tempSideP];
//        [pi setName:tempNameP];
//        NSLog(@"isunchecked return true");
//        return true;
//    }
//}
//-(BOOL) isUnchecked:(Piece *)pi to:(Piece *)t {
//    NSLog(@"isunchecked.");
//    
////    int tempSideT = [t getSide];
////    int tempSideP = [pi getSide];
////    NSMutableString *tempNameP = [NSMutableString stringWithString:[pi getName]];
////    NSMutableString *tempNameT = [NSMutableString stringWithString:[t getName]];
////    [t setName:[pi getName]];
////    [pi setName:[NSMutableString stringWithString:@"empty"]];
////    [t setSide:[pi getSide]];
////    [pi setSide:0];
//    
//    [self imagineMove:pi to:t];
//    if ([self isChecked] ) {
//        [self undoImagineMove:t to:pi];
//        //NSLog(@"ischecked return false");
//        return false;
//    }
//    else {
//        [self undoImagineMove:t to:pi];
//        //NSLog(@"isunchecked return true");
//        return true;
//    }
//    
//}


-(void) imagineMove:(Piece *)p to:(Piece *)t {
    imagineP = [p copyWithSelf];
    imagineT = [t copyWithSelf];
    if (([[p getName] rangeOfString:@"king"].location != NSNotFound) && [self kingCanCastle:p to:t]) {
        [self botCastlingMove:p to:t];
        imagineCastleMoveCheck = 1;
    } else {
        [t setName:[p getName]];
        [p setName:[NSMutableString stringWithString:@"empty"]];
        [t setSide:[p getSide]];
        [p setSide:0];
        [t setRelativeValue:[p getRelativeValue]];
        [p setRelativeValue:0];
    }


}

-(void) undoImagineMove:(Piece *)p to:(Piece *)t {
    if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && imagineCastleMoveCheck == 1) {
        [self botUndoCastling];
        imagineCastleMoveCheck = 0;
    }
    [p setName:[imagineT getName]];
    [t setName:[imagineP getName]];
    [p setSide:[imagineT getSide]];
    [t setSide:[imagineP getSide]];
    [p setRelativeValue:[imagineT getRelativeValue]];
    [t setRelativeValue:[imagineP getRelativeValue]];
}
-(void) imagineMoveSingle:(Piece *)p to:(Piece *)t {
        [t setName:[p getName]];
        [p setName:[NSMutableString stringWithString:@"empty"]];
        [t setSide:[p getSide]];
        [p setSide:0];
        [t setRelativeValue:[p getRelativeValue]];
        [p setRelativeValue:0];
    
}
-(void) botCastlingMove:(Piece *)p to:(Piece *)t{
    Piece *movingRook = [self getAccordingRook:p to:t];
    botTempRook = movingRook;
    int _x = [t getX];
    NSLog(@"in bot castling move t x is %d", [t getX]);
    if (_x > 4) {
        NSLog(@"_x bigger > 4");
        Piece *des = [self getPieceAt:([t getX] - 1) with:[p getY]];
        oriTempRook = des;
        [self imagineMoveSingle:movingRook to:des];
    }
    else {
        Piece *des = [self getPieceAt:([t getX]+1) with:[p getY]];
        oriTempRook = des;
        [self imagineMoveSingle:movingRook to:des];
    }
    [self imagineMoveSingle:p to:t];
    
}

-(void) botUndoCastling{
    NSLog(@"in bot undoCastling");
    [[self getPieceAt:0 with:7] printInformation];
    int botSide = [botTempRook getSide];
    int oriSide = [oriTempRook getSide];
    NSMutableString *botName = [NSMutableString stringWithString:[botTempRook getName] ];
    NSMutableString *oriName = [NSMutableString stringWithString:[oriTempRook getName] ];
    double botValue = [botTempRook getRelativeValue];
    double oriValue = [oriTempRook getRelativeValue];
    [botTempRook setName:oriName];
    [oriTempRook setName: botName];
    [botTempRook setSide:oriSide];
    [oriTempRook setSide:botSide];
    [oriTempRook setRelativeValue:botValue];
    [botTempRook setRelativeValue:oriValue];
    [[self getPieceAt:0 with:7] printInformation];
    
}
-(double)thinkAhead:(Piece *)p to:(Piece *)t {
    NSLog(@"in think a head for p:%@(%d,%d) and t:%@(%d,%d)",[p getName],[p getX], [p getY], [t getName], [t getX], [t getY]);
    [[self getPieceAt:0 with:7] printInformation];

    int castleCheck = 0;
    double sumOfTaking = 0;
    
    if (([t getSide] != [p getSide]) && ([t getSide] != 0)) {
        sumOfTaking += [t getRelativeValue];
    }
//    NSMutableArray *changes = [[NSMutableArray alloc] init];
//    [changes addObject:[p copyWithSelf]];
//    [changes addObject:[t copyWithSelf]];
    NSMutableString *pName = [NSMutableString stringWithString:[p getName]];
    NSMutableString *tName = [NSMutableString stringWithString:[t getName]];
    int pSide = [p getSide];
    int tSide = [t getSide];
    double pValue = [p getRelativeValue];
    double tValue = [t getRelativeValue];
    if (([[p getName] rangeOfString:@"king"].location != NSNotFound) && [self kingCanCastle:p to:t]) {
        [self botCastlingMove:p to:t];
        castleCheck = 1;
    } else {
        [t setName:[p getName]];
        [p setName:[NSMutableString stringWithString:@"empty"]];
        [t setSide:[p getSide]];
        [p setSide:0];
        [t setRelativeValue:[p getRelativeValue]];
        [p setRelativeValue:0];
    }
    NSLog(@"finish botcastling");
    
    [[self getPieceAt:0 with:7] printInformation];
    
    NSMutableArray *isTakingArray = [self isTakingPiece:t];

    for (Piece *temp in isTakingArray) {
        NSLog(@"%@(%d,%d) is taking %@(%d,%d)",[t getName],[t getX],[t getY],[temp getName],[temp getX],[temp getY]);
        sumOfTaking += [temp getRelativeValue];
    }
    if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && castleCheck) {
        [self botUndoCastling];
    }
//        Piece *tempP = [changes objectAtIndex:0];
//        Piece *tempT = [changes objectAtIndex:1];
        [p setName:pName];
        [p setSide:pSide];
        [t setName:tName];
        [t setSide:tSide];
    [p setRelativeValue:pValue];
    [t setRelativeValue:tValue];
    [[self getPieceAt:0 with:7] printInformation];
    NSLog(@"sumOfTaking is %.2f",sumOfTaking);
    return sumOfTaking;
    
}

-(BOOL)inspectCurrent:(Piece *)p to:(Piece *)t {
    NSLog(@"inspectCurrent %@(%d,%d) to %@(%d,%d)",[p getName],[p getX],[p getY],[t getName],[t getX],[t getY]);
    int castleCheck = 0;
    int isTaking = 0;
    int takingValue = 0;
    int selfValue = [p getRelativeValue];
    if ([t getSide] != [p getSide] && [t getSide] != 0) {
        isTaking = 1;
        takingValue = [t getRelativeValue];
    }
    
    NSMutableString *pName = [NSMutableString stringWithString:[p getName]];
    NSMutableString *tName = [NSMutableString stringWithString:[t getName]];
    int pSide = [p getSide];
    int tSide = [t getSide];
    double pValue = [p getRelativeValue];
    double tValue = [t getRelativeValue];
    
    if (([[p getName] rangeOfString:@"king"].location != NSNotFound) && [self kingCanCastle:p to:t]) {
        [self botCastlingMove:p to:t];
        castleCheck = 1;
    } else {
        [t setName:[p getName]];
        [p setName:[NSMutableString stringWithString:@"empty"]];
        [t setSide:[p getSide]];
        [p setSide:0];
        [t setRelativeValue:[p getRelativeValue]];
        [p setRelativeValue:0];
    }
    if (isTaking && [self isTaken:t]) {
        if (selfValue <= takingValue) {
            if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && castleCheck == 1) {
                [self botUndoCastling];
            }
            [p setName:pName];
            [p setSide:pSide];
            [t setName:tName];
            [t setSide:tSide];
            [p setRelativeValue:pValue];
            [t setRelativeValue:tValue];
            NSLog(@"inspectCurrent %@(%d,%d) to %@(%d,%d) return true takingtaken",[p getName],[p getX],[p getY],[t getName],[t getX],[t getY]);

            return true;
        }
        else {
            if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && castleCheck) {
                [self botUndoCastling];
            }
            [p setName:pName];
            [p setSide:pSide];
            [t setName:tName];
            [t setSide:tSide];
            [p setRelativeValue:pValue];
            [t setRelativeValue:tValue];
            NSLog(@"inspectCurrent %@(%d,%d) to %@(%d,%d) return false takingtaken",[p getName],[p getX],[p getY],[t getName],[t getX],[t getY]);

            return false;
        }
    }
    if ([self isTaken:t]) {
        if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && castleCheck) {
            [self botUndoCastling];
        }

        [p setName:pName];
        [p setSide:pSide];
        [t setName:tName];
        [t setSide:tSide];
        [p setRelativeValue:pValue];
        [t setRelativeValue:tValue];
        NSLog(@"inspectCurrent %@(%d,%d) to %@(%d,%d) return false taken",[p getName],[p getX],[p getY],[t getName],[t getX],[t getY]);

        return false;
    }
    else {
        if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && castleCheck) {
            [self botUndoCastling];
        }
        [p setName:pName];
        [p setSide:pSide];
        [t setName:tName];
        [t setSide:tSide];
        [p setRelativeValue:pValue];
        [t setRelativeValue:tValue];
        NSLog(@"inspectCurrent %@(%d,%d) to %@(%d,%d) return true no one take",[p getName],[p getX],[p getY],[t getName],[t getX],[t getY]);

        return true;
    }
}
//Improve: if anypieces can be taken atm without danger, take it
-(NSMutableArray *)bestMoveForOnePiece:(NSMutableArray *)allMoves {
    NSLog(@"in best move for one piece %@, count %d",[[allMoves objectAtIndex:0] getName], [allMoves count]);
    NSMutableArray *bestMoves = [[NSMutableArray alloc] init];
    
    double maxValue = 0;
    int maxIndex = 0;
    
    for (int i = 0; i < [allMoves count]; i += 2) {
        if ([self inspectCurrent:[allMoves objectAtIndex:i] to:[allMoves objectAtIndex:i + 1]]) {
            double temp = [self thinkAhead:[allMoves objectAtIndex:i] to:[allMoves objectAtIndex:i + 1]];
            if (i == 0) {
                maxValue = temp;
                maxIndex = i;
            }
            else {
                if (temp > maxValue) {
                    maxValue = temp;
                    maxIndex = i;
                }
            }
        }

//        [sums addObject:[NSNumber numberWithDouble:[self thinkAhead:[bestMoves objectAtIndex:i] to:[bestMoves objectAtIndex:i + 1]] ]];
    }
    [bestMoves addObject:[allMoves objectAtIndex:maxIndex]];
    [bestMoves addObject:[allMoves objectAtIndex:maxIndex + 1]];
    [bestMoves addObject:[NSNumber numberWithDouble:maxValue]];
    NSLog(@"best move for piece %@(%d,%d) is to %@(%d,%d) with value of %.2f, maxIndex is %d",[[allMoves objectAtIndex:maxIndex] getName],[[allMoves objectAtIndex:maxIndex] getX],[[allMoves objectAtIndex:maxIndex] getY],[[allMoves objectAtIndex:maxIndex + 1] getName],[[allMoves objectAtIndex:maxIndex + 1] getX],[[allMoves objectAtIndex:maxIndex + 1] getY], maxValue, maxIndex);
    return bestMoves;
}

-(BOOL)isTaken:(Piece *)pi{
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if (([t getSide] != [pi getSide]) && ([t getSide] != 0)) {
                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi]) {
                    return true;
                }
            }
        }
    }
    return false;
}

-(NSMutableArray *) boardTotalLosingValue:(int)side{
    NSLog(@"boardtotallosingvalue");
    NSMutableArray *results = [[NSMutableArray alloc] init];
    Piece *maxLosePiece;
    double maxLose = 0;
    int count = 0;
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p getSide] == side) {
                if (count == 0) {
                    maxLosePiece = p;
                }
                if (([p getRelativeValue] > maxLose) &&  [self isTaken:p]) {
                    maxLose = [p getRelativeValue];
                    maxLosePiece = p;
                }
                count ++;
            }
        }
    }
    [results addObject:maxLosePiece];
    [results addObject:[NSNumber numberWithDouble:maxLose]];
    //posible return nil of maxlosetaken
    NSLog(@"finish boardtotallosingvalue");
    return results;
}

//-(NSMutableArray *)guardPiece:(Piece *)p{
//    double bestMoveValue = 0;
//    Piece *bestMoveP;
//    Piece *bestMoveT;
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    for (NSMutableArray *i in self.pieceSet) {
//        for (Piece *t in i) {
//            if ([t getSide] == [p getSide]) {
//                NSMutableArray *avaForOne = [self AvailableMovesForOnePiece:t];
//                for (Piece *trial in avaForOne) {
//                    if (![[trial getName] isEqualToString:[t getName]]) {
//                        int trialSide = [trial getSide];
//                        NSString *trialName = [NSString stringWithString:[trial getName] ];
//                        int tSide = [t getSide];
//                        NSString *tName = [NSString stringWithString:[t getName]];
//                        [trial setName:[t getName]];
//                        [t setName:[NSMutableString stringWithString:@"empty"]];
//                        [t setSide:[trial getSide]];
//                        [p setSide:0];
//                        if ([self validateMove:trial to:p] && [self isUnchecked:trial to:p]) {
//                            double tempThinkAheadValue = [self thinkAhead:trial to:p];
//                            if (tempThinkAheadValue > bestMoveValue ) {
//                                //TODO:GUARD MOVES
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    return result;
//}

-(NSMutableArray *)AvailableMovesForLosePiece:(Piece *)pi{
    NSMutableArray *availableMovesArray = [[NSMutableArray alloc] init];
    NSLog(@"in availabie moves for lose piece %@ requiring ava moves", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] ) {
                //                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                if ([self validateMove:pi to:t] &&  [self isUnchecked:pi to:t] && ![self isTakenInMove:pi to:t]) {
                                        NSLog(@"#2%@(%d,%d) approved for lose piece move",[t getName],[t getX],[t getY]);
                    
                    [availableMovesArray addObject:pi];
                    [availableMovesArray addObject:t];
                    
                }
            }
        }
    }
    return availableMovesArray;
}

-(NSMutableArray *) losePieceMove:(Piece *)losePice{
    NSMutableArray *result;
    NSLog(@"in losepiece for piece %@(%d,%d)",[losePice getName],[losePice getX],[losePice getY]);
    NSMutableArray *losePieceMoves = [self AvailableMovesForLosePiece:losePice];
    if ([losePieceMoves count] == 0) {
        result = [[NSMutableArray alloc] init];
        return result;
    }
    result = [self bestMoveForOnePiece:losePieceMoves];
    return result;
}
// need a backup move
-(NSMutableArray *) findBestMove:(NSMutableArray *)allMoves {
    NSLog(@"in find best move");
    double maxValue = 0;
    double maxIndex = 0;
    int count = 0;
    NSMutableArray *maxLose = [self boardTotalLosingValue:2];
    NSMutableArray *maxMove = [allMoves objectAtIndex:0];
    for (NSMutableArray *allMoveOnePiece in allMoves) {
        NSMutableArray *tempArray =[self bestMoveForOnePiece:allMoveOnePiece];
        double tempDouble = [[tempArray objectAtIndex:2] doubleValue];
        if (count == 0) {
            maxValue = tempDouble;
            maxIndex = count;
            maxMove = [allMoves objectAtIndex:0];

        }
        else {
            if (tempDouble > maxValue) {
                maxValue = tempDouble;
                maxIndex = count;
                maxMove = tempArray;
            }
        }
        count ++;
    }
    double maxLoseValue = [[maxLose objectAtIndex:1] doubleValue];
    NSLog(@"bestMoveValue:%.2f, maxlosevalue:%.2f",maxValue,maxLoseValue);
    NSLog(@"bestMove is %@(%d,%d) to %@(%d,%d) with value %.2f",[[maxMove objectAtIndex:0] getName],[[maxMove objectAtIndex:0] getX],[[maxMove objectAtIndex:0] getY],[[maxMove objectAtIndex:1] getName],[[maxMove objectAtIndex:1] getX],[[maxMove objectAtIndex:1] getY], maxValue);
    NSLog(@"-----------------------------");
    if (maxLoseValue > maxValue) {
        NSLog(@"preparing for losingmove");
        Piece *losePiece = [maxLose objectAtIndex:0];
        NSMutableArray *losePieceMove = [self losePieceMove:losePiece];
        if ([losePieceMove count] == 0) {
            return maxMove;
        }
        return losePieceMove;
    }
    else {
        NSLog(@"not in losingmove");
        return maxMove;

    }
    NSLog(@"unexpected");
    return nil;
}
-(NSMutableArray *)AvailableMovesForOnePiece:(Piece *)pi{
    NSMutableArray *availableMovesArray = [[NSMutableArray alloc] init];
    NSLog(@"in availabie moves %@ requiring ava moves", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] ) {
                //                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                if ([self validateMove:pi to:t] &&  [self isUnchecked:pi to:t] && ![self isTakenInMove:pi to:t]) {
                    //                    NSLog(@"#2%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                    
                    [availableMovesArray addObject:pi];
                    [availableMovesArray addObject:t];
                    
                }
            }
        }
    }
    return availableMovesArray;
}
-(void) normalMove {
    NSLog(@"in normal move");
    NSMutableArray *avaMoves = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p getSide] == 2) {
                NSMutableArray *tempArray = [self AvailableMovesForOnePiece:p];
                if ([tempArray count] != 0) {
                    [avaMoves addObject:[self AvailableMovesForOnePiece:p]];

                }
            }
        }
    }
    NSLog(@"finishing gathering all ava moves");
    NSMutableArray *bestMove = [self findBestMove:avaMoves];
    [self botMoveFrom:[bestMove objectAtIndex:0] to:[bestMove objectAtIndex:1]];
    
}
//It miss checked checking piece
-(void)eliminateThreate {
    NSLog(@"in eliminateThreate");
    if ([self.checkingPieces count] == 1) {
        NSLog(@"checking piece equal to 1");
        Piece *cp = [self.checkingPieces objectAtIndex:0];
        for (NSMutableArray *i in self.pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 2) {
                    if ([self validateMove:p to:cp] && [self isUnchecked:p to:cp]) {
                        [self botMoveFrom:p to:cp];
                        return;
                    }
                }
            }
        }
        //do somethign like move king away over here
        Piece *myKing = [self getBlackKing];
        for (NSMutableArray *i in self.pieceSet) {
            for (Piece *t in i) {
                if ([t getSide] != 2) {
                    if ([self isUnchecked:myKing to:t] && [self validateMove:myKing to:t]) {
                        [self botMoveFrom:myKing to:t];
                        return;
                    }
                }
            }
        }
    }
    else {
        NSLog(@"more than one checking piece");
        Piece *myKing = [self getBlackKing];
        for (NSMutableArray *i in self.pieceSet) {
            for (Piece *t in i) {
                if ([t getSide] != 2) {
                    if ([self isUnchecked:myKing to:t] && [self validateMove:myKing to:t]) {
                        [self botMoveFrom:myKing to:t];
                        return;
                    }
                }
            }
        }
    }

}
-(BOOL) scriptMove {
    NSArray *readin = [manual outputScript];
    if (readin == nil) {
        return false;
    }
    Piece *pi = [self getPieceAt:[[readin objectAtIndex:0] boardPointGetX] with:[[readin objectAtIndex:0] boardPointGetY]];
    Piece *t = [self getPieceAt:[[readin objectAtIndex:1] boardPointGetX] with:[[readin objectAtIndex:1] boardPointGetY]];
    if (([pi getSide] != [t getSide]) && [self validateMove:pi to:t] && [self isUnchecked:pi to:t] && ([self thinkAhead:pi to:t] >= [[[self boardTotalLosingValue:2] objectAtIndex:1] doubleValue])) {
        NSLog(@"scriptMove calling bot move from");
//        [[self getPieceAt:0 with:7] printInformation];
        [self botMoveFrom:pi to:t];
        return true;
    }
    else {
        [self normalMove];
        return true;
    }
    return false;
}

-(void) botMoveFrom:(Piece *)p to:(Piece *)t {
    NSLog(@"in bot move for %@(%d,%d) to %@(%d,%d)", [p getName], [p getX], [p getY], [t getName],[t getX], [t getY]);

    if (([[p getName] rangeOfString:@"king"].location != NSNotFound) && [self kingCanCastle:p to:t]) {
        [[self getPieceAt:0 with:7] printInformation];
        [self castlingMove:p to:t];
        return;
        
    }
    UIImageView *tempImage2 = [t getImage];
    UIImageView *tempImage = [p getImage];
    NSLog(@"%@(v:%.2f) take over %@(v:%.2f), from %d %d, to %d %d",[p getName],[p getRelativeValue],[t getName],[t getRelativeValue],[p getX], [p getY],[t getX],[t getY]);
    [self imageTakeOver:tempImage takeOver:tempImage2];
    [t setName:[p getName]];
    [p setName: [NSMutableString stringWithFormat: @"empty"]];
    [t setSide:[p getSide]];
    [p setSide:0];
    [t setRelativeValue:[p getRelativeValue]];
    [p setRelativeValue:0];
    
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
        [self.checkingPieces removeAllObjects];
        self.isInCheck = 0;
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
