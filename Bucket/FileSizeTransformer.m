//
//  FileSizeTransformer.m
//  Elements
//
//  Created by cadmin on 15.03.14.
//  Copyright (c) 2014 Syslink GmbH. All rights reserved.
//

#import "FileSizeTransformer.h"

@implementation FileSizeTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 99) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.1f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

@end
