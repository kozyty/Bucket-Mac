#import "MainWindow.h"

@interface MainWindow ()

@end

@implementation MainWindow

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setLevel:NSStatusWindowLevel];
    
    self.loadingInProgress = @true;
    [U background:^{
        NSArray* items = [[BucketClient get] getItems];
        [U on_main:^{
            [self._arrayController setContent:items];
            self.loadingInProgress = @false;
        }];
    }];
}

@end
