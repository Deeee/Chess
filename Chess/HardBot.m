//
//  HardBot.m
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "HardBot.h"

@implementation HardBot{
    int botSide;
}
@synthesize manual;
@synthesize botTempRook;
@synthesize oriTempRook;
@synthesize imagineP;
@synthesize imagineT;
@synthesize ifThink;
-(id) copyWithZone:(NSZone *)zone {
    return self;
}

-(id) init{
    self = [super init];
    manual = [[ChessManual alloc] initWithManualName:@"stoneWall" and:2];
    ifThink = 0;
    botSide = 2;
    return self;
}

-(NSString *) botMove {
    NSArray *readin = [manual outputScript];
    NSString *ret;
    [self addRelativeValue];
//    [self normalMove];
    if ([self isInCheck] == botSide) {
        ret = [self eliminateThreate];
    }
    else if (readin != nil) {
        ret = [self scriptMove:readin];
    }
    else {
        ret = [self normalMove:botSide];
    }
    return ret;
}
-(NSMutableArray *) copyPieceSet{
    NSMutableArray *copy = [[NSMutableArray alloc] initWithCapacity:8];
    Piece *temp;
    for (int i = 0; i < 8; i++) {
        NSMutableArray *v = [[NSMutableArray alloc] initWithCapacity:8];
        for (int j = 0;j < 8; j ++) {
            temp = [self getPieceAt:i with:j];
            Piece *copyPiece = [[Piece alloc] initWithImg:nil and:[temp getName] with:[temp getX] with:[temp getY] with:[temp getSide]];
            [copyPiece setRelativeValue:[temp getRelativeValue]];
            [v addObject:copyPiece];
        }
        [copy addObject:v];
    }
    return copy;
}

-(Piece *) getPieceAt:(int)X with:(int)Y {
    return [[self.pieceSet objectAtIndex:X] objectAtIndex:Y];
}

-(HardBot *) copySelf {

//    NSLog(@"in copyself");
    HardBot *copy = [[HardBot alloc] init];
    
    NSMutableArray *pieceSetCopy = [self copyPieceSet];
    copy.pieceSet = pieceSetCopy;
    copy.isCastled = self.isCastled;
    copy.isInCheck = self.isInCheck;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.pieceSet forKey:@"PROPERTY_KEY"];
//    [aCoder encodeObject:self.isCastlePiecesMoved forKey:@"PROPERTY_KEY"];
//    [aCoder encodeObject:self.checkingPieces forKey:@"PROPERTY_KEY"];
    [aCoder encodeObject:self forKey:@"PROPERTY_KEY"];
//    [aCoder encodeObject:self.isCastled forKey:@"PROPERTY_KEY"];



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
-(HardBot *) imagineMoveOnBoard:(Piece *)p to:(Piece *)t {
//    NSLog(@"imagineMoveOnBoard:%@ to %@",[p printInformation],[t printInformation]);
    HardBot *copy = [self copySelf];
    Piece *igP = [copy getPieceAt:[p getX] with:[p getY]];
    Piece *igT = [copy getPieceAt:[t getX] with:[t getY]];
//    NSLog(@"imagine move from %@ to %@",[p printInformation], [t printInformation]);
    [copy botMoveFrom:igP to:igT];
    return copy;
}

-(void)formation {
    Piece *random = [[self pieceSet] objectAtIndex:arc4random_uniform([[self pieceSet] count])];
    double value = -1;
    while (value < 0) {
        NSMutableArray *best = [self bestMoveForOnePiece:[self AvailableMovesForOnePiece:random] Steps:10];
        value = [[best objectAtIndex:2] doubleValue];
    }
    
}
//-(BOOL) isTakenB:(Piece *)pi{
//    return [super isTaken:pi];
//}

//imagine move doesnt do castle moves ##



-(BOOL)isSafeTaking:(Piece *)pi and:(Piece *)t {
    if (!([self validateMove:t to:pi] && [self isUnchecked:t to:pi])) {
        return true;
    }
    else return false;
}

