//
//  OBJ.h
//  StagingArea
//
//  Created by Robby on 4/13/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJ : NSObject

-(void)draw;

-(id)initWithOBJ:(NSString*)file Path:(NSString*)path;
-(id)initWithGeodesic:(int)type Frequency:(int)v;

-(NSString*)exportOBJ;

@end
