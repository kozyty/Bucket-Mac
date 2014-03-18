#import <Cocoa/Cocoa.h>
#import <SharedInstanceGCD.h>
#import "BucketClient.h"
#import "TrayIcon.h"
#import "BucketRealtimeClient.h"
#import "GTMOAuth2WindowController.h"
#import "U.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate> {
}

+(instancetype)sharedInstance;

@property NSArray* items;
@property NSNumber* reloadingItems;
-(void)reloadItems;
-(void)startDownload:(NSMutableDictionary*)item :(NSString*)targetPath;
-(void)runUpload:(NSURL*)path;

@property NSNumber* currentUploadProgress;
@property NSString* currentUploadName;

@property (assign) IBOutlet NSWindow *window;
@property NSNumber *loginInProgress;
@property (weak) IBOutlet NSProgressIndicator *_statusIndicator;

- (IBAction)signIn:(id)sender;
- (void)signIn:(GTMOAuth2SignIn *)signIn finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error;

@end