-(NSMutableArray *)isTakingPiece:(Piece *)pi {
//    NSLog(@"isTakingPiece:%@",[pi printInformation]);
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int k = 0; k < [self.pieceSet count]; k++) {
        NSMutableArray *i = [self.pieceSet objectAtIndex:k];
        
    }
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] && [t getSide] != 0) {
                if ([self validateMove:pi to:t] && [self isUnchecked:pi to:t] && [self isSafeTaking:pi and:t] && ![self isTakenInMove:pi to:t] && [[self isGuardingPiece:t] count] == 0) {
                    [tempArray addObject:t];
                }
            }
        }
    }
    tempArray = [self sortPiecesInArray:tempArray];
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


//-(void) imagineMove:(Piece *)p to:(Piece *)t {
//    imagineP = [p copyWithSelf];
//    imagineT = [t copyWithSelf];
//    if (([[p getName] rangeOfString:@"king"].location != NSNotFound) && [self kingCanCastle:p to:t]) {
//        [self botCastlingMove:p to:t];
//        imagineCastleMoveCheck = 1;
//    } else {
//        [t setName:[p getName]];
//        [p setName:[NSMutableString stringWithString:@"empty"]];
//        [t setSide:[p getSide]];
//        [p setSide:0];
//        [t setRelativeValue:[p getRelativeValue]];
//        [p setRelativeValue:0];
//    }
//
//
//}

//-(void) undoImagineMove:(Piece *)p to:(Piece *)t {
//    if (([[t getName] rangeOfString:@"king"].location != NSNotFound) && imagineCastleMoveCheck == 1) {
//        [self botUndoCastling];
//        imagineCastleMoveCheck = 0;
//    }
//    [p setName:[imagineT getName]];
//    [t setName:[imagineP getName]];
//    [p setSide:[imagineT getSide]];
//    [t setSide:[imagineP getSide]];
//    [p setRelativeValue:[imagineT getRelativeValue]];
//    [t setRelativeValue:[imagineP getRelativeValue]];
//}
//-(void) imagineMoveSingle:(Piece *)p to:(Piece *)t {
//        [t setName:[p getName]];
//        [p setName:[NSMutableString stringWithString:@"empty"]];
//        [t setSide:[p getSide]];
//        [p setSide:0];
//        [t setRelativeValue:[p getRelativeValue]];
//        [p setRelativeValue:0];
//    
//}
-(void) botCastlingMove:(Piece *)p to:(Piece *)t{
    Piece *movingRook = [self getAccordingRook:p to:t];
    int _x = [t getX];
    if (_x > 4) {
        Piece *des = [self getPieceAt:([t getX] - 1) with:[p getY]];
        [self debugMove:movingRook to:des];
    }
    else {
        Piece *des = [self getPieceAt:([t getX]+1) with:[p getY]];
        [self debugMove:movingRook to:des];
    }
    [self debugMove:p to:t];
}

//-(void) botUndoCastling{
//    NSLog(@"in bot undoCastling");
//    [[self getPieceAt:0 with:7] printInformation];
//    int botSide = [botTempRook getSide];
//    int oriSide = [oriTempRook getSide];
//    NSMutableString *botName = [NSMutableString stringWithString:[botTempRook getName] ];
//    NSMutableString *oriName = [NSMutableString stringWithString:[oriTempRook getName] ];
//    double botValue = [botTempRook getRelativeValue];
//    double oriValue = [oriTempRook getRelativeValue];
//    [botTempRook setName:oriName];
//    [oriTempRook setName: botName];
//    [botTempRook setSide:oriSide];
//    [oriTempRook setSide:botSide];
//    [oriTempRook setRelativeValue:botValue];
//    [botTempRook setRelativeValue:oriValue];
//    [[self getPieceAt:0 with:7] printInformation];
//    
//}

-(double)simulate:(int)s lastValue:(double)v curBoard:(HardBot *)b{
    if (s == 2) {
        return v;
    }
    [b normalMove:(3 - botSide)];
    [b normalMove:botSide];
    NSLog(@"simulate! %d value:%f",s,v);
    return [b simulate:(s+1) lastValue:[b totalBoardValue:botSide] curBoard:b];
}

