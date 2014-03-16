#import <Foundation/Foundation.h>

@interface BucketClient : NSObject

+(BucketClient*)get;
-(NSString*)getURL:(NSString*)url;
-(NSString*)authenticateWithToken:(NSString*)token;
-(BOOL)authenticateWithKey:(NSString*)key;
-(NSArray*)getItems;

@end
