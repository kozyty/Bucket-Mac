#import <Foundation/Foundation.h>
#import <SharedInstanceGCD.h>


@interface TrayIcon : NSObject {
    NSStatusItem* _icon;
}

+(instancetype)sharedInstance;

-(void)show:(BOOL)visible;
-(void)setFull:(BOOL)full;
-(IBAction)activate:(id)sender;
@end