-(double)thinkAhead:(Piece *)p to:(Piece *)t {
    NSLog(@"thinkAhead:%@ to:%@",[p printInformation],[t printInformation]);
    HardBot *tempBoard = [self imagineMoveOnBoard:p to:t];
    tempBoard.ifThink = 0;
    Piece *tOnTempBoard = [tempBoard getPieceAt:[t getX] with:[t getY]];
    double boardValue = [tempBoard totalBoardValue:[tOnTempBoard getSide]];
    if (self.ifThink == 1) {
        NSLog(@"in simulate!!");
        return [self simulate:0 lastValue:boardValue curBoard:tempBoard];
    }
    else return boardValue;
}


//Improve: if anypieces can be taken atm without danger, take it
-(NSMutableArray *)bestMoveForOnePiece:(NSMutableArray *)allMoves Steps:(int)step{
//    NSLog(@"bestMoveForOnePiece:allMove:%lu",(unsigned long)[allMoves count]);
    NSMutableArray *bestMoves = [[NSMutableArray alloc] init];
    double maxValue = 0;
    int maxIndex = 0;
    
    for (int i = 0; i < [allMoves count]; i += 2) {
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
    [bestMoves addObject:[allMoves objectAtIndex:maxIndex]];
    [bestMoves addObject:[allMoves objectAtIndex:maxIndex + 1]];
    [bestMoves addObject:[NSNumber numberWithDouble:maxValue]];
//    NSLog(@"bestMoveForOnePiece %@(%d,%d) is move to %@(%d,%d) with value of %.2f, maxIndex is %d",[[allMoves objectAtIndex:maxIndex] getName],[[allMoves objectAtIndex:maxIndex] getX],[[allMoves objectAtIndex:maxIndex] getY],[[allMoves objectAtIndex:maxIndex + 1] getName],[[allMoves objectAtIndex:maxIndex + 1] getX],[[allMoves objectAtIndex:maxIndex + 1] getY], maxValue, maxIndex);
    return bestMoves;
}
//-(NSMutableArray *) sortPiecesInArray:(NSMutableArray *) array{
//    long count = array.count;
//    int i;
//    bool swapped = TRUE;
//    while (swapped){
//        swapped = FALSE;
//        for (i=1; i<count;i++)
//        {
//            if ([[array objectAtIndex:(i-1)] getRelativeValue] > [[array objectAtIndex:i] getRelativeValue])
//            {
//                [array exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
//                swapped = TRUE;
//            }
//            //bubbleSortCount ++; //Increment the count everytime a switch is done, this line is not required in the production implementation.
//        }
//    }
//    return array;
//}

-(int)getAttackedValue:(Piece *)pi {
    NSMutableArray *takenArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if (([t getSide] != [pi getSide]) && ([t getSide] != 0)) {
                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi] && ![self isTakenInMove:t to:pi]) {
//                    NSLog(@"getattacked t:%@ taking pi:%@",[t printInformation], [pi printInformation]);
                    [takenArray addObject:t];
                }
            }
        }
    }
    int attakedValue = 0;
    for (Piece *i in takenArray) {
        attakedValue += [i getRelativeValue];
    }
    return attakedValue;
}

-(int)getDefendValue:(Piece *)pi {
    NSMutableArray *guardArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if ([t getSide] == [pi getSide]) {
                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi]) {
                    [guardArray addObject:t];
                }
            }
        }
    }
    int defendValue = 0;
    for (Piece *i in guardArray) {
        defendValue += [i getRelativeValue];
    }
    return defendValue;
}

