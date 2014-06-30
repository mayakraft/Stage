#import "NavBar.h"

typedef enum{
    hotspotBackArrow,
    hotspotForwardArrow,
    hotspotControls
} HotspotID;


@implementation NavBar

-(void) setup{
    
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

-(void) setTitles:(NSArray *)titles{
    _titles = titles;
    _numPages = [_titles count];
    [self setNeedsLayout];
}

-(void) setNeedsLayout{
    if(self.page >= 0 && self.page < [_titles count])
        [_titleLabel setText:[_titles objectAtIndex:self.page]];
}

-(void) backButtonPressed{
    if(self.page <= 0) return;
    self.page--;
    [[self delegate] pageTurnBack:self.page];
    [self setNeedsLayout];
}

-(void) forwardButtonPressed{
    if(self.page >= _numPages-1) return;
    self.page++;
    [self setNeedsLayout];
    [[self delegate] pageTurnForward:self.page];
}


//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    for(UITouch *touch in touches){
//        for(Hotspot *spot in self.hotspots){
//            if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                // customize response to each touch area
//                if([spot ID] == hotspotControls) { }
//                break;
//            }
//        }
//    }
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    for(UITouch *touch in touches){
//        for(Hotspot *spot in self.hotspots){
//            if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                // customize response to each touch area
//                if([spot ID] == hotspotControls && _scene == scene2){
//                    float freq = ([touch locationInView:self.view].x-(self.view.frame.size.width)/12.*1.5) / ((self.view.frame.size.width)/12.);
//                    if(freq < 0) freq = 0;
//                    if(freq > 8) freq = 8;
//                    //TODO: THIS NEEDS TO GET THE UPDATE
//                    //                        [navScreen setRadioBarPosition:freq];
//                }
//                break;
//            }
//        }
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    for(UITouch *touch in touches){
//        for(Hotspot *spot in self.hotspots){
//            if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                // customize response to each touch area
//                else if([spot ID] == hotspotControls){
//                    if(_scene == scene1){
//                        if([touch locationInView:self.view].x < self.view.frame.size.width*.5){
//                            
//                        }
//                        else if([touch locationInView:self.view].x > self.view.frame.size.width*.5){
//                            
//                        }
//                    }
//                    if(_scene == scene2){
//                        int freq = ([touch locationInView:self.view].x-(self.view.frame.size.width)/12.*1.5) / ((self.view.frame.size.width)/12.);
//                        if(freq < 0) freq = 0;
//                        if(freq > 8) freq = 8;
//                        //TODO: THIS NEEDS TO GET THE UPDATE
//                        //                            [navScreen setRadioBarPosition:freq];
//                        animationNewGeodesic = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.5];
//                    }
//                }
//                break;
//            }
//        }
//    }    
//}



@end
