#import "NavBar.h"
<<<<<<< HEAD
//#import "Primitives.c"
=======

>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
@implementation NavBar

#define MENU_WIDTH 50

<<<<<<< HEAD
#define STATUS_BAR 22

=======
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
-(void) setup{
    NSLog(@"NavBar.m : setup");
}

<<<<<<< HEAD
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
    glDrawArrays(GL_TRIANGLE_FAN, 0, 8);
    glDisableClientState(GL_VERTEX_ARRAY);
}

=======
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
+(instancetype) navBarTop{
    NavBar *navBar = [[NavBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(navBar){
        float arrowWidth = navBar.view.frame.size.width*.175;
        
        navBar.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(navBar.view.frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)];
        [navBar.forwardButton addTarget:navBar action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.forwardButton setBackgroundColor:[UIColor blackColor]];
        [[navBar.forwardButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.forwardButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [[navBar view] addSubview:navBar.forwardButton];
        
        navBar.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5 + MENU_WIDTH, 5, arrowWidth, arrowWidth)];
        [navBar.backButton addTarget:navBar action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.backButton setBackgroundColor:[UIColor blackColor]];
        [navBar.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.backButton setTitle:@"◀︎" forState:UIControlStateNormal];
        [[navBar.backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        
        [[navBar view] addSubview:navBar.backButton];
        
<<<<<<< HEAD
        navBar.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth*1.33 /* fix */, 10 + STATUS_BAR, navBar.view.frame.size.width-arrowWidth*2, arrowWidth)];
=======
        navBar.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth*1.33 /* fix */, 5, navBar.view.frame.size.width-arrowWidth*2, arrowWidth)];
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
        [navBar.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [navBar.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.titleLabel setTextColor:[UIColor blackColor]];
        [[navBar view] addSubview:navBar.titleLabel];

        [navBar setNumPages:5];
        [navBar setTitles:@[@"SCENE 1", @"SCENE 2", @"SCENE 3", @"SCENE 4", @"SCENE 5"]];
    }
    return navBar;
}

+(instancetype) navBarBottom{
    NavBar *navBar = [[NavBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(navBar){
        float arrowWidth = navBar.view.frame.size.width*.125;
        
<<<<<<< HEAD
        navBar.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(navBar.view.frame.size.width-(arrowWidth+5), navBar.view.frame.size.height - arrowWidth*1.66-5, arrowWidth, arrowWidth*1.66)];
=======
        navBar.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(navBar.view.frame.size.width-(arrowWidth*.75+5), navBar.view.frame.size.height - arrowWidth*1.66-5, arrowWidth*.75, arrowWidth*1.66)];
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
        [navBar.forwardButton addTarget:navBar action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.forwardButton setBackgroundColor:[UIColor blackColor]];
        [[navBar.forwardButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.forwardButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [[navBar view] addSubview:navBar.forwardButton];
        
<<<<<<< HEAD
        navBar.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, navBar.view.frame.size.height - arrowWidth*1.66-5, arrowWidth, arrowWidth*1.66)];
=======
        navBar.backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, navBar.view.frame.size.height - arrowWidth*1.66-5, arrowWidth*.75, arrowWidth*1.66)];
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
        [navBar.backButton addTarget:navBar action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [navBar.backButton setBackgroundColor:[UIColor blackColor]];
        [navBar.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navBar.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [navBar.backButton setTitle:@"◀︎" forState:UIControlStateNormal];
        [[navBar.backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
        
        [[navBar view] addSubview:navBar.backButton];
        
<<<<<<< HEAD
        navBar.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth, 10+STATUS_BAR, navBar.view.frame.size.width-arrowWidth*2, arrowWidth)];
=======
        navBar.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth, 5, navBar.view.frame.size.width-arrowWidth*2, arrowWidth)];
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
        [navBar.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [navBar.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [navBar.titleLabel setTextColor:[UIColor blackColor]];
        [[navBar view] addSubview:navBar.titleLabel];

        [navBar setNumPages:5];
        [navBar setTitles:@[@"SCENE 1", @"SCENE 2", @"SCENE 3", @"SCENE 4", @"SCENE 5"]];
    }
    return navBar;
}

<<<<<<< HEAD
-(void) customDraw{
    static int del;
    del++;
    glColor4f(0.75f, 0.75f, 0.75f, 1.0f);
    glPushMatrix();
    glTranslatef(self.view.bounds.size.width*.5, self.view.bounds.size.height, 0.0);
    glRotatef(del, 0, 0, 1.0);
    glScalef(100, 100, 1);
    [self drawPentagon ];
    glPopMatrix();
}
=======
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580

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
    [[self delegate] pageTurnBack:_page];
    [self setNeedsLayout];
}

-(void) forwardButtonPressed{
    if(_page >= _numPages-1) return;
    _page++;
    [self setNeedsLayout];
    [[self delegate] pageTurnForward:_page];
}

@end
