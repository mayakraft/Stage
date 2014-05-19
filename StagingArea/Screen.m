
#import "Screen.h"
#import <OpenGLES/ES1/gl.h>

@interface Screen (){
    float _aspectRatio;
    float width, height;
}
@end

@implementation Screen

-(id) init{
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

-(id) initWithFrame:(CGRect)frame{
    self = [super init];
    if(self){
        _frame = frame;
        [self setup];
    }
    return self;
}

-(void) setup{
    width = _frame.size.width;
    height = _frame.size.height;
    _aspectRatio = _frame.size.width/_frame.size.height;
}

-(void) draw{
    [self enterOrthographic];
    [self customDraw];
    [self exitOrthographic];
}

-(void) customDraw{
    // implement this function
    // in your subclass
}

-(void)enterOrthographic{
    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, width, 0, height, -5, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

-(void)exitOrthographic{
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

@end
