#import "Primitives.h"
#import "Hotspot.h"

@interface Curtain : Primitives

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@property UIView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;
@property (nonatomic) float x;
@property (nonatomic) float y;

@property (nonatomic) BOOL hidden;

//@property (nonatomic) NSArray *hotspots;

-(id) initWithFrame:(CGRect)frame;

//-(void) setNeedsLayout;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;
-(void) draw;

@end
