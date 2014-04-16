//
//  Lights.h
//  StagingArea
//
//  Created by Robby on 4/16/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#ifndef __StagingArea__Lights__
#define __StagingArea__Lights__

#include <iostream>
#include <OpenGLES/ES1/gl.h>

class Light{
public:
    void rainbow(float *clearColor);
    void spotlightNoir(float *clearColor);
    void silhouette(float *clearColor);
};

#endif /* defined(__StagingArea__Lights__) */
