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
@synthesize steps;
-(id) copyWithZone:(NSZone *)zone {
    return self;
}

-(id) init{
    self = [super init];
    manual = [[ChessManual alloc] initWithManualName:@"stoneWall" and:2];
    steps = 0;
    return self;
}

-(void) botMove {
    [self addRelativeValue];
//    [self normalMove];
    if ([self isInCheck] == 2) {
        [self eliminateThreate];
    }
    else if ([self scriptMove]) {
        
    }
    else {
        [self normalMove];
    }
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
-(HardBot *) copySelf {
//    NSData *buffer;
//    buffer = [NSKeyedArchiver archivedDataWithRootObject:self];
//    HardBot *copy = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
    NSLog(@"in copyself");
    HardBot *copy = [[HardBot alloc] init];
    
//    NSMutableArray* pieceSetCopy = [NSKeyedUnarchiver unarchiveObjectWithData:
//                                  [NSKeyedArchiver archivedDataWithRootObject:[self pieceSet]]];
//    pieceSetCopy = [[NSMutableArray arrayWithArray:copy.pieceSet] mutableCopy];
    NSMutableArray *pieceSetCopy = [self copyPieceSet];
    copy.pieceSet = pieceSetCopy;
    
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
    NSLog(@"imagineMoveOnBoard:%@ to %@",[p printInformation],[t printInformation]);
    HardBot *copy = [self copySelf];
    Piece *igP = [copy getPieceAt:[p getX] with:[p getY]];
    [igP printInformation];
    Piece *igT = [copy getPieceAt:[t getX] with:[t getY]];
    [igT printInformation];
    [copy botMoveFrom:igP to:igT];
    return copy;
}

-(void)formation {
    
}


//imagine move doesnt do castle moves ##
-(BOOL)isTakenInMove:(Piece *)pi to:(Piece *)tp {
    NSMutableArray *takenArray = [[NSMutableArray alloc] init];
    double takenValue = 0;
    double guardValue = 0;
    NSLog(@"isTakenInMove:%@ to %@",[pi printInformation],[tp printInformation]);
    if ([tp getSide] != 0 && [tp getSide] != [pi getSide]) {
        if ([tp getRelativeValue] >= [pi getRelativeValue]) {
            guardValue += [tp getRelativeValue];
        }
    }
    HardBot *tempBoard = [self imagineMoveOnBoard:pi to:tp];
    NSMutableArray *guardArray = [tempBoard isGuardingPiece:[tempBoard getPieceAt:[tp getX] with:[tp getY]]];
    for (NSMutableArray *i in tempBoard.pieceSet) {
        for (Piece *t in i) {
            if (([t getSide] != [tp getSide]) && ([t getSide] != 0)) {
                if ([tempBoard validateMove:t to:[tempBoard getPieceAt:[tp getX] with:[tp getY]]] && [tempBoard isUnchecked:t to:[tempBoard getPieceAt:[tp getX] with:[tp getY]]]) {
                    [takenArray addObject:t];
                }
            }
        }
    }
    for (Piece *i in takenArray) {
        takenValue += [i getRelativeValue];
    }
    for (Piece *i in guardArray) {
        guardValue += [i getRelativeValue];
    }
    if (guardValue >= takenValue || [tp getRelativeValue] >= [pi getRelativeValue]) {
        return false;
    }
    else {
        return true;
    }}

-(NSMutableArray *)isGuardingPiece:(Piece *)pi{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if ([t getSide] == [pi getSide]) {
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
    NSLog(@"isTakingPiece:%@",[pi printInformation]);
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] && [t getSide] != 0) {
                if ([self validateMove:pi to:t] && [self isUnchecked:pi to:t] && [self isSafeTaking:pi and:t] && ![self isTakenInMove:pi to:t] && [[self isGuardingPiece:t] count] == 0) {
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
//-(void) botCastlingMove:(Piece *)p to:(Piece *)t{
//    Piece *movingRook = [self getAccordingRook:p to:t];
//    botTempRook = movingRook;
//    int _x = [t getX];
//    NSLog(@"in bot castling move t x is %d", [t getX]);
//    if (_x > 4) {
//        NSLog(@"_x bigger > 4");
//        Piece *des = [self getPieceAt:([t getX] - 1) with:[p getY]];
//        oriTempRook = des;
//        [self imagineMoveSingle:movingRook to:des];
//    }
//    else {
//        Piece *des = [self getPieceAt:([t getX]+1) with:[p getY]];
//        oriTempRook = des;
//        [self imagineMoveSingle:movingRook to:des];
//    }
//    [self imagineMoveSingle:p to:t];
//    
//}

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

-(double)thinkAhead:(Piece *)p to:(Piece *)t {
    NSLog(@"thinkAhead:%@ to:%@",[p printInformation],[t printInformation]);
    double sumOfTaking = 0;
    double sumOfTaken = 0;
    if (([t getSide] != [p getSide]) && ([t getSide] != 0)) {
        sumOfTaking += [t getRelativeValue];
    }
    HardBot *tempBoard = [self imagineMoveOnBoard:p to:t];
    Piece *tOnTempBoard = [tempBoard getPieceAt:[t getX] with:[t getY]];
    NSMutableArray *totalLosingArray = [tempBoard boardTotalLosingValue:[p getSide]];
    sumOfTaken = [[totalLosingArray objectAtIndex:1] doubleValue];
    NSMutableArray *isTakingArray = [tempBoard isTakingPiece:tOnTempBoard];
    if ([tempBoard isTaken:[tempBoard getPieceAt:[t getX] with:[t getY]]]) {
    }
    else {
        for (Piece *temp in isTakingArray) {
            NSLog(@"isTakingArray %@ taking %@",[p printInformation],[temp printInformation]);
            sumOfTaking += 0.4 * [temp getRelativeValue];
        }
    }
    NSLog(@"thinkAhead:%@ to:%@ sumOfTaking is %.2f, sumOfTaken is %.2f",[p printInformation],[t printInformation],sumOfTaking,sumOfTaken);
    NSMutableArray *onePieceMoves = [tempBoard AvailableMovesForOnePiece:[tempBoard getPieceAt:[t getX] with:[t getY]]];
    if (steps == 3 || [onePieceMoves count] == 0) {
        steps = 0;
        return sumOfTaking - sumOfTaken;
    }
    else {
        return sumOfTaking - sumOfTaken + [[[tempBoard bestMoveForOnePiece: onePieceMoves Steps:++steps] objectAtIndex:2] doubleValue];
    }
}

//-(BOOL)inspectCurrent:(Piece *)p to:(Piece *)t {
//    NSLog(@"inspectCurrent:%@ to %@",[p printInformation],[t printInformation]);
//    int isTaking = 0;
//    int takingValue = 0;
//    int selfValue = [p getRelativeValue];
//    if ([t getSide] != [p getSide] && [t getSide] != 0) {
//        isTaking = 1;
//        takingValue = [t getRelativeValue];
//    }
//    HardBot *tempBoard = [self imagineMoveOnBoard:p to:t];
//    if (isTaking && ![tempBoard isTaken:[tempBoard getPieceAt:[t getX] with:[t getY]]]) {
//        return true;
//    }
//    else {
//        return false;
//    }
//}
//Improve: if anypieces can be taken atm without danger, take it
-(NSMutableArray *)bestMoveForOnePiece:(NSMutableArray *)allMoves Steps:(int)step{
    self.steps = step;
    NSLog(@"bestMoveForOnePiece:allMove:%d",[allMoves count]);
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
    NSLog(@"bestMoveForOnePiece %@(%d,%d) is move to %@(%d,%d) with value of %.2f, maxIndex is %d",[[allMoves objectAtIndex:maxIndex] getName],[[allMoves objectAtIndex:maxIndex] getX],[[allMoves objectAtIndex:maxIndex] getY],[[allMoves objectAtIndex:maxIndex + 1] getName],[[allMoves objectAtIndex:maxIndex + 1] getX],[[allMoves objectAtIndex:maxIndex + 1] getY], maxValue, maxIndex);
    return bestMoves;
}

-(BOOL)isTaken:(Piece *)pi{
    NSLog(@"isTaken:%@",[pi printInformation]);
    NSMutableArray *takenArray = [[NSMutableArray alloc] init];
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *t in i) {
            if (([t getSide] != [pi getSide]) && ([t getSide] != 0)) {
                if ([self validateMove:t to:pi] && [self isUnchecked:t to:pi]) {
                    NSLog(@"isTaken t:%@ taking pi:%@",[t printInformation], [pi printInformation]);
                    [takenArray addObject:t];
                }
            }
        }
    }
    double takenValue = 0;
    double guardValue = 0;
    NSMutableArray *guardArray = [self isGuardingPiece:pi];
    for (Piece *i in takenArray) {
        takenValue += [i getRelativeValue];
    }
    for (Piece *i in guardArray) {
        guardValue += [i getRelativeValue];
    }
    if (guardValue >= takenValue) {
        return false;
    }
    else {
        return true;
    }
}

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
    return takenBy;
}

