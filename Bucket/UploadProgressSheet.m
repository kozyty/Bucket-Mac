#import "UploadProgressSheet.h"

@interface UploadProgressSheet ()

@end

@implementation UploadProgressSheet

- (id)init
{
    self = [super initWithWindowNibName:@"UploadProgressSheet"];
    if (self) {
        self._appDelegate = [AppDelegate sharedInstance];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self._progressIndicator startAnimation:self];
}

@end
