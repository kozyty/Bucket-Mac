//
//  ItemsTableDataSource.m
//  Bucket
//
//  Created by cadmin on 17.03.14.
//  Copyright (c) 2014 Bucket. All rights reserved.
//

#import "ItemsTableDataSource.h"
#import "MainWindow.h"

@implementation ItemsTableDataSource



- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSLog(@"%@", dropDestination);
    
    NSString* destinationPath = dropDestination.path;
    NSMutableArray* targetPaths = [NSMutableArray new];
    
    __block int textFileIndex = 1;
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSMutableDictionary* item = self.arrangedObjects[idx];
        NSString* name = item[@"name"];
        if (![item[@"type"] isEqualToNumber:@0]) {
            if (textFileIndex == 1) {
                name = @"bucket.txt";
            } else {
                name = [NSString stringWithFormat:@"bucket %i.txt", textFileIndex];
            }
            textFileIndex++;
        }

        NSString* targetPath = [NSString stringWithFormat:@"%@/%@", destinationPath, name];
        [targetPaths addObject:targetPath];
        
        [[AppDelegate sharedInstance] startDownload:item:targetPath];
    }];
    
    return targetPaths;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:@[NSFilesPromisePboardType] owner:self];
    
    NSMutableArray* extensions = [NSMutableArray new];
    
    [rowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSDictionary* item = self.arrangedObjects[idx];
        NSString* name = item[@"name"];
        [extensions addObject:[name pathExtension]];
    }];
    
    [pboard setPropertyList:extensions forType:NSFilesPromisePboardType];
    return YES;
}

-(NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return NSDragOperationCopy;
}

-(BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard* pasteboard = [info draggingPasteboard];
    if ([[pasteboard types] containsObject:NSFilenamesPboardType])
    {
        NSData* data = [pasteboard dataForType:NSFilenamesPboardType];
        if (data)
        {
            NSArray * filenames = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
            
            [[MainWindow sharedInstance] showUpload:YES];
            [U background:^{
                for (NSString* filename in filenames) {
                    NSLog(@"%@", filename);
                    [[AppDelegate sharedInstance] runUpload:[NSURL fileURLWithPath:filename]];
                }
                [U on_main:^{
                    [[MainWindow sharedInstance] showUpload:NO];
                    [[AppDelegate sharedInstance] reloadItems];
                }];
            }];
        }
    }
    
    if ([[pasteboard types] containsObject:NSStringPboardType]) {
        NSString* text = [pasteboard stringForType:NSStringPboardType];
        [[MainWindow sharedInstance] showUpload:YES];
        [U background:^{
            [[AppDelegate sharedInstance] runTextUpload:text];
            [U on_main:^{
                [[MainWindow sharedInstance] showUpload:NO];
                [[AppDelegate sharedInstance] reloadItems];
            }];
        }];
    }
    return true;
}

@end