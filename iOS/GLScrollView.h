//
//  GLScrollView.h
//  Stage
//
//  Created by Robby on 9/17/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "GLView.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES1/gl.h>

@interface GLScrollView : GLView

@property (nonatomic) CGPoint unMovableOrigin;
@property (nonatomic, readonly) CGRect scrollableFrame;
@property (nonatomic, readonly) CGSize scrollableContentSize;

@property (nonatomic) CGPoint scrollOffset;

- (CGPoint)scrollOffsetForProposedOffset:(CGPoint)offset;

@end
