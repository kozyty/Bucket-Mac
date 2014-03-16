#import <Cocoa/Cocoa.h>
#import "BucketClient.h"
#import "U.h"


@interface MainWindow : NSWindowController

@property NSNumber* loadingInProgress;
@property (strong) IBOutlet NSArrayController *_arrayController;

- (id)init;

@end
