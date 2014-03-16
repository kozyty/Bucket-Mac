#import <Foundation/Foundation.h>

typedef void(^block_t)();

@interface U : NSObject
+ (void) background: (block_t)block;
+ (void) on_main: (block_t)block;
+ (void) msgbox: (NSString*)message;
+ (int) msgboxYesNo: (NSString*)message;
+ (void) sheet: (NSString*)message :(NSWindow*) wnd;

@end
