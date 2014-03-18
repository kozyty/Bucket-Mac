#import "MainWindow.h"


@implementation MainWindow
SHARED_INSTANCE_GCD;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        self.appDelegate = [AppDelegate sharedInstance];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setLevel:NSStatusWindowLevel];
    [self._statusIndicator startAnimation:self];
    [self._tableView setDelegate:self];
}

- (void)toggle{
    if ([self.window isVisible])
        [self.window orderOut:self];
    else
        [self.window makeKeyAndOrderFront:self];
}

- (IBAction)deleteItem:(id)sender {
    NSDictionary* item = [AppDelegate sharedInstance].items[(long)[self._tableView rowForView:sender]];
    [U background:^{
        [[BucketClient sharedInstance] deleteItem:item];
        [[AppDelegate sharedInstance] reloadItems];
    }];
}

@end
