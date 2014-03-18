#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <SharedInstanceGCD.h>

@interface BucketClient : NSObject
+(instancetype)sharedInstance;

-(NSString*)getURL:(NSString*)url;
-(NSString*)authenticateWithToken:(NSString*)token;
-(BOOL)authenticateWithKey:(NSString*)key;
-(NSArray*)getItems;
-(void)deleteItem:(NSDictionary*)item;
-(AFHTTPRequestOperation*)download:(NSDictionary*)item :(void(^)(double))progress :(void(^)(NSDictionary* item, NSData* data))callback;

@end
