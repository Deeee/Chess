//
//  ViewController.h
//  Chess
//
//  Created by Liu Di on 6/13/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Piece.h"
#import "Board.h"
#import "DrawCircles.h"
@interface ViewController : GLKViewController<UITextFieldDelegate>
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
//@property (nonatomic, strong) IBOutlet UIView *dropTarget;
@property (nonatomic, strong) UIImageView *dragObject;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;

@property (nonatomic, assign) IBOutlet UIImageView *backgroud;
@property (nonatomic, assign) IBOutlet UIImageView *space1;
@property (nonatomic, assign) IBOutlet UIImageView *space2;
@property (nonatomic, assign) IBOutlet UIImageView *space3;
@property (nonatomic, assign) IBOutlet UIImageView *space4;
@property (nonatomic, assign) IBOutlet UIImageView *space5;
@property (nonatomic, assign) IBOutlet UIImageView *space6;
@property (nonatomic, assign) IBOutlet UIImageView *space7;
@property (nonatomic, assign) IBOutlet UIImageView *space8;
@property (nonatomic, assign) IBOutlet UIImageView *space9;
@property (nonatomic, assign) IBOutlet UIImageView *space10;
@property (nonatomic, assign) IBOutlet UIImageView *space11;
@property (nonatomic, assign) IBOutlet UIImageView *space12;
@property (nonatomic, assign) IBOutlet UIImageView *space13;
@property (nonatomic, assign) IBOutlet UIImageView *space14;
@property (nonatomic, assign) IBOutlet UIImageView *space15;
@property (nonatomic, assign) IBOutlet UIImageView *space16;
@property (nonatomic, assign) IBOutlet UIImageView *space17;
@property (nonatomic, assign) IBOutlet UIImageView *space18;
@property (nonatomic, assign) IBOutlet UIImageView *space19;
@property (nonatomic, assign) IBOutlet UIImageView *space20;
@property (nonatomic, assign) IBOutlet UIImageView *space21;
@property (nonatomic, assign) IBOutlet UIImageView *space22;
@property (nonatomic, assign) IBOutlet UIImageView *space23;
@property (nonatomic, assign) IBOutlet UIImageView *space24;
@property (nonatomic, assign) IBOutlet UIImageView *space25;
@property (nonatomic, assign) IBOutlet UIImageView *space26;
@property (nonatomic, assign) IBOutlet UIImageView *space27;
@property (nonatomic, assign) IBOutlet UIImageView *space28;
@property (nonatomic, assign) IBOutlet UIImageView *space29;
@property (nonatomic, assign) IBOutlet UIImageView *space30;
@property (nonatomic, assign) IBOutlet UIImageView *space31;
@property (nonatomic, assign) IBOutlet UIImageView *space32;

@property (nonatomic, strong) Board *myBoard;

@property Piece *tempPiece;
@property int X, Y, isTouched;
@property int isMoved;
@property int isDebug;
@property int isTapped;
@property int isSet;

@property (nonatomic, assign) IBOutlet UIImageView *rock;
@property (nonatomic, assign) IBOutlet UIImageView *knight;
@property (nonatomic, assign) IBOutlet UIImageView *bishop;
@property (nonatomic, assign) IBOutlet UIImageView *king;
@property (nonatomic, assign) IBOutlet UIImageView *queen;
@property (nonatomic, assign) IBOutlet UIImageView *bishop2;
@property (nonatomic, assign) IBOutlet UIImageView *kight2;
@property (nonatomic, assign) IBOutlet UIImageView *rock2;
@property (nonatomic, assign) IBOutlet UIImageView *pawn1;
@property (nonatomic, assign) IBOutlet UIImageView *pawn2;
@property (nonatomic, assign) IBOutlet UIImageView *pawn3;
@property (nonatomic, assign) IBOutlet UIImageView *pawn4;
@property (nonatomic, assign) IBOutlet UIImageView *pawn5;
@property (nonatomic, assign) IBOutlet UIImageView *pawn6;
@property (nonatomic, assign) IBOutlet UIImageView *pawn7;
@property (nonatomic, assign) IBOutlet UIImageView *pawn8;

@property (nonatomic, assign) IBOutlet UIImageView *brock;
@property (nonatomic, assign) IBOutlet UIImageView *bknight;
@property (nonatomic, assign) IBOutlet UIImageView *bbishop;
@property (nonatomic, assign) IBOutlet UIImageView *bking;
@property (nonatomic, assign) IBOutlet UIImageView *bqueen;
@property (nonatomic, assign) IBOutlet UIImageView *bbishop2;
@property (nonatomic, assign) IBOutlet UIImageView *bkight2;
@property (nonatomic, assign) IBOutlet UIImageView *brock2;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn1;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn2;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn3;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn4;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn5;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn6;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn7;
@property (nonatomic, assign) IBOutlet UIImageView *bpawn8;
@property NSMutableString *debugInfo;
@property (nonatomic, strong) IBOutlet UITextField *debuggingWindow;
@property (nonatomic, strong) NSMutableArray *circleViews;
@property int availableMoves;
@property NSArray *paths;
@property NSString *filePath;
@property (nonatomic)CGPoint drawPoint;
- (Piece *)getMove:(UIImageView *) iView;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (void)setNeedsDisplay;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (NSInteger)getTagFromPiece:(Piece *) temp;
- (void)removeAllCircles;
- (void)endGame;

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTapGesture;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)clickOnComfirm;
-(NSMutableArray *)showAvailableMoves:(Piece *)pi onView:(DrawCircles *)drawView;
+ (void)resize:(UIView*)view to:(CGSize)size withDuration:(int) duration andSnapBack:(BOOL) snapBack;
@end
