#import "BucketClient.h"



@implementation BucketClient
SHARED_INSTANCE_GCD;

-(NSString *)getURL:(NSString *)url {
    return [NSString stringWithFormat:@"https://bucket.im/%@", url];
}

-(AFHTTPRequestOperation*)obtainRequest:(NSString*)url {
    return [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(NSDictionary*)parseJSON:(NSData*)data {
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

-(NSData*)makeJSON:(NSDictionary*)data {
    return [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
}

-(NSString*)authenticateWithToken:(NSString *)token {
    AFHTTPRequestOperation* request = [self obtainRequest:[NSString stringWithFormat:@"%@?token=%@", [self getURL:@"api/auth"], token]];
    [request start];
    [request waitUntilFinished];
    NSError *error = [request error];
    if (!error) {
        NSDictionary* data = [self parseJSON:[request responseData]];
        if ([[data objectForKey:@"status"] isEqualToString:@"ok"]) {
            return [data objectForKey:@"key"];
        }
    }
    NSLog(@"%@", error);
    return nil;
}


-(BOOL)authenticateWithKey:(NSString *)key {
    NSString* url = [NSString stringWithFormat:@"%@?key=%@&push-id=&device-id=osx:", [self getURL:@"api/auth"], key];
    AFHTTPRequestOperation* request = [self obtainRequest:url];
    [request start];
    [request waitUntilFinished];
    NSError *error = [request error];
    if (!error) {
        NSDictionary* data = [self parseJSON:[request responseData]];
        if ([[data objectForKey:@"status"] isEqualToString:@"ok"]) {
            return true;
        }
    }
    NSLog(@"%@", error);
    return false;
}

- (NSArray *)getItems {
    AFHTTPRequestOperation* request = [self obtainRequest:[self getURL:@"api/items"]];
    [request start];
    [request waitUntilFinished];
    NSError *error = [request error];
    if (!error) {
        NSDictionary* data = [self parseJSON:[request responseData]];
        if ([[data objectForKey:@"status"] isEqualToString:@"ok"]) {
            NSMutableArray* items = [NSMutableArray new];
            for (NSDictionary* json in [data objectForKey:@"items"]) {
                NSMutableDictionary* item = [NSMutableDictionary dictionaryWithDictionary:json];
                [items addObject:item];
            }
            return items;
        }
    }
    NSLog(@"%@", error);
    return nil;
}

-(void)deleteItem:(NSDictionary *)item {
    AFHTTPRequestOperation* request = [self obtainRequest:[NSString stringWithFormat:@"%@/%@", [self getURL:@"api/delete"], item[@"id"]]];
    [request start];
    [request waitUntilFinished];
}

- (AFHTTPRequestOperation*)download:(NSDictionary*)item :(void(^)(double))progress :(void(^)(NSDictionary* item, NSData* data))callback {
    AFHTTPRequestOperation* request = [self obtainRequest:[self getURL:[NSString stringWithFormat:@"download/%@", item[@"id"]]]];
    
    __weak AFHTTPRequestOperation* _request = request;
    
    [request setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        NSLog(@"%u / %u", (unsigned int)totalBytesRead, (unsigned int)totalBytesExpectedToRead);
        progress(1.0 * totalBytesRead / totalBytesExpectedToRead);
    }];
    
    [request setCompletionBlock:^{
        if ([_request error] == nil)
            callback(item, [_request responseData]);
        else {
            NSError *error = [_request error];
            NSLog(@"%@", error);
            callback(item, nil);
        }
    }];
    [request start];
    return request;
}


- (AFHTTPRequestOperation*)upload:(NSURL*)filePath :(void(^)(double))progress :(void(^)())callback {
    NSDictionary* params = @{@"type": @0, @"name": [filePath lastPathComponent]};
    AFHTTPRequestOperation* request = [[AFHTTPRequestOperationManager new] POST:[self getURL:@"api/upload"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"file" error:nil];
    } success:nil failure:nil];
    
    __weak AFHTTPRequestOperation* _request = request;
    
    [request setUploadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        NSLog(@"%u / %u", (unsigned int)totalBytesRead, (unsigned int)totalBytesExpectedToRead);
        progress(1.0 * totalBytesRead / totalBytesExpectedToRead);
    }];
    
    [request setCompletionBlock:^{
        if ([_request error] == nil)
            callback();
        else {
            NSError *error = [_request error];
            NSLog(@"%@", error);
            callback();
        }
    }];
    [request start];
    return request;
}

@end