//-(BOOL)isTaken:(Piece *)pi{
////    NSLog(@"isTaken:%@",[pi printInformation]);
//    NSMutableArray *takenArray = [[NSMutableArray alloc] init];
//    for (NSMutableArray *i in self.pieceSet) {
//        for (Piece *t in i) {
//            if (([t getSide] != [pi getSide]) && ([t getSide] != 0)) {
//                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi]) {
////                    NSLog(@"isTaken t:%@ taking pi:%@",[t printInformation], [pi printInformation]);
//                    [takenArray addObject:t];
//                }
//            }
//        }
//    }
//    NSMutableArray *guardArray = [self isGuardingPiece:pi];
//    if ([guardArray count] == 0 && [takenArray count] > 0) {
//        return true;
//    }
//    else if([takenArray count] == 0) {
//        return false;
//    }
//    takenArray = [self sortPiecesInArray:takenArray];
//    //Cannot dectect in real time
//    double finalValue = 0;
//    [guardArray insertObject:pi atIndex:0];
//    NSUInteger guardCount = [guardArray count];
//    NSUInteger takenCount = [takenArray count];
//    double guardValue = 0;
//    double takenValue = 0;
//    int tStack = 0, gStack = 0;
//    int tterm = 0;
//    while(takenCount != 0 && guardCount != 0) {
//        if (tterm == 0 || tterm % 2 == 0) {
//            takenValue += [[guardArray objectAtIndex:gStack++] getRelativeValue];
//            guardCount--;
//        }
//        else {
//            guardValue += [[takenArray objectAtIndex:tStack++] getRelativeValue];
//            takenCount--;
//        }
//        tterm++;
//    }
////    if (takenCount == 0 && guardCount != 0) {
////        guardValue += [[takenArray objectAtIndex:stack] getRelativeValue];
////    }
////    else if(guardCount == 0 && takenCount != 0) {
////        takenValue += [[guardArray objectAtIndex:stack] getRelativeValue];
////    }
//    finalValue += guardValue - takenValue;
////    NSLog(@"FinalValue is: %.3lf, guardValue:%.3lf, takenValue:%.3lf,takenArray Count:%lu, gstack:%d, tstack:%d",finalValue,guardValue,takenValue,(unsigned long)[takenArray count], gStack, tStack);
//    if (finalValue >= 0) {
//        return false;
//    }
//    else {
//        return true;
//    }
//}

-(NSMutableArray *)isTakenBy:(Piece *)pi {
    NSMutableArray *takenBy = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if (([t getSide] != [pi getSide]) && ([t getSide] != 0)) {
                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi]) {
                    [takenBy addObject:t];
                }
            }
        }
    }
    takenBy = [self sortPiecesInArray:takenBy];
    return takenBy;
}

-(NSMutableArray *) boardTotalLosingValue:(int)side{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *threates = [[NSMutableArray alloc] init];
    Piece *maxLosePiece;
    double maxLose = 0;
    int count = 0;
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p getSide] == side) {
                if (count == 0) {
                    Piece *temp = [[Piece alloc] initWithImg:nil and:[NSMutableString stringWithFormat:@"format"] with:0 with:0 with:0];
                    [temp setRelativeValue:0];
                    maxLosePiece = temp;
                }
                if ([self isTakenAfterMoved:p]) {
                    maxLose += [p getRelativeValue];
                    maxLosePiece = p;
                    threates = [self isTakenBy:p];
                }
                count ++;
            }
        }
    }
    [results addObject:maxLosePiece];
    [results addObject:[NSNumber numberWithDouble:maxLose]];
    [results addObject:threates];
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
//    NSLog(@"AvailableMovesForLosePiece:%@", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] ) {
                if ([self validateMove:pi to:t] &&  [self isUnchecked:pi to:t] && ![self isTakenInMove:pi to:t]) {
//                                        NSLog(@"AvailableMovesForLosePiece: approved %@(%d,%d)",[t getName],[t getX],[t getY]);
                    
                    [availableMovesArray addObject:pi];
                    [availableMovesArray addObject:t];
                    
                }
            }
        }
    }
    return availableMovesArray;
}

-(Piece *) availableToSpot:(Piece *) t with:(NSMutableArray *)allMoves{
    Piece *availablePiece = t;
    double max = 0;
    double curr = 0;
    for (NSMutableArray* i in allMoves) {
        if ([i objectAtIndex:1] == t) {
            curr = [self thinkAhead:[i objectAtIndex:0] to:t];
            if (curr > max) {
                max = curr;
                availablePiece = [i objectAtIndex:0];
            }
        }
    }
    return  availablePiece;
}

