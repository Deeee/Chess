//
//  ChessManual.h
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardPoint.h"
@interface ChessManual : NSObject
@property NSString *manualName;
@property int side;
@property NSMutableArray *currentScript;
@property int currentStep;
-(id) initWithManualName:(NSString *) name and:(int) side;

-(void) loadScript:(NSString *)name;
-(void) loadScriptStoneOpening;
-(NSArray *) outputScript;
@end
