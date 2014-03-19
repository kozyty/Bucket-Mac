#import "MainWindow.h"


@implementation MainWindow
SHARED_INSTANCE_GCD;

- (id)init
{
    self = [super initWithWindowNibName:@"MainWindow"];
    if (self) {
        self.appDelegate = [AppDelegate sharedInstance];
        uploadSheet = [UploadProgressSheet new];
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

-(void)openItem:(id)sender {
    NSDictionary* item = [AppDelegate sharedInstance].items[[self._tableView clickedRow]];
    if ([item[@"type"] isEqualToNumber:@1]) {
        NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
        [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
        [pasteBoard setString:item[@"text"] forType:NSStringPboardType];
        
        [U displayNotification:@"Copied to clipboard" :item[@"name"]];
    }
    if ([item[@"type"] isEqualToNumber:@2]) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:item[@"text"]]];
    }
}

- (IBAction)deleteItem:(id)sender {
    NSDictionary* item = [AppDelegate sharedInstance].items[(long)[self._tableView rowForView:sender]];
    [U background:^{
        [[BucketClient sharedInstance] deleteItem:item];
        [[AppDelegate sharedInstance] reloadItems];
    }];
}

- (void)showUpload:(BOOL)visible {
    if (visible) {
        [NSApp beginSheet:uploadSheet.window modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    } else {
        [NSApp endSheet:uploadSheet.window];
        [uploadSheet.window orderOut:self];
    }
}

@end
