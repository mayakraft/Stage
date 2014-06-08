#import <Foundation/Foundation.h>
#import "FlatPrimitives.h"

@interface Screen : FlatPrimitives

@property UIView *view;   // attach Apple or other user interface elements
@property (nonatomic) CGRect frame;
@property NSMutableArray *elements;   // add all user interface elements here after creating
-(void) hideElements;                 // so that this function will work

-(id) initWithFrame:(CGRect)frame;

//TODO: how do you say "REQUIRED"
-(void) customDraw;
-(void) setup;
-(void) draw;

@end
