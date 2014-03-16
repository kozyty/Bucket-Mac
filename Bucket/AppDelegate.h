#import <Cocoa/Cocoa.h>
#import "U.h"
#import "BucketClient.h"
#import "MainWindow.h"
#import "GTMOAuth2WindowController.h"


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    MainWindow *mainWindow;
}

@property (assign) IBOutlet NSWindow *window;
@property NSNumber *loginInProgress;
@property (weak) IBOutlet NSProgressIndicator *_statusIndicator;

- (IBAction)signIn:(id)sender;
- (void)signIn:(GTMOAuth2SignIn *)signIn finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error;

@end