//-(NSMutableArray *) losePieceMove:(Piece *)losePice and:(NSMutableArray *)threates and:(NSMutableArray *)allMoves{
//    NSLog(@"losePieceMove:%@,threates count:%d",[losePice printInformation],[threates count]);
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    if ([threates count] == 1) {
//        Piece *avaToSpot = [self availableToSpot:[threates objectAtIndex:0] with:allMoves];
//        if (avaToSpot == [threates objectAtIndex:0]) {
//            
//        }
//        else {
//            [result addObject:avaToSpot];
//            [result addObject:[threates objectAtIndex:0]];
//            return result;
//        }
//    }
//    NSMutableArray *losePieceMoves = [self AvailableMovesForLosePiece:losePice];
//    if ([losePieceMoves count] == 0) {
//        return result;
//    }
//    result = [self bestMoveForOnePiece:losePieceMoves];
//    return result;
//}
// need a backup move
-(NSMutableArray *) findBestMove:(NSMutableArray *)allMoves {
    NSLog(@"in findbestMove");
    double maxValue = -30000;
    double maxIndex = 0;
    int count = 0;
//    NSMutableArray *maxLose = [self boardTotalLosingValue:2];
    NSMutableArray *maxMove = [[NSMutableArray alloc] init];
    for (NSMutableArray *move in allMoves) {
        NSLog(@"new start");
        //Doesnt care if there is move to make or not
        double curValue = [self thinkAhead:[move objectAtIndex:0] to:[move objectAtIndex:1]];
        NSLog(@"finishmove");
        if (curValue > maxValue) {
                maxValue = curValue;
                maxIndex = count;
                maxMove = move;
        }
        count ++;
    }

//    NSLog(@"bestMove is %@(%d,%d) to %@(%d,%d) with value %.2f",[[maxMove objectAtIndex:0] getName],[[maxMove objectAtIndex:0] getX],[[maxMove objectAtIndex:0] getY],[[maxMove objectAtIndex:1] getName],[[maxMove objectAtIndex:1] getX],[[maxMove objectAtIndex:1] getY], maxValue);
    NSLog(@"returning max");
    return maxMove;
}

-(NSMutableArray *)whitePawnCount {
    int count[8]= {0,0,0,0,0,0,0,0};
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] == 1 && ([[t getName] rangeOfString:@"Pawn"].location != NSNotFound) ) {
                count[[t getX]]++;
            }
        }
    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8;i++ ) {
        [result addObject:@(count[i])];
    }
    return result;

}

-(NSMutableArray *)blackPawnCount {
    int count[8]= {0,0,0,0,0,0,0,0};
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] == 2 && ([[t getName] rangeOfString:@"Pawn"].location != NSNotFound) ) {
                count[[t getX]]++;
            }
        }
    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8;i++ ) {
        [result addObject:@(count[i])];
    }
    return result;
    
}
-(BOOL) kingNotTaken:(Piece *)pi to:(Piece *)t {
    if ([[pi getName] rangeOfString:@"bking"].location != NSNotFound) {
        if (![self isTakenInMove:pi to:t]) {
            return true;
        }
        else return false;
    }
    else {
        return true;
    }
}
//TODO: implement such that when a good trade happens take it
-(NSMutableArray *)AvailableMovesForOnePiece:(Piece *)pi{
    NSMutableArray *availableMovesArray = [[NSMutableArray alloc] init];
//    NSLog(@"AvailableMovesForOnePiece: %@", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] ) {
                //                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                if ([self validateMove:pi to:t] &&  [self isUnchecked:pi to:t] && ![self isTakenInMove:pi to:t] && [self kingNotTaken:pi to:t]) {
                    //                    NSLog(@"#2%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                    
                    [availableMovesArray addObject:pi];
                    [availableMovesArray addObject:t];
                    
                }
            }
        }
    }
    return availableMovesArray;
}

