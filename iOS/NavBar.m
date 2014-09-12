#import "NavBar.h"

@implementation NavBar

-(void) setup{
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

    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, arrowWidth, arrowWidth)];
    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setBackgroundColor:[UIColor blackColor]];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_backButton setTitle:@"◀︎" forState:UIControlStateNormal];
    [[_backButton titleLabel] setFont:[UIFont boldSystemFontOfSize:30]];

    [[self view] addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+arrowWidth, 5, self.view.frame.size.width-arrowWidth*2, arrowWidth)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
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
