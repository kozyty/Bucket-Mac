#import "BucketClient.h"
#import <ASIHTTPRequest.h>

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
    return [NSString stringWithFormat:@"https://bucket.im/api/%@", url];
}

-(NSString*)authenticateWithToken:(NSString *)token {
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@", [self getURL:@"auth"], token]]];
    [request startSynchronous];
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
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?key=%@&push-id=&device-id=osx:", [self getURL:@"auth"], key]]];
    [request startSynchronous];
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
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[self getURL:@"items"]]];
    [request startSynchronous];
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

@end
