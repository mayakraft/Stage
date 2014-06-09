#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>
#import "Stage.h"
#include "StageCommon.h"

#import "Animation.h"
#import "Hotspot.h"
#import "OBJ.h"
#import "Camera.h"
#include "lights.c"

// ROOMS and SCREENS
#import "NavigationScreen.h"
#import "SquareRoom.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface Stage (){
    NSDate      *start;
    float       screenColor[4];
    
    AnimationState      cameraAnimationState;
    
    // CUSTOMIZE BELOW
    
    // ANIMATIONS
    Animation           *animationTransition;  // triggered by navbar forward/back
    Animation           *animationNewGeodesic; // triggered by loading new geodesic

    // ROOMS   (3D ENVIRONMENTS)
    SquareRoom          *squareRoom;

    // SCREENS (ORTHOGRAPHIC LAYERS)
    NavigationScreen    *navScreen;

    // CAMERAS
//    Camera              *camera;
    GLKQuaternion       orientation, quaternionFrontFacing;
    BOOL                orientToDevice;

    // OBJECTS
    OBJ *obj;
    
    // ANIMATION TRIGGERS
    BOOL _userInteractionEnabled;
    NSArray *hotspots;  // don't overlap hotspots, or re-write touch handling code
}

@end

@implementation Stage

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context{
    self = [super initWithFrame:frame context:context];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

-(void) setup{
    [self customizeOpenGL];
    
    squareRoom = [[SquareRoom alloc] init];

    navScreen = [[NavigationScreen alloc] initWithFrame:self.frame];
    [self addSubview:navScreen.view];     // add a screen's view or its UI elements won't show
    [navScreen setScene:(int*)&_scene];

    // camera
//    camera = [[Camera alloc] init];
//    set_up(&camera, 0, 1, 0);
//    set_position(&camera, 0, 0, camDistance);
//    set_focus(&camera, 0, 0, 0);
//    build_projection_matrix(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, 58);  // 60
  
//    GLKMatrix4 m = GLKMatrix4MakeLookAt(camera.distanceFromOrigin, 0, 0, 0, 0, 0, 0, 1, 0);
//    quaternionFrontFacing = GLKQuaternionMakeWithMatrix4(m);

    float arrowWidth = self.frame.size.width*.175;
    hotspots = @[ [Hotspot hotspotWithID:hotspotBackArrow Bounds:CGRectMake(5, 5, arrowWidth, arrowWidth)],
                  [Hotspot hotspotWithID:hotspotForwardArrow Bounds:CGRectMake(self.frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)],
                  [Hotspot hotspotWithID:hotspotControls Bounds:CGRectMake(0, self.frame.size.height-arrowWidth*2.5, self.frame.size.width, arrowWidth*2.5)]];
    
    start = [NSDate date];
    _userInteractionEnabled = true;
    orientToDevice = true;
 
    
    screenColor[0] = 0.0; screenColor[1] = 0.0; screenColor[2] = 0.0; screenColor[3] = 1.0;
}

-(void) customizeOpenGL{
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_CULL_FACE);
//    glCullFace(GL_FRONT);
//    glEnable(GL_DEPTH_TEST);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void) drawRect{
    static const GLfloat _unit_square[] = {
        -0.5f, 0.5f, 0.0,
        0.5f, 0.5f,  0.0,
        -0.5f, -0.5f,0.0,
        0.5f, -0.5f, 0.0
    };
    glPushMatrix();
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    glTranslatef(0, 0, 2.0);
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, _unit_square);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

