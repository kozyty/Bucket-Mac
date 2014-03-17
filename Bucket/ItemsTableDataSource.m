//
//  ItemsTableDataSource.m
//  Bucket
//
//  Created by cadmin on 17.03.14.
//  Copyright (c) 2014 Bucket. All rights reserved.
//

#import "ItemsTableDataSource.h"

@implementation ItemsTableDataSource


- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSLog(@"%@", dropDestination);
    
    NSString* destinationPath = dropDestination.path;
    NSMutableArray* targetPaths = [NSMutableArray new];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSDictionary* item = self.arrangedObjects[idx];
        NSString* name = item[@"name"];

        NSString* targetPath = [NSString stringWithFormat:@"%@/%@", destinationPath, name];
        [targetPaths addObject:targetPath];
        
        [U background:^{
            NSData* data = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
            [data writeToFile:targetPath atomically:NO];
        }];
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


@end