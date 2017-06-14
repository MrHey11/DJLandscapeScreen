//


#import "MovieView.h"

@implementation MovieView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:@"lanscape.jpg"];
    }
    return self;
}

@end
