#import "U.h"

@implementation U

+ (void) background: (block_t)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

+ (void) on_main: (block_t)block {
    dispatch_sync(dispatch_get_main_queue(), block);
}

+ (void) msgbox: (NSString*)message {
    NSAlert* msg = [NSAlert new];
    [msg setMessageText:message];
    [msg runModal];
}

+ (int)msgboxYesNo:(NSString *)message {
    NSAlert* msg = [NSAlert alertWithMessageText:message defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@""];
    return [msg runModal] == NSAlertDefaultReturn;
}

+ (void) sheet: (NSString*)message :(NSWindow*) wnd {
    NSAlert* msg = [NSAlert new];
    [msg setMessageText:message];
    [msg beginSheetModalForWindow:wnd modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

@end
