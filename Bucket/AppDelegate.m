#import "AppDelegate.h"
#import "MainWindow.h"

@implementation AppDelegate
static AppDelegate* _instance;

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return _instance;
});

-(void)reloadItems {
    self.reloadingItems = @true;
    [U background:^{
        NSArray* items = [[BucketClient sharedInstance] getItems];
        [U on_main:^{
            self.items = items;
            self.reloadingItems = @false;
            [[TrayIcon sharedInstance] setFull:([items count] > 0)];
        }];
    }];
}

-(void)startDownload:(NSMutableDictionary *)item :(NSString *)targetPath {
    [U background:^{
        item[@"downloadRequest"] = [[BucketClient sharedInstance] download:item :^(double progress) {
            item[@"progress"] = [NSNumber numberWithDouble:progress];
        }: ^(NSDictionary *_, NSData *data) {
            [item setValue:nil forKey:@"progress"];
            NSLog(@"Downloaded %@, %lu long, writing to %@", item[@"name"], (unsigned long)[data length], targetPath);
            [data writeToFile:targetPath atomically:NO];
            
            [item removeObjectForKey:@"progress"];
            
            NSUserNotification* notification = [NSUserNotification new];
            [notification setTitle:@"Download complete"];
            [notification setSubtitle:item[@"name"]];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }];
    }];
}

-(void)runUpload:(NSURL *)path {
    self.currentUploadName = [path lastPathComponent];
    [[[BucketClient sharedInstance] upload:path :^(double p) {
        self.currentUploadProgress = [NSNumber numberWithDouble:p];
    } :^{
        self.currentUploadProgress = nil;
        self.currentUploadName = nil;
    }] waitUntilFinished];
}

//------------

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _instance = self;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    self.loginInProgress = @false;
    [self._statusIndicator startAnimation:self];
    
    NSString* key = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessKey"];
    if (key != nil) {
        self.loginInProgress = @true;
        [U background:^{
            BOOL success = [[BucketClient sharedInstance] authenticateWithKey:key];
            [U on_main:^{
                if (success) {
                    [self signInDone];
                }
                self.loginInProgress = @false;
            }];
        }];
    }
    
    [[TrayIcon sharedInstance] show:NO];
    [[TrayIcon sharedInstance] setFull:NO];
}

NSString* kClientID = @"828226820573-2chvvi4qsvah229699ubhkh7g65dnv2a.apps.googleusercontent.com";
NSString* kClientSecret = @"-cx7Bpbj5EhN4_odlZpexJnP";


- (void)signIn:(id)sender {
    self.loginInProgress = @true;
    GTMOAuth2WindowController *windowController;
    windowController = [[GTMOAuth2WindowController alloc] initWithScope:@"openid profile email" clientID:kClientID                                                            clientSecret:kClientSecret keychainItemName:@"Bucket" resourceBundle:nil];
    
    [windowController signInSheetModalForWindow:self.window
                                 delegate:self
                               finishedSelector:@selector(signIn:finishedWithAuth:error:)];
}

- (void)signInDone {
    [self.window orderOut:self];
    
    [[BucketRealtimeClient sharedInstance] connect];
    
    [[TrayIcon sharedInstance] show:YES];
    [[MainWindow sharedInstance] showWindow:self];
    [self reloadItems];
}

- (void)signIn:(GTMOAuth2SignIn *)signIn finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error != nil) {
        [[NSAlert alertWithMessageText:@"Signin failed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error: %@", error] beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        self.loginInProgress = @false;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[auth accessToken] forKey:@"accessToken"];
        [U background:^{
            NSString* key = [[BucketClient sharedInstance] authenticateWithToken:[auth accessToken]];
            [U on_main:^{
                if (key != nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"accessKey"];
                    [self signInDone];
                } else {
                    [NSAlert alertWithMessageText:@"Could not authenticate on Bucket" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                }
                self.loginInProgress = @false;
            }];
        }];
    }
}

@end
