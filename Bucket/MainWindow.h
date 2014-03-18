#import <Cocoa/Cocoa.h>
#import <SharedInstanceGCD.h>
#import "ItemsTableDataSource.h"
#import "ItemsTableView.h"
#import "BucketClient.h"
#import "AppDelegate.h"
#import "UploadProgressSheet.h"
#import "U.h"


@interface MainWindow : NSWindowController<NSTableViewDelegate> {
    UploadProgressSheet* uploadSheet;
}

@property (weak) IBOutlet NSProgressIndicator *_statusIndicator;
@property (weak) IBOutlet ItemsTableView *_tableView;

+(instancetype)sharedInstance;
@property AppDelegate* appDelegate;
- (id)init;
- (void)toggle;
- (IBAction)deleteItem:(id)sender;
- (void)showUpload:(BOOL)visible;
@end
