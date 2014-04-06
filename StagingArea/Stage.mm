//
//  Stage.m
//  StagingArea
//
//  Created by Robby Kraft on 3/29/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import "Stage.h"
#import <OpenGLES/ES1/gl.h>

#import "GeodesicMesh.h"
#import "Geodesic.h"

// attach the lights to the orientation matrix
// so the rainbow always hits from a visible angle

@interface Stage (){
    GeodesicMesh polyhedron;
    Geodesic geodesic;
}

@end

@implementation Stage

-(id)init{
    self = [super init];
    if(self){
//        [self initLighting];
        [self loadRandom];
    }
    return self;
}

-(void)loadRandom{
    if(arc4random()%3 == 0)
        geodesic.tetrahedron(arc4random()%12+1);
    else if(arc4random()%2 == 0)
        geodesic.octahedron(arc4random()%12+1);
    else
        geodesic.icosahedron(arc4random()%12+1);
    polyhedron.load(&geodesic);
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
    static float screenRotate;
    
    static const GLfloat XAxis[] = {-1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f};
    static const GLfloat YAxis[] = {0.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f};
    static const GLfloat ZAxis[] = {0.0f, 0.0f, -1.0f, 0.0f, 0.0f, 1.0f};
    
    glPushMatrix();
    
    glTranslatef(0.0, 0.0, -2.0);
    glRotatef(10.0, 1.0, 0.0, 0.0);
    glRotatef(screenRotate/2.0, 0.0, 1.0, 0.0);
    
    glLineWidth(1.0);
    glColor4f(0.5, 0.5, 1.0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, XAxis);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    glVertexPointer(3, GL_FLOAT, 0, YAxis);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    glVertexPointer(3, GL_FLOAT, 0, ZAxis);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    
    glPushMatrix();
    glScalef(0.25, 0.25, 0.25);
    polyhedron.draw();
//    polyhedron.drawFaceNormalLines();
//    polyhedron.drawNormalLines();
//    polyhedron.drawPoints();
    glPopMatrix();
    
    glPopMatrix();
    
    screenRotate++;
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
