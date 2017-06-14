
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MovieViewState) {
    MovieViewStateSmall,
    MovieViewStateAnimating,
    MovieViewStateFullscreen,
};

@interface MovieView : UIImageView

/**
 记录小屏时的parentView
 */
@property (nonatomic, weak) UIView *movieViewParentView;

/**
 记录小屏时的frame
 */
@property (nonatomic, assign) CGRect movieViewFrame;

@property (nonatomic, assign) MovieViewState state;

@end
