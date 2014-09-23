#ifndef TWO_DIMENSIONAL_OPENGL_PRIMITIVES
#define TWO_DIMENSIONAL_OPENGL_PRIMITIVES

#import <OpenGLES/ES1/gl.h>
#import <UIKit/UIKit.h>

static float glZeroColor[4] = {0.0f, 0.0f, 0.0f, 0.0f};

static float glBlackColor[4] = {0.0f, 0.0f, 0.0f, 1.0f};
static float glWhiteColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};

static float glRedColor[4]  = {1.0f, 0.0f, 0.0f, 1.0f};
static float glGreenColor[4]= {0.0f, 1.0f, 0.0f, 1.0f};
static float glBlueColor[4] = {0.0f, 0.0f, 1.0f, 1.0f};

static float glWhite10Color[4] = {1.0f, 1.0f, 1.0f, 0.1f};
static float glWhite20Color[4] = {1.0f, 1.0f, 1.0f, 0.2f};
static float glWhite30Color[4] = {1.0f, 1.0f, 1.0f, 0.3f};
static float glWhite40Color[4] = {1.0f, 1.0f, 1.0f, 0.4f};
static float glWhite50Color[4] = {1.0f, 1.0f, 1.0f, 0.5f};
static float glWhite60Color[4] = {1.0f, 1.0f, 1.0f, 0.6f};
static float glWhite70Color[4] = {1.0f, 1.0f, 1.0f, 0.7f};
static float glWhite80Color[4] = {1.0f, 1.0f, 1.0f, 0.8f};
static float glWhite90Color[4] = {1.0f, 1.0f, 1.0f, 0.9f};

static float glBlack10Color[4] = {0.0f, 0.0f, 0.0f, 0.1f};
static float glBlack20Color[4] = {0.0f, 0.0f, 0.0f, 0.2f};
static float glBlack30Color[4] = {0.0f, 0.0f, 0.0f, 0.3f};
static float glBlack40Color[4] = {0.0f, 0.0f, 0.0f, 0.4f};
static float glBlack50Color[4] = {0.0f, 0.0f, 0.0f, 0.5f};
static float glBlack60Color[4] = {0.0f, 0.0f, 0.0f, 0.6f};
static float glBlack70Color[4] = {0.0f, 0.0f, 0.0f, 0.7f};
static float glBlack80Color[4] = {0.0f, 0.0f, 0.0f, 0.8f};
static float glBlack90Color[4] = {0.0f, 0.0f, 0.0f, 0.9f};

static float one_f = 1.0f;

void glDrawTriangle(){
    static const GLfloat triVertices[] = {
        0.0f, 0.57735f,
        .5, -0.288675f,
        -.5, -0.288675f,
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, triVertices);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void glDrawTriangleOutline(){
    static const GLfloat triVertices[] = {
        0.0f, 0.57735f,
        .5, -0.288675f,
        -.5, -0.288675f,
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, triVertices);
    glDrawArrays(GL_LINE_LOOP, 0, 3);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void glDrawRect(CGRect rect){
    static const GLfloat _unit_square[] = {
        -0.5f, 0.5f,
        0.5f, 0.5f,
        -0.5f, -0.5f,
        0.5f, -0.5f
    };
    glPushMatrix();
    glTranslatef(rect.origin.x, rect.origin.y, 0.0);
    glScalef(rect.size.width, rect.size.height, 1.0);
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, _unit_square);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

void glDrawRectOutline(CGRect rect){
    static const GLfloat _unit_square_outline[] = {
        -0.5f, 0.5f,
        0.5f, 0.5f,
        0.5f, -0.5f,
        -0.5f, -0.5f
    };
    glPushMatrix();
    glTranslatef(rect.origin.x, rect.origin.y, 0.0);
    glScalef(rect.size.width, rect.size.height, 1.0);
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, _unit_square_outline);
    glDrawArrays(GL_LINE_LOOP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

void glDrawPentagon(){
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
    glDrawArrays(GL_TRIANGLE_FAN, 0, 7);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void glDrawPentagonOutline(){
    static const GLfloat pentVertices[] = {
        0.0f, 1.0f,
        .951f, .309f,
        .5878, -.809,
        -.5878, -.809,
        -.951f, .309f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, pentVertices);
    glDrawArrays(GL_LINE_LOOP, 0, 5);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void glDrawHexagon(){
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

void glDrawHexagonOutline(){
    static const GLfloat hexVertices[] = {
        -.5f, -.8660254f, -1.0f, 0.0f, -.5f, .8660254f,
        .5f, .8660254f,    1.0f, 0.0f,  .5f, -.8660254f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, hexVertices);
    glDrawArrays(GL_LINE_LOOP, 0, 6);
    glDisableClientState(GL_VERTEX_ARRAY);
}

void glDrawRectRotated(CGRect rect, float degrees){
    static const GLfloat _unit_square[] = {
        -0.5f, 0.5f,
        0.5f, 0.5f,
        -0.5f, -0.5f,
        0.5f, -0.5f
    };
    glPushMatrix();
    glTranslatef(rect.origin.x, rect.origin.y, 0.0);
    glScalef(rect.size.width, rect.size.height, 1.0);
    glRotatef(degrees, 0, 0, 1);
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, _unit_square);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
}

#endif