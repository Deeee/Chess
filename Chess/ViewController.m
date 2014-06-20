//
//  ViewController.m
//  Chess
//
//  Created by Liu Di on 6/13/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "ViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@interface ViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}


- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ViewController
@synthesize dragObject;
@synthesize touchOffset;
@synthesize homePosition;
@synthesize backgroud;
@synthesize isMoved;

@synthesize space1;
@synthesize space2;
@synthesize space3;
@synthesize space4;
@synthesize space5;
@synthesize space6;
@synthesize space7;
@synthesize space8;
@synthesize space9;
@synthesize space10;
@synthesize space11;
@synthesize space12;
@synthesize space13;
@synthesize space14;
@synthesize space15;
@synthesize space16;
@synthesize space17;
@synthesize space18;
@synthesize space19;
@synthesize space20;
@synthesize space21;
@synthesize space22;
@synthesize space23;
@synthesize space24;
@synthesize space25;
@synthesize space26;
@synthesize space27;
@synthesize space28;
@synthesize space29;
@synthesize space30;
@synthesize space31;
@synthesize space32;
@synthesize myBoard;
@synthesize X, Y, isTouched;
@synthesize tempPiece;

@synthesize rock;
@synthesize knight;
@synthesize bishop;
@synthesize king;
@synthesize queen;
@synthesize bishop2;
@synthesize kight2;
@synthesize rock2;
@synthesize pawn1;
@synthesize pawn2;
@synthesize pawn3;
@synthesize pawn4;
@synthesize pawn5;
@synthesize pawn6;
@synthesize pawn7;
@synthesize pawn8;

@synthesize brock;
@synthesize bknight;
@synthesize bbishop;
@synthesize bking;
@synthesize bqueen;
@synthesize bbishop2;
@synthesize bkight2;
@synthesize brock2;
@synthesize bpawn1;
@synthesize bpawn2;
@synthesize bpawn3;
@synthesize bpawn4;
@synthesize bpawn5;
@synthesize bpawn6;
@synthesize bpawn7;
@synthesize bpawn8;

