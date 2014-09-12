#import <OpenGLES/ES1/gl.h>
#import "Curtain.h"

@interface Curtain (){
    float _aspectRatio;
    float width, height;
}
@end

@implementation Curtain

-(id) init{
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

-(id) initWithFrame:(CGRect)frame{
    self = [super init];
    if(self){
        _frame = frame;
        _view = [[UIView alloc] initWithFrame:frame];
        width = _frame.size.width;
        height = _frame.size.height;
        _aspectRatio = _frame.size.width/_frame.size.height;
        [self setup];
    }
    return self;
}

-(void) setHidden:(BOOL)hidden{
    _hidden = hidden;
    [_view setHidden:hidden];
}

-(void) setX:(float)x{
    _x = x;
    _frame = CGRectMake(x, _frame.origin.y, _frame.size.width, _frame.size.height);
    [_view setFrame:_frame];
}

-(void) setY:(float)y{
    _y = y;
    _frame = CGRectMake(_frame.origin.x, y, _frame.size.width, _frame.size.height);
    [_view setFrame:_frame];
}

-(void) draw{
    [self enterOrthographic];
    glTranslatef(_x, _y, 0.0);
    [self customDraw];
    [self exitOrthographic];
}

-(void) customDraw{
    // implement this function
    // in your subclass
}

-(void) setup{
    // implement this function
    // in your subclass
}

//-(void) setNeedsLayout{ }

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { }
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { }
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { }

-(void)enterOrthographic{
    glDisable(GL_DEPTH_TEST);
//    glDisable(GL_CULL_FACE);
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
//    glEnable(GL_CULL_FACE);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

@end
