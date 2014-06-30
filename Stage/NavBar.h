#import "Flat.h"

@interface NavBar : Flat

//@property id <FlatDelegate> delegate;

@property UILabel *titleLabel;
@property UIButton *forwardButton;
@property UIButton *backButton;

@property (nonatomic) NSArray *titles;
@property (nonatomic) NSInteger numPages;

@end
