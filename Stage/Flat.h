#import "Primitives.h"
#import "Hotspot.h"

@interface Flat : Primitives

@property UIView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;
@property NSMutableArray *elements;   // add all user interface elements here after creating

-(void) hideElements;                 // so that this function will work

-(id) initWithFrame:(CGRect)frame;

@property int scene;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;
-(void) draw;

@end
