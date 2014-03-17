#import "BucketClient.h"

@implementation BucketClient

static BucketClient* instance;

-(id)init {
    self = [super init];
    instance = self;
    return self;
}

+(BucketClient*)get {
    return instance;
}

-(NSString *)getURL:(NSString *)url {
    return [NSString stringWithFormat:@"https://bucket.im/%@", url];
}

-(NSString*)authenticateWithToken:(NSString *)token {
    AFHTTPRequestOperation* request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@", [self getURL:@"api/auth"], token]]]];
    [request start];
    [request waitUntilFinished];
    NSError *error = [request error];
    if (!error) {
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[data objectForKey:@"status"] isEqualToString:@"ok"]) {
            return [data objectForKey:@"key"];
        }
    }
    NSLog(@"%@", error);
    return nil;
}


-(BOOL)authenticateWithKey:(NSString *)key {
    NSURLRequest* urlreq = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?key=%@&push-id=&device-id=osx:", [self getURL:@"api/auth"], key]]];
    AFHTTPRequestOperation* request = [[AFHTTPRequestOperation alloc] initWithRequest:urlreq];
    [request start];
    [request waitUntilFinished];
    NSError *error = [request error];
    if (!error) {
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([[data objectForKey:@"status"] isEqualToString:@"ok"]) {
            return true;
        }
    }
    NSLog(@"%@", error);
    return false;
}

- (NSArray *)getItems {
    AFHTTPRequestOperation* request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getURL:@"api/items"]]]];
    [request start];
    [request waitUntilFinished];
    NSError *error = [request error];
    if (!error) {
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
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

- (AFHTTPRequestOperation*)download:(NSDictionary*)item :(void(^)(double))progress :(void(^)(NSDictionary* item, NSData* data))callback {
    AFHTTPRequestOperation* request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getURL:[NSString stringWithFormat:@"download/%@", item[@"id"]]]]]];
    __weak AFHTTPRequestOperation* _request = request;
    [request setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        NSLog(@"%lu / %lu", (ULONG)totalBytesRead, (ULONG)totalBytesExpectedToRead);
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

@end
