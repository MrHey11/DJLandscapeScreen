

#import "LandScapeViewController.h"
#import "MovieView.h"

@interface LandScapeViewController ()
@property (nonatomic, strong) MovieView *movieView;
@end

@implementation LandScapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"横竖屏切换";
    
    //需要切换显示的视图
    self.movieView = [[MovieView alloc] init];
    self.movieView.userInteractionEnabled = YES;
    self.movieView.frame = CGRectMake(0, 0, 320, 180);
    self.movieView.center = self.view.center;
    [self.view addSubview:self.movieView];
    
    
    //手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.movieView addGestureRecognizer:tapGestureRecognizer];

    
    
    
}
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.movieView.state == MovieViewStateSmall) {
            [self enterFullscreen];
        }
        else if (self.movieView.state == MovieViewStateFullscreen) {
            [self exitFullscreen];
        }
    }
}

- (void)enterFullscreen {
    
    if (self.movieView.state != MovieViewStateSmall) {
        return;
    }
    
    self.movieView.state = MovieViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    self.movieView.movieViewParentView = self.movieView.superview;
    self.movieView.movieViewFrame = self.movieView.frame;
    
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self.movieView convertRect:self.movieView.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.movieView removeFromSuperview];
    self.movieView.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self.movieView];
    
    /*
     * 执行动画
     */
    [UIView animateWithDuration:0.5 animations:^{
        self.movieView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.movieView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.movieView.superview.bounds), CGRectGetWidth(self.movieView.superview.bounds));
        self.movieView.center = CGPointMake(CGRectGetMidX(self.movieView.superview.bounds), CGRectGetMidY(self.movieView.superview.bounds));
    } completion:^(BOOL finished) {
        self.movieView.state = MovieViewStateFullscreen;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)exitFullscreen {
    
    if (self.movieView.state != MovieViewStateFullscreen) {
        return;
    }
    
    self.movieView.state = MovieViewStateAnimating;
    
    CGRect frame = [self.movieView.movieViewParentView convertRect:self.movieView.movieViewFrame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.5 animations:^{
        self.movieView.transform = CGAffineTransformIdentity;
        self.movieView.frame = frame;
    } completion:^(BOOL finished) {
        /*
         * movieView回到小屏位置
         */
        [self.movieView removeFromSuperview];
        self.movieView.frame = self.movieView.movieViewFrame;
        [self.movieView.movieViewParentView addSubview:self.movieView];
        self.movieView.state = MovieViewStateSmall;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
