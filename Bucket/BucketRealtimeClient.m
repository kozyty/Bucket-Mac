#import "BucketRealtimeClient.h"
#import "AppDelegate.h"
#import <SocketIOPacket.h>


@implementation BucketRealtimeClient
SHARED_INSTANCE_GCD;

-(id)init {
    self = [super init];
    io = [[SocketIO alloc] initWithDelegate:self];
    io.useSecure = YES;
    return self;
}

-(void)connect{
    if (enabled)
        return;
    enabled = true;
    [self reconnect];
}

-(void)reconnect{
    io.cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://bucket.im"]];
    [io connectToHost:@"bucket.im" onPort:443];
}

-(void)disconnect{
    if (!enabled)
        return;
    enabled = false;
}

-(void)socketIODidConnect:(SocketIO *)socket{
    NSLog(@"Socket connected");
}

-(void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Socket disconnected: %@", error);
    if (enabled) {
        [self reconnect];
    }
}

-(void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet{
    NSLog(@"JSON: %@", packet);
}

-(void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSArray* tokens = [packet.data componentsSeparatedByString:@":"];
    NSLog(@"Message: %@ %@", packet, packet.data);
    if ([tokens[0] isEqualToString:@"add"])
        [[AppDelegate sharedInstance] reloadItems];
    if ([tokens[0] isEqualToString:@"delete"])
        [[AppDelegate sharedInstance] reloadItems];
}

@end
