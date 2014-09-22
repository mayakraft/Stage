//
//  GLScrollView.h
//  Stage
//
//  Created by Robby on 9/17/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "ScreenView.h"
#import <GLKit/GLKit.h>

@interface GLScrollView : ScreenView

@property (nonatomic, readonly) CGRect scrollableFrame;
@property (nonatomic, readonly) CGSize scrollableContentSize;

@property (nonatomic) CGPoint scrollOffset;

- (CGPoint)scrollOffsetForProposedOffset:(CGPoint)offset;

@end
