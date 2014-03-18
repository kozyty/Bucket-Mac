#import "ItemsTableView.h"

@implementation ItemsTableView

- (void)awakeFromNib {
    [self setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

@end
