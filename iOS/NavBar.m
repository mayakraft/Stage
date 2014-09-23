#import "NavBar.h"
//#import "Primitives.c"
@implementation NavBar

#define MENU_WIDTH 50

#define STATUS_BAR 22

-(void) drawPentagon{
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

+(instancetype) navBarTop{
    NavBar *navBar = [[NavBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(navBar){
        float arrowWidth = navBar.frame.size.width*.175;
        
        navBar.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(navBar.frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)];
        [navBar.forwardButton addTarget:navBar action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.forwardButton setBackgroundColor:[UIColor blackColor]];
        [[navBar.forwardButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.forwardButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [navBar addSubview:navBar.forwardButton];
        
        navBar.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5 + MENU_WIDTH, 5, arrowWidth, arrowWidth)];
        [navBar.backButton addTarget:navBar action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.backButton setBackgroundColor:[UIColor blackColor]];
        [navBar.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.backButton setTitle:@"◀︎" forState:UIControlStateNormal];
        [[navBar.backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        
        [navBar addSubview:navBar.backButton];
        
        navBar.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth*1.33 /* fix */, 10 + STATUS_BAR, navBar.frame.size.width-arrowWidth*2, arrowWidth)];
        [navBar.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [navBar.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.titleLabel setTextColor:[UIColor blackColor]];
        [navBar addSubview:navBar.titleLabel];

        [navBar setNumPages:5];
        [navBar setTitles:@[@"SCENE 1", @"SCENE 2", @"SCENE 3", @"SCENE 4", @"SCENE 5"]];
    }
    return navBar;
}

+(instancetype) navBarBottom{
    NavBar *navBar = [[NavBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(navBar){
        float arrowWidth = navBar.frame.size.width*.125;
        
        navBar.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(navBar.frame.size.width-(arrowWidth+5), navBar.frame.size.height - arrowWidth*1.66-5, arrowWidth, arrowWidth*1.66)];
        [navBar.forwardButton addTarget:navBar action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.forwardButton setBackgroundColor:[UIColor blackColor]];
        [[navBar.forwardButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.forwardButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [navBar addSubview:navBar.forwardButton];
        
        navBar.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, navBar.frame.size.height - arrowWidth*1.66-5, arrowWidth, arrowWidth*1.66)];
        [navBar.backButton addTarget:navBar action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.backButton setBackgroundColor:[UIColor blackColor]];
        [navBar.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.backButton setTitle:@"◀︎" forState:UIControlStateNormal];
        [[navBar.backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        
        [navBar addSubview:navBar.backButton];
        
        navBar.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth, 10+STATUS_BAR, navBar.frame.size.width-arrowWidth*2, arrowWidth)];
        [navBar.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [navBar.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.titleLabel setTextColor:[UIColor blackColor]];
        [navBar addSubview:navBar.titleLabel];
        
        NSLog(@"NavBar made: Subviews: (%d)",navBar.subviews.count);

        [navBar setNumPages:5];
        [navBar setTitles:@[@"SCENE 1", @"SCENE 2", @"SCENE 3", @"SCENE 4", @"SCENE 5"]];
    }
    return navBar;
}

-(void) customDraw{
    static int del;
    del++;
    glColor4f(0.75f, 0.75f, 0.75f, 1.0f);
    glPushMatrix();
    glTranslatef(self.bounds.size.width*.5, self.bounds.size.height, 0.0);
    glRotatef(del, 0, 0, 1.0);
    glScalef(100, 100, 1);
    [self drawPentagon ];
    glPopMatrix();
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"NavBar : touchesBegan");
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"NavBar : touchesMoved");
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"NavBar : touchesEnded");
}

-(void) setTitles:(NSArray *)titles{
    _titles = titles;
    _numPages = [_titles count];
    [self setNeedsLayout];
}

-(void) setNeedsLayout{
    if(_page >= 0 && _page < [_titles count])
        [_titleLabel setText:[_titles objectAtIndex:_page]];
}

-(void) backButtonPressed{
    if(_page <= 0) return;
    _page--;
    [self setNeedsLayout];
    [[self delegate] pageTurnBack:_page];
}

-(void) forwardButtonPressed{
    if(_page >= _numPages-1) return;
    _page++;
    [self setNeedsLayout];
    [[self delegate] pageTurnForward:_page];
}

@end
