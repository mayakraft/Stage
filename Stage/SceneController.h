#import <Foundation/Foundation.h>

// designed to operate only one transition at a time

typedef enum : unsigned short {
    Scene1,
    Scene2
//  list Scenes here
//  ..
//  ..
} Scene;

@protocol SceneTransitionDelegate <NSObject>

@required
// tween increments from 0.0 to 1.0 if transition has duration
-(void) transitionFrom:(unsigned short)fromScene To:(unsigned short)toScene Tween:(float)t;

@end

@interface SceneController : NSObject

@property id <SceneTransitionDelegate> delegate;

@property (readonly) Scene scene;
@property (readonly) BOOL sceneInTransition;

-(void) gotoScene:(unsigned short)scene;
-(void) gotoScene:(unsigned short)scene withDuration:(NSTimeInterval)interval;

@end
