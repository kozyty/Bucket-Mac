#import <Foundation/Foundation.h>
#import <SocketIO.h>
#import <SharedInstanceGCD.h>

@interface BucketRealtimeClient : NSObject<SocketIODelegate> {
    SocketIO* io;
    BOOL enabled;
}

+(instancetype)sharedInstance;

-(id)init;
-(void)connect;
-(void)reconnect;
-(void)disconnect;

@end