@synthesize debuggingWindow;
@synthesize isDebug;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];

    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    debuggingWindow.inputView = dummyView; // Hide keyboard, but show blinking cursor
    self.debuggingWindow.delegate = self;
    NSLog(@"in viewdidload");
    myBoard = [[Board alloc] init];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:0] setImg:rock and:[NSMutableString stringWithString:@"rock"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:0] setImg:knight and:[NSMutableString stringWithString:@"knight"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:0] setImg:bishop and:[NSMutableString stringWithString:@"bishop"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:0] setImg:king and:[NSMutableString stringWithString:@"king"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:0] setImg:queen and:[NSMutableString stringWithString:@"queen"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:0] setImg:bishop2 and:[NSMutableString stringWithString:@"bishop2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:0] setImg:kight2 and:[NSMutableString stringWithString:@"knight2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:0] setImg:rock2 and:[NSMutableString stringWithString:@"rock2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:1] setImg:pawn1 and:[NSMutableString stringWithString:@"pawn1"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:1] setImg:pawn2 and:[NSMutableString stringWithString:@"pawn2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:1] setImg:pawn3 and:[NSMutableString stringWithString:@"pawn3"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:1] setImg:pawn4 and:[NSMutableString stringWithString:@"pawn4"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:1] setImg:pawn5 and:[NSMutableString stringWithString:@"pawn5"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:1] setImg:pawn6 and:[NSMutableString stringWithString:@"pawn6"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:1] setImg:pawn7 and:[NSMutableString stringWithString:@"pawn7"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:1] setImg:pawn8 and:[NSMutableString stringWithString:@"pawn8"]and:1];

    
    
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:7] setImg:brock and:[NSMutableString stringWithString:@"brock"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:7] setImg:bknight and:[NSMutableString stringWithString:@"bknight"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:7] setImg:bbishop and:[NSMutableString stringWithString:@"bbishop"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:7] setImg:bking and:[NSMutableString stringWithString:@"bking"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:7] setImg:bqueen and:[NSMutableString stringWithString:@"bqueen"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:7] setImg:bbishop2 and:[NSMutableString stringWithString:@"bbishop2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:7] setImg:bkight2 and:[NSMutableString stringWithString:@"bknight2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:7] setImg:brock2 and:[NSMutableString stringWithString:@"brock2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:6] setImg:bpawn1 and:[NSMutableString stringWithString:@"bpawn1"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:6] setImg:bpawn2 and:[NSMutableString stringWithString:@"bpawn2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:6] setImg:bpawn3 and:[NSMutableString stringWithString:@"bpawn3"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:6] setImg:bpawn4 and:[NSMutableString stringWithString:@"bpawn4"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:6] setImg:bpawn5 and:[NSMutableString stringWithString:@"bpawn5"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:6] setImg:bpawn6 and:[NSMutableString stringWithString:@"bpawn6"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:6] setImg:bpawn7 and:[NSMutableString stringWithString:@"bpawn7"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:6] setImg:bpawn8 and:[NSMutableString stringWithString:@"bpawn8"]and:2];
    //[myBoard setPieceOnBoard:2 with:0 with:[[Piece alloc] initWithImg:space1 and:[NSMutableString stringWithString:@"empty"]and:0 with:2 with:0]];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:2] setImg:space1 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:2] setImg:space2 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:2] setImg:space3 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:2] setImg:space4 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:2] setImg:space5 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:2] setImg:space6 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:2] setImg:space7 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:2] setImg:space8 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:3] setImg:space9 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:3] setImg:space10 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:3] setImg:space11 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:3] setImg:space12 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:3] setImg:space13 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:3] setImg:space14 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:3] setImg:space15 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:3] setImg:space16 and:[NSMutableString stringWithString:@"empty"]and:0];
    
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:4] setImg:space17 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:4] setImg:space18 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:4] setImg:space19 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:4] setImg:space20 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:4] setImg:space21 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:4] setImg:space22 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:4] setImg:space23 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:4] setImg:space24 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:5] setImg:space25 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:5] setImg:space26 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:5] setImg:space27 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:5] setImg:space28 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:5] setImg:space29 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:5] setImg:space30 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:5] setImg:space31 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:5] setImg:space32 and:[NSMutableString stringWithString:@"empty"]and:0];
    //[myBoard setPieceOnBoard:2 with:1 with:[[Piece alloc] initWithImg:space2 and:[NSMutableString stringWithString:@"empty"]and:0 with:2 with:1]];
    //[myBoard setPieceOnBoard:2 with:2 with:[[Piece alloc] initWithImg:space3 and:[NSMutableString stringWithString:@"empty"]and:0 with:2 with:2]];
    X = 0;
    Y = 0;
    isTouched = 0;
    isMoved = 0;
    isDebug = 0;
    
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Compute the model view matrix for the object rendered with ES2
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
+(void)resize:(UIView*)view to:(CGSize)size withDuration:(int) duration andSnapBack:(BOOL) snapBack
{
    // Prepare the animation from the old size to the new size
    CGRect oldBounds = view.layer.bounds;
    CGRect newBounds = oldBounds;
    newBounds.size = size;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    
    // iOS
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    
    
    if(!snapBack)
    {
        // Update the layer’s bounds so the layer doesn’t snap back when the animation completes.
        view.layer.bounds = newBounds;
    }
    
    // Add the animation, overriding the implicit animation.
    [view.layer addAnimation:animation forKey:@"bounds"];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (Piece *)getMove:(UIImageView *) iView{
    //NSLog(@"in viewcontroller get move");
    for(NSMutableArray *v in [myBoard getPieceSet]) {
        for(Piece *p in v) {
            if([[p getImage] isEqual:iView]){
                //NSLog(@"found one");
                //NSLog(@"%d  %d",[p getX],[p getY]);
                return p;
            }
        }
    }
    return nil;
}
-(void)showAvailableMoves:(Piece *)pi{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
            for (UIImageView *iView in self.view.subviews) {
                Piece *temp = [self getMove:iView];
                                //if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && ![iView.image isEqual:[UIImage imageNamed:@"empty.png"]] && ([myBoard terms] == [temp getSide] || isDebug == 1))
                if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && (![[temp getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]]) && ([myBoard terms] == [temp getSide] || isDebug == 1)) {
                    if (touchPoint.x > iView.frame.origin.x &&
                        touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                        touchPoint.y > iView.frame.origin.y &&
                        touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                    {
                        NSLog(@"touched!");
                        [iView setAlpha:0.7];
                        isTouched = 1;
                        tempPiece = [self getMove:iView];
                        X = [tempPiece getX];
                        Y = [tempPiece getY];
                        self.dragObject = iView;
                        self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                       touchPoint.y - iView.frame.origin.y);
                        self.homePosition = CGPointMake(iView.frame.origin.x,
                                                        iView.frame.origin.y);
                        [self.view bringSubviewToFront:self.dragObject];
                        
                    }
                }
            }
    }
    if ([touches count] == 2) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        for (UIImageView *iView in self.view.subviews) {
            Piece *temp = [self getMove:iView];
            if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && (![[temp getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]]) && ([myBoard terms] == [temp getSide] || isDebug == 1)) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height) {
                    [self showAvailableMoves:temp];

                }

            }
        }
    }
    
    
