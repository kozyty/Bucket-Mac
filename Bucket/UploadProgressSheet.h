//
//  UploadProgressSheet.h
//  Bucket
//
//  Created by cadmin on 18.03.14.
//  Copyright (c) 2014 Bucket. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface UploadProgressSheet : NSWindowController
@property (weak) IBOutlet NSProgressIndicator *_progressIndicator;
@property AppDelegate* _appDelegate;
@end
