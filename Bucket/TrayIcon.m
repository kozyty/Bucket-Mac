#import "TrayIcon.h"
#import "MainWindow.h"

@implementation TrayIcon
SHARED_INSTANCE_GCD;

-(void)show:(BOOL)visible {
    if (_icon == nil) {
        _icon = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
        [_icon setAction:@selector(activate:)];
        [_icon setTarget:self];
        [_icon setHighlightMode:YES];
        
    }
    [_icon setLength:(visible ? NSSquareStatusItemLength : 0)];
}

-(void)setFull:(BOOL)full {
    [_icon setImage:[NSImage imageNamed:(full ? @"tray-full.png" : @"tray-empty.png")]];
}

-(void)activate:(id)sender {
    [[MainWindow sharedInstance] toggle];
}

@end
