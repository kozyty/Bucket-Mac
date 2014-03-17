#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface BucketClient : NSObject

+(BucketClient*)get;
-(NSString*)getURL:(NSString*)url;
-(NSString*)authenticateWithToken:(NSString*)token;
-(BOOL)authenticateWithKey:(NSString*)key;
-(NSArray*)getItems;
-(AFHTTPRequestOperation*)download:(NSDictionary*)item :(void(^)(double))progress :(void(^)(NSDictionary* item, NSData* data))callback;

@end
