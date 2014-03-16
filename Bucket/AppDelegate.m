#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BucketClient new];
    self.loginInProgress = @false;
    [self._statusIndicator startAnimation:self];
    
    NSString* key = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessKey"];
    if (key != nil) {
        self.loginInProgress = @true;
        [U background:^{
            BOOL success = [[BucketClient get] authenticateWithKey:key];
            [U on_main:^{
                if (success) {
                    [self signInDone];
                }
                self.loginInProgress = @false;
            }];
        }];
    }
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
    mainWindow = [MainWindow new];
    [mainWindow showWindow:self];
}

- (void)signIn:(GTMOAuth2SignIn *)signIn finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error != nil) {
        [[NSAlert alertWithMessageText:@"Signin failed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error: %@", error] beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        self.loginInProgress = @false;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[auth accessToken] forKey:@"accessToken"];
        [U background:^{
            NSString* key = [[BucketClient get] authenticateWithToken:[auth accessToken]];
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
