//
//  Stage.m
//  StagingArea
//
//  Created by Robby Kraft on 3/29/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>
#import "Stage.h"

#import "GeodesicMesh.h"
#import "Geodesic.h"
#import "Camera.h"

// attach the lights to the orientation matrix
// so the rainbow always hits from a visible angle

@interface Stage (){
    GeodesicMesh polyhedron;
    Geodesic geodesic;
    Camera camera;
}

@end

@implementation Stage

-(id)init{
    self = [super init];
    if(self){
//        [self initLighting];
        camera.position[0] = 0.0f;
        camera.position[1] = 0.0f;
        camera.position[2] = 2.0f;
        camera.focus[0] = 0.0f;
        camera.focus[1] = 0.0f;
        camera.focus[2] = 0.0f;
        camera.up[0] = 0.0f;
        camera.up[1] = 1.0f;
        camera.up[2] = 0.0f;

        float aspectRatio = (float)[[UIScreen mainScreen] bounds].size.width / (float)[[UIScreen mainScreen] bounds].size.height;
        if([UIApplication sharedApplication].statusBarOrientation > 2)
            aspectRatio = 1/aspectRatio;
        printf("ASPR %f",aspectRatio);
        camera.setAspectRatio(aspectRatio);
        camera.setFieldOfView(25);
        camera.setFrame([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

        [self customOpenGL];
        
        [self loadRandomGeodesic];
        
//        camera.animation = camera.animationUpAndDownAndAround;
        
    }
    return self;
}

-(void) customOpenGL{
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
}

-(void)loadRandomGeodesic{
    if(arc4random()%3 == 0)
        geodesic.tetrahedron(arc4random()%12+1);
    else if(arc4random()%2 == 0)
        geodesic.octahedron(arc4random()%12+1);
    else
        geodesic.icosahedron(arc4random()%12+1);
    polyhedron.load(&geodesic);
}

-(void) tableTopPerspective{
    float fieldOfView = 25;
    float aspectRatio = (float)[[UIScreen mainScreen] bounds].size.width / (float)[[UIScreen mainScreen] bounds].size.height;
    if([UIApplication sharedApplication].statusBarOrientation > 2)
        aspectRatio = 1/aspectRatio;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    float zNear = 0.01;
    float zFar = 100;
    GLfloat frustum = zNear * tanf(fieldOfView * 0.00872664625997);
    glFrustumf(-frustum, frustum, -frustum/aspectRatio, frustum/aspectRatio, zNear, zFar);
    glViewport(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
}

-(NSString*)makeOBJ{
    char *obj;
    int length = 0;
    geodesic.OBJ(obj, length);
    NSString *objString = [NSString stringWithUTF8String:obj];
//    NSLog(@"OBJ (%d)\n%@",length,objString);
//    delete obj;
    return objString;
}

-(void)draw{
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    static const GLfloat XAxis[] = {-1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f};
    static const GLfloat YAxis[] = {0.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f};
    static const GLfloat ZAxis[] = {0.0f, 0.0f, -1.0f, 0.0f, 0.0f, 1.0f};
    
    glPushMatrix();
    camera.frameShot();
    
    glLineWidth(1.0);
    glColor4f(0.5, 0.5, 1.0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, XAxis);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    glVertexPointer(3, GL_FLOAT, 0, YAxis);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    glVertexPointer(3, GL_FLOAT, 0, ZAxis);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    
    glScalef(0.25, 0.25, 0.25);
    polyhedron.draw();
//    polyhedron.drawFaceNormalLines();
//    polyhedron.drawNormalLines();
//    polyhedron.drawPoints();
    
    glPopMatrix();
}

// bottom graphs
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    if(0){
//        [self enterOrthographic];
//
//        glPushMatrix();
//
//        glEnableClientState(GL_VERTEX_ARRAY);
//        glScalef(screenSize.width/aspectRatio, 5, 1);
//        glColor4f(1.0, 0.0, 0.0, 0.5);
//        //        glVertexPointer(2, GL_FLOAT, 0, accelMagnitude);
//        //        glDrawArrays(GL_TRIANGLE_STRIP, 0, (recordIndex)*2);
//        glDisableClientState(GL_VERTEX_ARRAY);
//
//        glColor4f(1.0, 0.0, 0.0, 1.0);
//        //        GLfloat timeVector[] = {accelMagnitude[4*i], accelMagnitude[4*i+1], accelMagnitude[4*i+2], accelMagnitude[4*i+3]};
//        //        glVertexPointer(2, GL_FLOAT, 0, timeVector);
//        glEnableClientState(GL_VERTEX_ARRAY);
//        glDrawArrays(GL_LINE_LOOP, 0, 2);
//
//        glPopMatrix();
//
//        glPushMatrix();
//
//        glEnableClientState(GL_VERTEX_ARRAY);
//        glTranslatef(0.0,screenSize.height*aspectRatio, 0);
//        glScalef(screenSize.width/aspectRatio, 5, 1);
//        glColor4f(0.0, 0.0, 1.0, 0.5);
//        //        glVertexPointer(2, GL_FLOAT, 0, rotationMagnitude);
//        //        glDrawArrays(GL_TRIANGLE_STRIP, 0, (recordIndex)*2);
//        glDisableClientState(GL_VERTEX_ARRAY);
//
//        glColor4f(0.0, 0.0, 1.0, 1.0);
//        //        GLfloat timeVector2[] = {rotationMagnitude[4*i], rotationMagnitude[4*i+1], rotationMagnitude[4*i+2], rotationMagnitude[4*i+3]};
//        //        glVertexPointer(2, GL_FLOAT, 0, timeVector2);
//        glEnableClientState(GL_VERTEX_ARRAY);
//        glDrawArrays(GL_LINE_LOOP, 0, 2);
//
//        glPopMatrix();
//
//        [self exitOrthographic];
//    }


-(void)initLighting{
    GLfloat white[] = {.3f, .3f, .3f, 1.0f};
    GLfloat blue[] = {0.0f, 0.0f, 1.0f, 1.0f};
    GLfloat green[] = {0.0f, 1.0f, 0.0f, 1.0f};
    GLfloat red[] = {1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat pos1[] = {0.0f, 10.0f, 0.0f, 1.0f};
    GLfloat pos2[] = {-10.0f, 0.0f, 0.0f, 1.0f};
    GLfloat pos3[] = {10.0f, 0.0f,  0.0f, 1.0f};
    
    glLightfv(GL_LIGHT0, GL_AMBIENT, white);
    glLightfv(GL_LIGHT1, GL_POSITION, pos1);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, blue);
    glLightfv(GL_LIGHT2, GL_POSITION, pos2);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, red);
    glLightfv(GL_LIGHT3, GL_POSITION, pos3);
    glLightfv(GL_LIGHT3, GL_DIFFUSE, green);
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, white);
//    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, blue);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
//    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
    glEnable(GL_LIGHT3);
}

-(void)enterOrthographic{
    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, [[UIScreen mainScreen] bounds].size.height, 0, [[UIScreen mainScreen] bounds].size.width, -5, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

-(void)exitOrthographic{
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}


@end
