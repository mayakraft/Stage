//
//  NavBar.m
//  Stage
//
//  Created by Robby on 6/28/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "NavBar.h"

typedef enum{
    hotspotBackArrow,
    hotspotForwardArrow,
    hotspotControls
} HotspotID;


@implementation NavBar

-(void) setup{
    float arrowWidth = self.view.frame.size.width*.175;
    NSArray *hotspots = @[ [Hotspot hotspotWithID:hotspotBackArrow Bounds:CGRectMake(5, 5, arrowWidth, arrowWidth)],
                  [Hotspot hotspotWithID:hotspotForwardArrow Bounds:CGRectMake(self.view.frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)],
                  [Hotspot hotspotWithID:hotspotControls Bounds:CGRectMake(0, self.view.frame.size.height-arrowWidth*2.5, self.view.frame.size.width, arrowWidth*2.5)]];
    NSLog(@"count: %lu",(unsigned long)hotspots.count);
}
@end
