//
//  Rhombicuboctahedron.m
//  StagingArea
//
//  Created by Robby on 5/2/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import "Rhombicuboctahedron.h"
#import <OpenGLES/ES1/gl.h>

@interface Rhombicuboctahedron (){
    GLfloat quadVertices[3*4];
    GLfloat triVertices[3*3];
}

@end

@implementation Rhombicuboctahedron

-(id)init{
    self = [super init];
    if(self){
        NSLog(@"rhombicuboctahedron");
        [self setup];
    }
    return self;
}

-(void) draw{
    [self drawRoomWalls];
}

-(void) setup{
    [self fillQuad];
    [self fillTri];
}

-(void) fillQuad{
    quadVertices[0] = -1.0f;    quadVertices[1] = 1.0f;     quadVertices[2] = 0.0f;
    quadVertices[3] = -1.0f;    quadVertices[4] = -1.0f;    quadVertices[5] = 0.0f;
    quadVertices[6] = 1.0f;     quadVertices[7] = 1.0f;     quadVertices[8] = 0.0f;
    quadVertices[9] = 1.0f;     quadVertices[10] = -1.0f;   quadVertices[11] = 0.0f;
}

-(void) fillTri{
    triVertices[0] = 0.0f;      triVertices[1] = 0.71132486540518*sqrtf(3)/2.;                  triVertices[2] = 0.0f;
    triVertices[3] = 1.0f;      triVertices[4] = -0.28867513459482*sqrtf(3)/2.-sqrtf(3)/2.;     triVertices[5] = 0.0f;
    triVertices[6] = -1.0f;     triVertices[7] = -0.28867513459482*sqrtf(3)/2.-sqrtf(3)/2.;     triVertices[8] = 0.0f;
}

-(void) drawQuad{
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, quadVertices);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
}
-(void)drawTri{
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, triVertices);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableClientState(GL_VERTEX_ARRAY);
}
-(void)drawRoomWalls{
    glDisable(GL_CULL_FACE);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    static float dist = 2.82842712474619;//sqrtf(2)*2;
    
    glPushMatrix();
    glScalef(1.25, 1.25, 1.25);
    
    // SQUARE FACES
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    //ROTATION 1
    
    glPushMatrix();
    glRotatef(45, 0, 1, 0);
    
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    // ROTAITON 2
    glPushMatrix();
    glRotatef(45, 1, 0, 0);
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    // ROTATION 3
    glPushMatrix();
    glRotatef(45, 0, 0, 1);
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    // cut
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    // BOTTOM TRIANGLES
    glPushMatrix();
    glRotatef(45, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+90, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+180, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+270, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    
    
    // TOP TRIANGLES
    
    glPushMatrix();
    glRotatef(45, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+90, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+180, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+270, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    
    
    glPopMatrix();  // scale master
    
    
    glEnable(GL_CULL_FACE);
}


@end
