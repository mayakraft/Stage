#import "ViewController.h"
#import "Stage.h"

@interface ViewController (){
    
    EAGLContext     *context;
    GLKBaseEffect   *effect;
    Stage           *stage;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    view.context = context;
    
    // iOS for getting screen width & height
    float width, height;
    if([UIApplication sharedApplication].statusBarOrientation > 2){
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width;
    } else{
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height;
    }
    
    stage = [[Stage alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}

-(void) tapHandler:(UIGestureRecognizer*)sender{
    if([sender state] == 3)
        [stage touchesEnded];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [stage draw];
}

- (void)tearDownGL{
    [EAGLContext setCurrentContext:context];
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
    effect = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