-(NSMutableArray *)getAllMoves:(int)side {
    NSMutableArray *avaMoves = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p getSide] == side) {
                NSMutableArray *tempArray = [self AvailableMovesForOnePiece:p];
                if ([tempArray count] != 0) {
                    [avaMoves addObject:tempArray];
                }
            }
        }
    }
    return avaMoves;
}

-(NSString *) normalMove:(int)side {
//    NSLog(@"normalMove");
    NSMutableArray *avaMoves = [self getAllMoves:side];
    NSLog(@"getallmoves");
//    NSLog(@"finish getAllMoves");
    NSMutableArray *bestMove = [self findBestMove:avaMoves];
    if ([bestMove count] == 0) {
        //TODO: should be developing
        NSLog(@"NO GOOD MOVE TO MAKE");
    }
    [self botMoveFrom:[bestMove objectAtIndex:0] to:[bestMove objectAtIndex:1]];
    return [self getLog:[bestMove objectAtIndex:0] to:[bestMove objectAtIndex:1]];
}

-(NSString *)getLog:(Piece *)p to: (Piece *)t {
    if ([t isKing]) {
            return [NSString stringWithFormat:@"%@(%d,%d) move from %@ to %@(King move involved, check for castlings)",[t getName],[p getX] + 1,[p getY] + 1, [p printLocation], [t printLocation]];
    }
    return [NSString stringWithFormat:@"%@(%d,%d) move from %@ to %@",[t getName],[p getX] + 1,[p getY] + 1, [p printLocation], [t printLocation]];
}

-(NSString *)getLogPlayer:(Piece *)p to: (Piece *)t{
    if ([p isKing]) {
        return [NSString stringWithFormat:@"%@(%d,%d) move from %@ to %@(King move involved, check for castlings)",[p getName],[p getX] + 1,[p getY] + 1, [p printLocation], [t printLocation]];
    }
        return [NSString stringWithFormat:@"%@(%d,%d) move from %@ to %@",[p getName],[p getX] + 1,[p getY] + 1, [p printLocation], [t printLocation]];
}
//It miss checked checking piece
-(NSString *)eliminateThreate {
//    NSLog(@"eliminateThreate");
    if ([self.checkingPieces count] == 1) {
        Piece *cp = [self.checkingPieces objectAtIndex:0];
        for (NSMutableArray *i in self.pieceSet) {
            for (Piece *p in i) {
                if ([p getSide] == 2) {
                    if ([self validateMove:p to:cp] && [self isUnchecked:p to:cp]) {
                        [self botMoveFrom:p to:cp];
                        return [self getLog:p to:cp];
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
                        return [self getLog:myKing to:t];
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
                        return [self getLog:myKing to:t];
                    }
                }
            }
        }
    }
    return [NSString stringWithFormat:@"Error in eliminate threate"];

}
-(NSString *) scriptMove:(NSArray *)readin {
    NSLog(@"scprit move");
//    NSArray *readin = [manual outputScript];
//    if (readin == nil) {
//        return false;
//    }
    Piece *pi = [self getPieceAt:[[readin objectAtIndex:0] boardPointGetX] with:[[readin objectAtIndex:0] boardPointGetY]];
    Piece *t = [self getPieceAt:[[readin objectAtIndex:1] boardPointGetX] with:[[readin objectAtIndex:1] boardPointGetY]];
    if (([pi getSide] != [t getSide]) && [self validateMove:pi to:t] && [self isUnchecked:pi to:t] && ([[[self boardTotalLosingValue:2] objectAtIndex:1] doubleValue] < 0) && ![self isTakenInMove:pi to:t]) {
//        NSLog(@"scriptMove calling bot move from %.2f",[[[self boardTotalLosingValue:2] objectAtIndex:1] doubleValue]);
        [self botMoveFrom:pi to:t];
        return [self getLog:pi to:t];
    }
    else {
        NSLog(@"normal move");
        return [self normalMove:botSide];
    }
    return @"false";
}