//        else {
//            NSLog(@"in checked loop");
//            for (UIImageView *iView in self.view.subviews) {
//                Piece *temp = [self getMove:iView];
//                if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && ([iView.image isEqual:[UIImage imageNamed:@"king.png"]] || [iView.image isEqual:[UIImage imageNamed:@"bking.png"]]) && ([myBoard terms] == [temp getSide] || isDebug == 1)) {
//                    if (touchPoint.x > iView.frame.origin.x &&
//                        touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
//                        touchPoint.y > iView.frame.origin.y &&
//                        touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
//                    {
//                        NSLog(@"is checked touched!");
//                        [iView setAlpha:0.7];
//                        isTouched = 1;
//                        tempPiece = [self getMove:iView];
//                        X = [tempPiece getX];
//                        Y = [tempPiece getY];
//                        self.dragObject = iView;
//                        self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
//                                                       touchPoint.y - iView.frame.origin.y);
//                        self.homePosition = CGPointMake(iView.frame.origin.x,
//                                                        iView.frame.origin.y);
//                        [self.view bringSubviewToFront:self.dragObject];
//                        
//                    }
//                }
//            }
//        }
    
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoved == 0 && isTouched == 1) {
        NSLog(@"expanding");
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                               touchPoint.y - touchOffset.y,
                                               self.dragObject.frame.size.width + 20,
                                               self.dragObject.frame.size.height + 20);
        self.dragObject.frame = newDragObjectFrame;
        isMoved = 1;

    }
    else if(isTouched == 1){
        //NSLog(@"normal moving");
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                               touchPoint.y - touchOffset.y,
                                               self.dragObject.frame.size.width,
                                               self.dragObject.frame.size.height);
        self.dragObject.frame = newDragObjectFrame;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"in touches end %d",[myBoard terms]);
    [dragObject setAlpha:1];
    //switcher for iterating
    //int switcher = 0;
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (isTouched == 1 && isMoved == 1) {
        for (UIImageView *iView in self.view.subviews) {
            //NSLog(@"%d, %d",k++, isTouched);
            //enmu for 35 times wired
            if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && ![iView.image isEqual:[tempPiece getImage].image] ) {
                //NSLog(@"%d",k++);
                //NSLog(@"touchend succ");
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height )
                {
                    Piece *t = [self getMove:iView];
                    NSLog(@"setting backgroud");
                    if ([myBoard setMove:tempPiece to:t and:isDebug]) {
                        [myBoard changeTerms];
                    }

                }
//                self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
//                                                   self.dragObject.frame.size.width,
//                                                   self.dragObject.frame.size.height);

            }
//            if (isMoved == 1) {
//                
//
//                self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
//                                                   self.dragObject.frame.size.width - 20,
//                                                   self.dragObject.frame.size.height - 20);
//                isMoved = 0;
//            }
//            else {
//                self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
//                                                   self.dragObject.frame.size.width,
//                                                   self.dragObject.frame.size.height);
//            }
//            if (switcher == 1) {
//                //NSLog(@"switching to 0");
//                isTouched = 0;
//                
//                return;
//            }
        }
        isMoved = 0;
        isTouched = 0;
        self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                           self.dragObject.frame.size.width - 20,
                                           self.dragObject.frame.size.height - 20);
    }
//    else {
//        NSLog(@"in else ");
//        self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
//                                           self.dragObject.frame.size.width,
//                                           self.dragObject.frame.size.height);
//    }

}
//Use “.” in front of the location of aixes, type “move” command to force pieces move. For instance “move.0.0.2.2“ means move piece(0,0) to (2,2), it doesn’t go through any piece specific rules checking.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"here");
    if (textField == self.debuggingWindow) {
        if ([debuggingWindow.text rangeOfString:@"move"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            NSLog(@"%d %d to %d %d",X1,Y1,X2,Y2);
            [myBoard debugMove:[myBoard getPieceAt:X1 with:Y1] to:[myBoard getPieceAt:X2 with:Y2]];
            
        }
        else if ([debuggingWindow.text rangeOfString:@"debug mode off"].location != NSNotFound) {
            isDebug = 0;
        }
        else if ([debuggingWindow.text rangeOfString:@"debug mode on"].location != NSNotFound) {
            isDebug = 1;
        }
        else if ([debuggingWindow.text rangeOfString:@"require"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            NSLog(@"%@ side:%d",[[myBoard getPieceAt:X1 with:Y1] getName],[[myBoard getPieceAt:X1 with:Y1] getSide]);
        }
    }
    debuggingWindow.text = @"";
    return YES;
}
@end
