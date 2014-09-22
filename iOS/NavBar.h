<<<<<<< HEAD
#import "ScreenView.h"
=======
#import "Curtain.h"
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580


@protocol NavBarDelegate <NSObject>
@required
-(void) pageTurnBack:(NSInteger)page;
-(void) pageTurnForward:(NSInteger)page;
@end


<<<<<<< HEAD
@interface NavBar : ScreenView
=======
@interface NavBar : Curtain
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580

@property id <NavBarDelegate> delegate;

@property UILabel *titleLabel;
@property UIButton *forwardButton;
@property UIButton *backButton;

@property (nonatomic) NSArray *titles;
@property NSInteger page;
@property (nonatomic) NSInteger numPages;

-(void) forwardButtonPressed;
-(void) backButtonPressed;

+(instancetype) navBarTop;
+(instancetype) navBarBottom;

@end
