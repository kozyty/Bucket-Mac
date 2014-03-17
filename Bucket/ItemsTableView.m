//
//  ItemsTableView.m
//  Bucket
//
//  Created by cadmin on 17.03.14.
//  Copyright (c) 2014 Bucket. All rights reserved.
//

#import "ItemsTableView.h"

@implementation ItemsTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [self setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
