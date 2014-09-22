//
//  GameViewController.m
//  Stage
//
//  Created by Robby on 9/19/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "Stage.h"
#import <OpenGLES/ES2/glext.h>

#import "SWRevealViewController.h"
#import "GLScrollView.h"
#import "ScreenView.h"

/// custom
#import "NavBar.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

///////////////////////////
///////////////
//// okay
///////what is happening underneath the hood, with a UIView,
/// where is the master draw loop, and what function is getting called inside a UIView
/// to draw the stuff inside it
//////////
///
///
////////



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

@interface Stage () <NavBarDelegate> {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    /////////////////////////////////////////
    
    GLScrollView *glScrollView;
    CADisplayLink *_displayLink;
    
    ////////////////////////////////////////
    
    NSDate      *start;

}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation Stage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
//    [self setupGL];
    
    ////////////////////////////////////////////////////
    
    start = [NSDate date];
    _backgroundColor = malloc(sizeof(float)*4);
    
    NavBar *navBar = [NavBar navBarBottom];
    [navBar setDelegate:self];
    [self addSubscreen:navBar];
    
    ////////////////////////////////////////////////////
    
    glScrollView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*.6, self.view.bounds.size.width, self.view.bounds.size.height*.2)];
    [glScrollView.view setBackgroundColor:[UIColor lightGrayColor]];
    UIView *darkGray = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, glScrollView.frame.size.height)];
    [darkGray setBackgroundColor:[UIColor darkGrayColor]];
    [glScrollView.view addSubview:darkGray];
    [glScrollView.view setUserInteractionEnabled:NO];
    [darkGray setUserInteractionEnabled:NO];
    [self.view addSubview:glScrollView.view];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = glScrollView.frame;
    scrollView.contentSize = CGSizeMake(glScrollView.frame.size.width*3, glScrollView.frame.size.height);//glScrollView.scrollableContentSize;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setPagingEnabled:YES];
    scrollView.delegate = self;
    scrollView.tag = 0;
    scrollView.hidden = YES;
    [self.view addSubview:scrollView];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:scrollView.frame];
//    [dummyView setBackgroundColor:[UIColor clearColor]];
    [dummyView addGestureRecognizer:scrollView.panGestureRecognizer];
    [self.view addSubview:dummyView];
    
//    GLView *glView = [[GLView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [self addSubglview:glView];
    
    ///////////////////////////////////////////////////
    // Reveal Menu
    ///////////////////////////////////////////////////
    
    SWRevealViewController *revealController = [self revealViewController];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menuButton setFrame:CGRectMake(10, 10+22, 44, 44)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    [menuButton addGestureRecognizer:revealController.panGestureRecognizer];
    
    GLView *glkv = [[GLView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) ];
    [(GLKView *)self.view addSubview:glkv];
}


-(void) addSubscreen:(ScreenView *)screenView{
    if(!_screenViews) _screenViews = [NSArray array];
    _screenViews = [_screenViews arrayByAddingObject:screenView];
    [self.view addSubview:screenView.view];
}
-(void) addSubroom:(Room *)room{
    if(!_rooms) _rooms = [NSArray array];
    _rooms = [_rooms arrayByAddingObject:room];
}

#pragma mark- DELEGATES

// NAVIGATION CONTROLLER
-(void) pageTurnBack:(NSInteger)page{
    [_scene gotoScene:page withDuration:1.0];
}
-(void) pageTurnForward:(NSInteger)page{
    [_scene gotoScene:page withDuration:1.0];
}

// ANIMATION CONTROLLER
-(void) beginTransitionFrom:(unsigned short)fromScene To:(unsigned short)toScene{
    NSLog(@"+++ BEGIN transition:%d-%d",fromScene, toScene);
}
-(void) endTransitionFrom:(unsigned short)fromScene To:(unsigned short)toScene{
    NSLog(@"---  END  transition:%d-%d",fromScene, toScene);
}
-(void) transitionFrom:(unsigned short)fromScene To:(unsigned short)toScene Tween:(float)t{
//    NSLog(@"delegate transition:%d-%d, %f",fromScene, toScene, t);
}


/////////////////////////////
///// SCROLL VIEW STUFF /////
/////////////////////////////

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrolling: %f",scrollView.contentOffset.x);
//    for every scrollView
//    if(scrollView.tag == 0)
    glScrollView.scrollOffset = scrollView.contentOffset;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self startDisplayLinkIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stopDisplayLink];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrolling stopped");
    [self stopDisplayLink];
}

// uncomment this method to force the scrollView to land on a little cube boundary
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    *targetContentOffset = [_cubeView scrollOffsetForProposedOffset:*targetContentOffset];
//}

#pragma mark Display Link

- (void)startDisplayLinkIfNeeded
{
    if (!_displayLink) {
        NSLog(@"display link");
        _displayLink = [CADisplayLink displayLinkWithTarget:(GLKView*)self selector:@selector(auxDraw)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    }
}
-(void) auxDraw{
    [self update];
    [(GLKView*)self.view display];
}
- (void)stopDisplayLink
{
    NSLog(@"stopping display link");
    if(_displayLink)
        [_displayLink invalidate];
    _displayLink = nil;
}

/////////////////////////////////
///// END SCROLL VIEW STUFF /////
/////////////////////////////////


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
//    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
//    
//    self.effect.transform.projectionMatrix = projectionMatrix;
//    
//    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
//    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
//    
//    // Compute the model view matrix for the object rendered with GLKit
//    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
//    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
//    
//    self.effect.transform.modelviewMatrix = modelViewMatrix;
//    
//    // Compute the model view matrix for the object rendered with ES2
//    modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
//    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
//    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
//    
//    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
//    
//    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
//    
//    _rotation = _elapsedSeconds;
////    _rotation += self.timeSinceLastUpdate * 0.5f;
    
    ////////////////////////////////////////////////
    
    
    _elapsedSeconds = -[start timeIntervalSinceNow];
//    [self animationHandler];
    
//    if([motionManager isDeviceMotionAvailable]){
//        CMRotationMatrix m = motionManager.deviceMotion.attitude.rotationMatrix;
//        _deviceAttitude = GLKMatrix4MakeLookAt(m.m31, m.m32, m.m33, 0, 0, 0, m.m21, m.m22, m.m23);
//    }
    
//    NSLog(@"--------------------");
//    for(id view in self.view.subviews){
//        if([view isKindOfClass:[GLView class]]){//[view respondsToSelector:@selector(setNeedsDisplay)]){
//            NSLog(@"triggering a display (%f, %f)",[view frame].origin.x, [view frame].origin.y);
//            [view setNeedsDisplay];
//        }
//    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//    glBindVertexArrayOES(_vertexArray);
//    
//    // Render the object with GLKit
//    [self.effect prepareToDraw];
//    
//    glDrawArrays(GL_TRIANGLES, 0, 36);
//    
//    // Render the object again with ES2
//    glUseProgram(_program);
//    
//    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
//    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
//    
//    glDrawArrays(GL_TRIANGLES, 0, 36);
//    
//    glUseProgram(0);
    
    for(id view in self.view.subviews){
        if([view isKindOfClass:[GLView class]]){//[view respondsToSelector:@selector(setNeedsDisplay)]){
//            NSLog(@"manually inserting display (%f, %f)",[view frame].origin.x, [view frame].origin.y);
            [view draw];
        }
    }
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

@end
