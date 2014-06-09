#import "SquareRoom.h"
#import <OpenGLES/ES1/gl.h>

@interface SquareRoom (){
    GLfloat quadVertices[3*4];
}

@end

@implementation SquareRoom

-(void) setup{
    [self fillQuad];
}

-(void) draw{
    [self drawRoomWalls];
}

-(void) fillQuad{
    quadVertices[0] = -1.0f;    quadVertices[1] = 1.0f;     quadVertices[2] = 0.0f;
    quadVertices[3] = -1.0f;    quadVertices[4] = -1.0f;    quadVertices[5] = 0.0f;
    quadVertices[6] = 1.0f;     quadVertices[7] = 1.0f;     quadVertices[8] = 0.0f;
    quadVertices[9] = 1.0f;     quadVertices[10] = -1.0f;   quadVertices[11] = 0.0f;
}

-(void) drawQuad{
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, quadVertices);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)drawRoomWalls{
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
    
    glPopMatrix();  // scale master

}


@end
