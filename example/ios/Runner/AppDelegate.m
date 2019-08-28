#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "TabBarController.h"
#import "Router.h"
#import <flutter_hybrid/FLHFlutterHybrid.h>

@interface AppDelegate ()

@property (nonatomic, strong) Router *router;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [TabBarController new];
    [self.window makeKeyAndVisible];
    
    [FLHFlutterHybrid.sharedInstance startFlutterWithRouter:[Router sharedInstance]];
    
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
