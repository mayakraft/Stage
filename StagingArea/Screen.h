//
//  Screen.h
//  StagingArea
//
//  Created by Robby on 5/6/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Screen : NSObject

-(id) initWithFrame:(CGRect)frame;

-(void) draw;

@property (nonatomic) CGRect frame;

@end
