#import "NavigationScreen.h"
#import <OpenGLES/ES1/gl.h>

@interface NavigationScreen (){
//    static float arrowWidth = ;   // fix this, put make it static
}
@end

@implementation NavigationScreen

#define arrowWidth self.frame.size.width*.125

-(void) setup{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*.18)];
    [_titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setText:@"SCENE 1"];
    [self.view addSubview:_titleLabel];
    
    _icosahedronLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-arrowWidth, (self.frame.size.width)*.5, (self.frame.size.width)/12.)];
    [_icosahedronLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [_icosahedronLabel setTextAlignment:NSTextAlignmentCenter];
    [_icosahedronLabel setTextColor:[UIColor blackColor]];
    [_icosahedronLabel setText:@"icosa"];
    [self.view addSubview:_icosahedronLabel];
    _octahedronLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width)*.5, self.frame.size.height-arrowWidth, (self.frame.size.width)*.5, (self.frame.size.width)/12.)];
    [_octahedronLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
    [_octahedronLabel setTextAlignment:NSTextAlignmentCenter];
    [_octahedronLabel setTextColor:[UIColor blackColor]];
    [_octahedronLabel setText:@"octa"];
    [self.view addSubview:_octahedronLabel];
    
    self.elements = [NSMutableArray array];
    [self.elements addObjectsFromArray:@[_icosahedronLabel, _octahedronLabel]];
    
    _numberLabels = [[NSMutableArray alloc] init];
    for(int i = 0; i < 9; i++){
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width)/12.*(i+1.5), self.frame.size.height-arrowWidth, (self.frame.size.width)/12., (self.frame.size.width)/12.)];
        [numberLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.width*.1]];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [numberLabel setHidden:YES];
        [numberLabel setText:[NSString stringWithFormat:@"%d",i+1]];
        [numberLabel setTextColor:[UIColor blackColor]];
        [_numberLabels addObject:numberLabel];
        [self.view addSubview:numberLabel];
        [self.elements addObject:numberLabel];
    }
}

-(void) hideElements{
    for(int i = 0; i < [self.elements count]; i++)
        [self.elements[i] setHidden:YES];
}

-(void) customDraw{
    glDisable(GL_LIGHTING);

    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    // navigation bar side arrow boxes
    [self drawRect:CGRectMake(arrowWidth*.5+5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth, arrowWidth)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth, arrowWidth)];
    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    // navigation bar plus and minus signs
    [self drawRect:CGRectMake(arrowWidth*.5+5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth*.5, 5)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, 5, arrowWidth*.5)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth*.5, 5)];

    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    if(*_scene < 3)
        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth, self.frame.size.width, arrowWidth*2)];

    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    if(*_scene == 1){
        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth*1.25, self.frame.size.width*4/6., 4)];
        for(int i = 0; i < 9; i++)
            [self drawRect:CGRectMake((self.frame.size.width)/12.*(i+2), arrowWidth*1.25, 1, arrowWidth*.33)];
        [self drawRect:CGRectMake((self.frame.size.width)/12.*(_radioBarPosition+2), arrowWidth*1.25, 20, 20) WithRotation:45];
    }
}


@end
