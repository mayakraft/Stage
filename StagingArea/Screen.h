#import <Foundation/Foundation.h>
#import "Primitives.h"

@interface Screen : Primitives

@property UIView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;
@property NSMutableArray *elements;   // add all user interface elements here after creating
-(void) hideElements;                 // so that this function will work

-(id) initWithFrame:(CGRect)frame;
-(void) draw;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;

@end