-(void)draw{
    [self animationHandler];
    
    glClearColor(screenColor[0], screenColor[1], screenColor[2], screenColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // lighting independent of rotation
//    rainbow(screenColor, &one_f, &one_f);
    
//    glPushMatrix();
    if(orientToDevice){
//        _orientationMatrix = GLKMatrix4MakeLookAt(camera.distanceFromOrigin*_deviceAttitude[2], camera.distanceFromOrigin*_deviceAttitude[6], camera.distanceFromOrigin*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//        set_position(&camera, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
//        set_up(&camera, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
    }
//    frame_shot(&camera);
    
//    _orientationMatrix.m32 = -camera.distanceFromOrigin;

//    _orientationMatrix = GLKMatrix4Identity;

//    _orientationMatrix = GLKMatrix4MakeWithArray(_deviceAttitude);
//    glMultMatrixf(_orientationMatrix.m);
    
//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, zeroColor);
    
//    GLKMatrix4 m = _orientationMatrix;//GLKMatrix4MakeWithArray(_deviceAttitude);
//    NSLog(@"\n%f, %f, %f, %f\n %f, %f, %f, %f\n %f, %f, %f, %f\n %f, %f, %f, %f", m.m00, m.m01, m.m02, m.m03, m.m10, m.m11, m.m12, m.m13, m.m20, m.m21, m.m22, m.m23, m.m30, m.m31, m.m32, m.m33);

    // lighting rotates with orientation
//    rainbow(screenColor, &one_f, &one_f);
    

    glMultMatrixf(GLKMatrix4Identity.m);
    
//    if(obj)
//        [obj draw];

    glDisable(GL_LIGHTING);
    glDisable(GL_CULL_FACE);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
 
    if(squareRoom)
        [squareRoom draw];
    
    
//    glDisable(GL_LIGHTING);
//    glDisable(GL_CULL_FACE);
//    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
//    
    [self drawRect];
//
//    glPopMatrix();
    

//    if(animationNewGeodesic != nil){
//        float scale = 1.0-[animationNewGeodesic scale];  // this is getting called twice,
//        rainbow(screenColor, &one_f, &scale);
//        // draw more
//    }
    
    
//    if(navScreen)
//        [navScreen draw];
    
}
-(void) setScene:(Scene)scene{
//    reset_lighting();
    [navScreen hideElements];
    [[navScreen titleLabel] setText:[NSString stringWithFormat:@"SCENE %d",scene+1]];
    
    if(scene == scene1){
        [[navScreen button1] setHidden:NO];
        [[navScreen button2] setHidden:NO];
    }
    else if (scene == scene2){
        for (int i = 0; i < [[navScreen numberLabels] count]; i++)
            [[[navScreen numberLabels] objectAtIndex:i] setHidden:NO];
    }
    else if (scene == scene3){ }
    else if (scene == scene4){ }
    else if (scene == scene5){ }
    _scene = scene;
}

-(void) changeCameraAnimationState:(AnimationState) newState{
    if(newState == animationNone){
        if(cameraAnimationState == animationOrthoToPerspective){
            orientToDevice = true;
        }
    }
    else if(newState == animationPerspectiveToOrtho){
//        GLKMatrix4 m = GLKMatrix4Make(_orientationMatrix.m[0], _orientationMatrix.m[1], _orientationMatrix.m[2], _orientationMatrix.m[3],
//                                      _orientationMatrix.m[4], _orientationMatrix.m[5], _orientationMatrix.m[6], _orientationMatrix.m[7],
//                                      _orientationMatrix.m[8], _orientationMatrix.m[9], _orientationMatrix.m[10],_orientationMatrix.m[11],
//                                      _orientationMatrix.m[12],_orientationMatrix.m[13],_orientationMatrix.m[14],_orientationMatrix.m[15]);
        orientation = GLKQuaternionMakeWithMatrix4(_orientationMatrix);
        orientToDevice = false;
    }
    cameraAnimationState = newState;
}

-(void)animationDidStop:(Animation *)a{
    if([a isEqual:animationNewGeodesic]){
        
    }
    if([a isEqual:animationTransition]){
        if(cameraAnimationState == animationOrthoToPerspective) // this stuff could go into the function pointer function
            orientToDevice = true;
        cameraAnimationState = animationNone;
    }
}

-(void) animationHandler{
    _elapsedSeconds = -[start timeIntervalSinceNow];

    // list all animations
    if(animationNewGeodesic)
        animationNewGeodesic = [animationNewGeodesic step];
    if(animationTransition)
        animationTransition = [animationTransition step];
    
    
    
    if(animationTransition != nil){

        float frame = [animationTransition scale];
        if(frame > 1) frame = 1.0;
        if(cameraAnimationState == animationPerspectiveToOrtho){
            GLKQuaternion q = GLKQuaternionSlerp(orientation, quaternionFrontFacing, powf(frame,2));
            _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
//            [camera dollyZoomFlat:powf(frame,3)];
        }
        if(cameraAnimationState == animationOrthoToPerspective){
//            GLKMatrix4 m = GLKMatrix4MakeLookAt(camera.distanceFromOrigin*_deviceAttitude[2], camera.distanceFromOrigin*_deviceAttitude[6], camera.distanceFromOrigin*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//            GLKQuaternion mtoq = GLKQuaternionMakeWithMatrix4(m);
//            GLKQuaternion q = GLKQuaternionSlerp(quaternionFrontFacing, mtoq, powf(frame,2));
//            _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
//            [camera dollyZoomFlat:powf(1-frame,3)];
        }
        if(cameraAnimationState == animationPerspectiveToInside){
//            [camera flyToCenter:frame];
        }
        if(cameraAnimationState == animationInsideToPerspective){
//            [camera flyToCenter:1-frame];
        }
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_userInteractionEnabled){
        for(UITouch *touch in touches){
            for(Hotspot *spot in hotspots){
                if(CGRectContainsPoint([spot bounds], [touch locationInView:self])){
                    // customize response to each touch area
                    if([spot ID] == hotspotBackArrow) { }
                    if([spot ID] == hotspotForwardArrow) { }
                    if([spot ID] == hotspotControls) { }
                    break;
                }
            }
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_userInteractionEnabled){
        for(UITouch *touch in touches){
            for(Hotspot *spot in hotspots){
                if(CGRectContainsPoint([spot bounds], [touch locationInView:self])){
                    // customize response to each touch area
                    if([spot ID] == hotspotBackArrow) { }
                    if([spot ID] == hotspotForwardArrow) { }
                    if([spot ID] == hotspotControls && _scene == scene2){
                        float freq = ([touch locationInView:self].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.);
                        if(freq < 0) freq = 0;
                        if(freq > 8) freq = 8;
                        [navScreen setRadioBarPosition:freq];
                    }
                    break;
                }
            }
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_userInteractionEnabled){
        for(UITouch *touch in touches){
            for(Hotspot *spot in hotspots){
                if(CGRectContainsPoint([spot bounds], [touch locationInView:self])){
                    // customize response to each touch area
                    if([spot ID] == hotspotBackArrow && _scene > scene1){
                        animationTransition = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.2];
                        if(_scene == scene2)
                            [self changeCameraAnimationState:animationOrthoToPerspective];
                        if(_scene == scene5)
                            [self changeCameraAnimationState:animationInsideToPerspective];
                        if (_scene-1 == scene3)
                            [self changeCameraAnimationState:animationPerspectiveToOrtho];
                        if (_scene-1 == scene5)
                            [self changeCameraAnimationState:animationPerspectiveToInside];
                        [self setScene:_scene-1];
                    }
                    else if([spot ID] == hotspotForwardArrow && _scene < scene5){
                        if(_scene == scene3)
                            [self changeCameraAnimationState:animationOrthoToPerspective];
                        if(_scene == scene5)
                            [self changeCameraAnimationState:animationInsideToPerspective];
                        if (_scene+1 == scene2)
                            [self changeCameraAnimationState:animationPerspectiveToOrtho];
                        if (_scene+1 == scene5)
                            [self changeCameraAnimationState:animationPerspectiveToInside];
                        animationTransition = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.2];
                        [self setScene:_scene+1];
                    }
                    else if([spot ID] == hotspotControls){
                        if(_scene == scene1){
                            if([touch locationInView:self].x < self.frame.size.width*.5){
                                
                            }
                            else if([touch locationInView:self].x > self.frame.size.width*.5){
                                
                            }
                        }
                        if(_scene == scene2){
                            int freq = ([touch locationInView:self].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.);
                            if(freq < 0) freq = 0;
                            if(freq > 8) freq = 8;
                            [navScreen setRadioBarPosition:freq];
                            animationNewGeodesic = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.5];
                        }
                    }
                    break;
                }
            }
        }
    }
}


-(void) tearDownGL{
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end