-(NSMutableArray *) boardTotalLosingValue:(int)side{
    NSLog(@"boardTotalLosingValue:%d",side);
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *threates = [[NSMutableArray alloc] init];
    Piece *maxLosePiece;
    double maxLose = 0;
    int count = 0;
    for (NSMutableArray *i in self.pieceSet) {
        for (Piece *p in i) {
            if ([p getSide] == side) {
                if (count == 0) {
                    Piece *temp = [[Piece alloc] initWithImg:nil and:@"empty" with:0 with:0 with:0];
                    [temp setRelativeValue:0];
                    maxLosePiece = temp;
                }
                if (([p getRelativeValue] > maxLose) &&  [self isTaken:p]) {
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
    //posible return nil of maxlosetaken
    NSLog(@"boardtotallosingvalue:%@",[maxLosePiece printInformation]);
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
    NSLog(@"AvailableMovesForLosePiece:%@", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] ) {
                if ([self validateMove:pi to:t] &&  [self isUnchecked:pi to:t] && ![self isTakenInMove:pi to:t]) {
                                        NSLog(@"AvailableMovesForLosePiece: approved %@(%d,%d)",[t getName],[t getX],[t getY]);
                    
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
    NSLog(@"in find best move");
    double maxValue = 0;
    double maxIndex = 0;
    int count = 0;
    int isDefautSet = 0;
//    NSMutableArray *maxLose = [self boardTotalLosingValue:2];
    NSLog(@"cp3");
    NSMutableArray *maxMove = [[NSMutableArray alloc] init];
    NSLog(@"cp2");
    for (NSMutableArray *allMoveOnePiece in allMoves) {
        NSMutableArray *tempArray =[self bestMoveForOnePiece:allMoveOnePiece Steps:self.steps];
        double tempDouble = [[tempArray objectAtIndex:2] doubleValue];
        if (count == 0) {
            maxValue = tempDouble;
            maxIndex = count;
        }
        if (isDefautSet == 0 && [tempArray count] != 0) {
            [maxMove addObject:[tempArray objectAtIndex:0]];
            [maxMove addObject:[tempArray objectAtIndex:1]];
            isDefautSet = 1;
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
    NSLog(@"cp1");
//    double maxLoseValue;
//    if ([maxLose count] == 0) {
//        maxLoseValue = 0;
//    }
//    else {
//        maxLoseValue = [[maxLose objectAtIndex:1] doubleValue];
//    }
//    NSLog(@"bestMoveValue:%.2f, maxlosevalue:%.2f",maxValue,maxLoseValue);
    NSLog(@"bestMove is %@(%d,%d) to %@(%d,%d) with value %.2f",[[maxMove objectAtIndex:0] getName],[[maxMove objectAtIndex:0] getX],[[maxMove objectAtIndex:0] getY],[[maxMove objectAtIndex:1] getName],[[maxMove objectAtIndex:1] getX],[[maxMove objectAtIndex:1] getY], maxValue);
    return maxMove;

//    if (maxLoseValue > maxValue) {
//        NSLog(@"preparing for losingmove");
//        Piece *losePiece = [maxLose objectAtIndex:0];
//        NSMutableArray *losePieceMove = [self losePieceMove:losePiece and:[maxLose objectAtIndex:2] and:allMoves];
//        if ([losePieceMove count] == 0) {
//            return maxMove;
//        }
//        return losePieceMove;
//    }
//    else {
//        NSLog(@"not in losingmove");
//        return maxMove;
//    }
//    NSLog(@"unexpected");
}
-(NSMutableArray *)AvailableMovesForOnePiece:(Piece *)pi{
    NSMutableArray *availableMovesArray = [[NSMutableArray alloc] init];
    NSLog(@"AvailableMovesForOnePiece: %@", [pi getName]);
    for (NSMutableArray *i in [self getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide] ) {
                //                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                if ([self validateMove:pi to:t] &&  [self isUnchecked:pi to:t] && [self isTakenInMove:pi to:t]) {
                    //                    NSLog(@"#2%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                    
                    [availableMovesArray addObject:pi];
                    [availableMovesArray addObject:t];
                    
                }
            }
        }
    }
    return availableMovesArray;
}

-(NSMutableArray *)getAllMoves {
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
    return avaMoves;
}

-(void) normalMove {
    NSLog(@"normalMove");
    NSMutableArray *avaMoves = [self getAllMoves];
    NSLog(@"finish getAllMoves");
    NSMutableArray *bestMove = [self findBestMove:avaMoves];
    [self botMoveFrom:[bestMove objectAtIndex:0] to:[bestMove objectAtIndex:1]];
    
}
//It miss checked checking piece
-(void)eliminateThreate {
    NSLog(@"eliminateThreate");
    if ([self.checkingPieces count] == 1) {
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
    if (([pi getSide] != [t getSide]) && [self validateMove:pi to:t] && [self isUnchecked:pi to:t] && ([self thinkAhead:pi to:t] >= [[[self boardTotalLosingValue:2] objectAtIndex:1] doubleValue]) && ![self isTakenInMove:pi to:t]) {
        NSLog(@"scriptMove calling bot move from");
        [self botMoveFrom:pi to:t];
        return true;
    }
    else {
        [self normalMove];
        return true;
    }
    return false;
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
    NSLog(@"in bot move for %@(%d,%d) to %@(%d,%d)", [p getName], [p getX], [p getY], [t getName],[t getX], [t getY]);

    if ([[p getName] rangeOfString:@"king"].location != NSNotFound) {
        if ([self kingCanCastle:p to:t]) {
            [self castlingMove:p to:t];
            return;
        }
        else {
            [self pieceTakeoverFrom:p to:t];
            return;
        }
        
    }
    else {
        NSLog(@"%@(v:%.2f) take over %@(v:%.2f), from %d %d, to %d %d",[p getName],[p getRelativeValue],[t getName],[t getRelativeValue],[p getX], [p getY],[t getX],[t getY]);
        [self pieceTakeoverFrom:p to:t];
        return;
    }
}


-(void) changeTerms {
    //If there are unconfirmed move, reject term changing request.
    if ([self.undecidedMove count] == 0) {
        return;
    }
    
    if (self.terms == 1) {
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