-(void) pieceTakeoverFrom:(Piece *)p to:(Piece *)t {
    UIImageView *tempImage2 = [t getImage];
    UIImageView *tempImage = [p getImage];
    [self imageTakeOver:tempImage takeOver:tempImage2];
    [t setName:[p getName]];
    [p setName: [NSMutableString stringWithFormat: @"empty"]];
    [t setSide:[p getSide]];
    [p setSide:0];
    [t setRelativeValue:[p getRelativeValue]];
    [p setRelativeValue:0];

}


-(void) botMoveFrom:(Piece *)p to:(Piece *)t {
//    NSLog(@"in bot move for %@(%d,%d) to %@(%d,%d)", [p getName], [p getX], [p getY], [t getName],[t getX], [t getY]);

    if ([[p getName] rangeOfString:@"king"].location != NSNotFound) {
        if ([self kingCanCastle:p to:t]) {
            [self castlingMove:p to:t];
            return;
        }
        else {
            [self pieceTakeoverFrom:p to:t];
            [p setHasMoved:0];
            [t setHasMoved:1];
            return;
        }
        
    }
    else {
//        NSLog(@"%@(v:%.2f) take over %@(v:%.2f), from %d %d, to %d %d",[p getName],[p getRelativeValue],[t getName],[t getRelativeValue],[p getX], [p getY],[t getX],[t getY]);
        [self pieceTakeoverFrom:p to:t];
        [p setHasMoved:0];
        [t setHasMoved:1];
        return;
    }
}


-(void) changeTerms {
    //If there are unconfirmed move, reject term changing request.
    if ([self.undecidedMove count] == 0) {
        return;
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.logPath];
    [fileHandle seekToEndOfFile];
    NSString *logString;
    if (self.terms == 1) {
        self.undecidedReturnTrue = 0;
        NSString *logStringMyMove = [self getLogPlayer:[self.undecidedMove objectAtIndex:0] to:[self.undecidedMove objectAtIndex:1]];
        [self.undecidedMove removeAllObjects];
        self.terms = 2;
        [self checkStatus];
        logString = [self botMove];
        if ([self isFirstCaller] == 1) {
            NSLog(@"caller is 1!!!!!!");
            [fileHandle writeData:[[NSString stringWithFormat:@"MM: %@\n",logStringMyMove] dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[[NSString stringWithFormat:@"BM: %@\n",logString] dataUsingEncoding:NSUTF8StringEncoding]];
        }

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
-(int) isInsufficentMaterial:(int) side{
    int white = 0;
    int black = 0;
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p isWhite]) {
                white++;
            }
            else if([p isBlack]) {
                black++;
            }
        }
    }
    if (side == 1) {
        if (white < black) {
            return 1;
        }
        else return 0;
    }
    else if (side == 2) {
        if (black < white) {
            return 1;
        }
        else return 0;
    }
    else {
        NSLog(@"isInsufficentMaterial error!");
        return -1;
    }
}

