#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>

@interface UIScreenView : UIView
@end

@interface ScreenView : NSObject

@property UIScreenView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic) float x;
@property (nonatomic) float y;

@property (nonatomic) BOOL hidden;

-(id) initWithFrame:(CGRect)frame;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;
-(void) draw;

@end
