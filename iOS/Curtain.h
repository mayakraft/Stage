#import "Primitives.h"
#import "Hotspot.h"

@interface CurtainView : UIView
@end

@interface Curtain : Primitives

@property CurtainView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;
@property (nonatomic) float x;
@property (nonatomic) float y;

@property (nonatomic) BOOL hidden;

-(id) initWithFrame:(CGRect)frame;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;
-(void) draw;

@end
