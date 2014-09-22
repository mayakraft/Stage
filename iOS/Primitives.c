#import <OpenGLES/ES1/gl.h>

#define Z_NEAR 0.1f
#define Z_FAR 100.0f

//static float zeroColor[4] = {0.0f, 0.0f, 0.0f, 0.0f};
//
//static float blackColor[4] = {0.0f, 0.0f, 0.0f, 1.0f};
//static float whiteColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};
//
//static float redColor[4]  = {1.0f, 0.0f, 0.0f, 1.0f};
//static float greenColor[4]= {0.0f, 1.0f, 0.0f, 1.0f};
//static float blueColor[4] = {0.0f, 0.0f, 1.0f, 1.0f};
//
//static float white10Color[4] = {1.0f, 1.0f, 1.0f, 0.1f};
//static float white20Color[4] = {1.0f, 1.0f, 1.0f, 0.2f};
//static float white30Color[4] = {1.0f, 1.0f, 1.0f, 0.3f};
//static float white40Color[4] = {1.0f, 1.0f, 1.0f, 0.4f};
//static float white50Color[4] = {1.0f, 1.0f, 1.0f, 0.5f};
//static float white60Color[4] = {1.0f, 1.0f, 1.0f, 0.6f};
//static float white70Color[4] = {1.0f, 1.0f, 1.0f, 0.7f};
//static float white80Color[4] = {1.0f, 1.0f, 1.0f, 0.8f};
//static float white90Color[4] = {1.0f, 1.0f, 1.0f, 0.9f};
//
//static float black10Color[4] = {0.0f, 0.0f, 0.0f, 0.1f};
//static float black20Color[4] = {0.0f, 0.0f, 0.0f, 0.2f};
//static float black30Color[4] = {0.0f, 0.0f, 0.0f, 0.3f};
//static float black40Color[4] = {0.0f, 0.0f, 0.0f, 0.4f};
//static float black50Color[4] = {0.0f, 0.0f, 0.0f, 0.5f};
//static float black60Color[4] = {0.0f, 0.0f, 0.0f, 0.6f};
//static float black70Color[4] = {0.0f, 0.0f, 0.0f, 0.7f};
//static float black80Color[4] = {0.0f, 0.0f, 0.0f, 0.8f};
//static float black90Color[4] = {0.0f, 0.0f, 0.0f, 0.9f};
//
//static float one_f = 1.0f;

//void drawRect(CGRect rect){
//    static const GLfloat _unit_square[] = {
//        -0.5f, 0.5f,
//        0.5f, 0.5f,
//        -0.5f, -0.5f,
//        0.5f, -0.5f
//    };
//    glPushMatrix();
//    glTranslatef(rect.origin.x, rect.origin.y, 0.0);
//    glScalef(rect.size.width, rect.size.height, 1.0);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glVertexPointer(2, GL_FLOAT, 0, _unit_square);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glPopMatrix();
//}
//
//void drawRectOutline(CGRect rect){
//    static const GLfloat _unit_square_outline[] = {
//        -0.5f, 0.5f,
//        0.5f, 0.5f,
//        0.5f, -0.5f,
//        -0.5f, -0.5f
//    };
//    glPushMatrix();
//    glTranslatef(rect.origin.x, rect.origin.y, 0.0);
//    glScalef(rect.size.width, rect.size.height, 1.0);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glVertexPointer(2, GL_FLOAT, 0, _unit_square_outline);
//    glDrawArrays(GL_LINE_LOOP, 0, 4);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glPopMatrix();
//}

void drawPentagon(){
    static const GLfloat pentFan[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        .951f, .309f,
        .5878, -.809,
        -.5878, -.809,
        -.951f, .309f,
        0.0f, 1.0f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, pentFan);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 8);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void drawPentagonOutline(){
    static const GLfloat pentVertices[] = {
        0.0f, 1.0f,
        .951f, .309f,
        .5878, -.809,
        -.5878, -.809,
        -.951f, .309f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, pentVertices);
    glDrawArrays(GL_LINE_LOOP, 0, 6);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void drawHexagon(){
    static const GLfloat hexFan[] = {
        0.0f, 0.0f,
        -.5f, -.8660254f,
        -1.0f, 0.0f,
        -.5f, .8660254f,
        .5f, .8660254f,
        1.0f, 0.0f,
        .5f, -.8660254f,
        -.5f, -.8660254f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, hexFan);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 8);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void drawHexagonOutline(){
    static const GLfloat hexVertices[] = {
        -.5f, -.8660254f, -1.0f, 0.0f, -.5f, .8660254f,
        .5f, .8660254f,    1.0f, 0.0f,  .5f, -.8660254f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, hexVertices);
    glDrawArrays(GL_LINE_LOOP, 0, 6);
    glDisableClientState(GL_VERTEX_ARRAY);
}

//void drawRectRotated(CGRect rect, float degrees){
//    static const GLfloat _unit_square[] = {
//        -0.5f, 0.5f,
//        0.5f, 0.5f,
//        -0.5f, -0.5f,
//        0.5f, -0.5f
//    };
//    glPushMatrix();
//    glTranslatef(rect.origin.x, rect.origin.y, 0.0);
//    glScalef(rect.size.width, rect.size.height, 1.0);
//    glRotatef(degrees, 0, 0, 1);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glVertexPointer(2, GL_FLOAT, 0, _unit_square);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glPopMatrix();
//}
