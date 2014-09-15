#import "NavBar.h"

@implementation NavBarView

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"navBar hitTest:(%.1f,%.1f) Subviews:%d",point.x, point.y, self.subviews.count);
    for(UIView* v in [self subviews]){
        CGPoint touchPoint = [v convertPoint:point fromView:self];
        if([v pointInside:touchPoint withEvent:event]){
            NSLog(@"%@",v.description);
            return [super hitTest:point withEvent:event];
        }
    }
    return nil;
}

@end

@implementation NavBar

#define MENU_WIDTH 50

-(void) setup{
    
    self.view = [[NavBarView alloc] initWithFrame:self.view.frame];
    NSLog(@"navBar setup");
    float arrowWidth = self.view.frame.size.width*.175;
    
    _forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)];
    [_forwardButton addTarget:self action:@selector(forwardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_forwardButton setBackgroundColor:[UIColor blackColor]];
    [[_forwardButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];
    [_forwardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_forwardButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_forwardButton setTitle:@"▶︎" forState:UIControlStateNormal];
    [[self view] addSubview:_forwardButton];

    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5 + MENU_WIDTH, 5, arrowWidth, arrowWidth)];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setBackgroundColor:[UIColor blackColor]];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_backButton setTitle:@"◀︎" forState:UIControlStateNormal];
    [[_backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];

    [[self view] addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth*1.33 /* fix */, 5, self.view.frame.size.width-arrowWidth*2, arrowWidth)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [[self view] addSubview:_titleLabel];
    
    _numPages = 5;
    [self setTitles:@[@"SCENE 1", @"SCENE 2", @"SCENE 3", @"SCENE 4", @"SCENE 5"]];
}

+(instancetype) navBar{
    float w = [[UIScreen mainScreen] bounds].size.width;
    NavBar *navBar = [[NavBar alloc] initWithFrame:CGRectMake(0, 0, w, [[UIScreen mainScreen] bounds].size.width*.175+10)];
    if(navBar){
        
    }
    return navBar;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"NavBar: touchesBegan");
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"NavBar: touchesMoved");
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"NavBar: touchesEnded");
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