-(int) bishopCount:(int) side{
    int count = 0;
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p isBishop] && [p getSide] == side) {
                count++;
            }
        }

    }
    return count;
}
-(int) totalBoardValue:(int)side {
    int totalValue = 0;
    for (NSMutableArray *i in [self pieceSet]) {
        for (Piece *p in i) {
            if ([p getSide] == side) {
                            totalValue += [self boardEvaluationPiece:p isCastled:self.isCastled isEndGame:0 bishopCount:[self bishopCount:side] insufficientMaterial:[self isInsufficentMaterial:side]];
            }
            
        }
    }
    int totalValueOpponent = 0;
    NSLog(@"go for opponent's value");
    for (NSMutableArray *i in [self pieceSet]) {
        for (Piece *p in i) {
            if ([p getSide] == (3 - side)) {
                totalValueOpponent += [self boardEvaluationPiece:p isCastled:self.isCastled isEndGame:0 bishopCount:[self bishopCount:3 -side] insufficientMaterial:[self isInsufficentMaterial:3 - side]];
            }
            
        }
    }
    NSLog(@"finish opponent's move");
    return totalValue - totalValueOpponent;
}
//Disabled for encouraging more moves
-(int) boardEvaluationPiece:(Piece *) pi isCastled:(int)isCastled isEndGame:(int)isEndGame bishopCount:(int)bishopCount insufficientMaterial:(int)insuffcientMaterial {
    int score = 0;
    int position = [pi getY] * 8 + [pi getX];
    int index = position;
    if ([pi getSide] == 2) {
        index = 63 - position;
    }
    score += [pi getRelativeValue];
    int attackedValue = [self getAttackedValue:pi];
    int defendValue = [self getDefendValue:pi];

    if ([self isTakenAfterMoved:pi]) {
        score -= [pi getRelativeValue];
    }
    else {
        score += attackedValue * 0.3;
        score += defendValue * 0.1;
    }


    NSMutableArray *blackPawnCount = [self blackPawnCount];
    NSMutableArray *whitePawnCount = [self whitePawnCount];
    if ([pi isPawn]) {
        insuffcientMaterial = 0;
        if (position % 8 == 0 || position % 8 == 7) {
            score -= 15;
        }
        
        score += [[self.PawnTable objectAtIndex:index] integerValue];
        if ([pi getSide] == 1) {
            if ([whitePawnCount objectAtIndex:(position % 8)] > 0) {
                score -= 16;
            }
            if (position >= 8 && position <= 15) {
                if (attackedValue == 0) {
                    [whitePawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 200)];
                    if (defendValue != 0) {
                        [whitePawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 50)];
                    }
                }
                
            }
            else if(position >= 16 && position <= 23) {
                if (attackedValue == 0) {
                    [whitePawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 100)];
                    if (defendValue != 0) {
                        [whitePawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 25)];
                    }
                }
            }
            [whitePawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 10)];
        }
        else {
            if (blackPawnCount[position % 8] > 0)
            {
                //Doubled Pawn
                score -= 16;
            }
            
            if (position >= 48 && position <= 55)
            {
                if (attackedValue == 0)
                {
                    [blackPawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 200)];
                    if (defendValue != 0) {
                        [blackPawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 50)];
                    }
                }
            }
            //Pawns in 6th Row that are not attacked are worth more points.
            else if (position >= 40 && position <= 47)
            {
                if (attackedValue == 0)
                {
                    [blackPawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 100)];
                    if (defendValue != 0)
                        [blackPawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 25)];
                }
            }
            
            [blackPawnCount replaceObjectAtIndex:(position % 8) withObject:@([[whitePawnCount objectAtIndex:position % 8]integerValue]+ 10)];
        }

    }
    else if([pi isKnight]) {
        score += [[self.KnightTable objectAtIndex:index] integerValue];
        if (isEndGame == 1) {
            score -= 10;
        }
    }
    else if([pi isBishop]) {
        if (bishopCount >= 2) {
            score += 10;
        }
        if (isEndGame == 1) {
            score += 10;
        }
        score += [[self.BishopTable objectAtIndex:index] integerValue];
    }
    else if([pi isRook]) {
        insuffcientMaterial = 0;
        //&& !endGamePhase
        if (![pi hasPieceMoved] && self.isCastled == false)
        {
            score -= 10;
        }
        
    }
    else if([pi isQueen]) {
        insuffcientMaterial = 0;
        //&& !endGamePhase
         if (![pi hasPieceMoved])
         {
         score -= 10;
         }
        
    }
    else if([pi isKing]) {
//        if ([moves count] < 2) {
//            score -= 5;
//        }
        if (isEndGame == 1) {
            score += [[self.KingTableEndGame objectAtIndex:index] integerValue];
        }
        else {
            score += [[self.KingTable objectAtIndex:index] integerValue];
            //&& !endGame
             if (![pi hasPieceMoved])
             {
             score -= 10;
             }
            
        }
    }
    return score;
}
//TODO: Simply add the value of tp piece to the trading chain will do it
-(BOOL)isTakenInMove:(Piece *)pi to:(Piece *)tp {
    HardBot *tempBoard = [self imagineMoveOnBoard:pi to:tp];
    Piece *tOnTempBoard = [tempBoard getPieceAt:[tp getX] with:[tp getY]];
    return [tempBoard isTakenAfterMoved:tOnTempBoard];
}

@end
