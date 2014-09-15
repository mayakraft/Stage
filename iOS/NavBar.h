#import "Curtain.h"

@interface NavBarView : UIView
@end

@protocol NavBarDelegate <NSObject>
@required
-(void) pageTurnBack:(NSInteger)page;
-(void) pageTurnForward:(NSInteger)page;
@end


@interface NavBar : Curtain

@property id <NavBarDelegate> delegate;

@property NavBarView *view;

@property UILabel *titleLabel;
@property UIButton *forwardButton;
@property UIButton *backButton;

@property (nonatomic) NSArray *titles;
@property NSInteger page;
@property (nonatomic) NSInteger numPages;

+(instancetype) navBar;

@end
