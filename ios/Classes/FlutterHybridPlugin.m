#import "FlutterHybridPlugin.h"
#import "FLHNativePageLifecycleMessenger.h"
#import "FLHNativeNavigationMessenger.h"
#import "NSArray+FLHUtility.h"

@interface FlutterHybridPlugin ()

@property (nonatomic, strong) FLHNativePageLifecycleMessenger *nativePageLifecycleMessenger;
@property (nonatomic, strong) NSArray<id<FLHMessenger>> *messengers;
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;

@end

@implementation FlutterHybridPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_hybrid"
                                     binaryMessenger:[registrar messenger]];
    FlutterHybridPlugin *instance = [[FlutterHybridPlugin alloc] initWithMethodChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel {
    if (self = [super init]) {
        _methodChannel = methodChannel;
        _messengers = @[
                        [FLHNativePageLifecycleMessenger sharedInstance],
                        [FLHNativeNavigationMessenger sharedInstance],
                        ];
        for (id<FLHMessenger> messenger in _messengers) {
            messenger.methodChannel = methodChannel;
        }
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *method = call.method;
    NSArray<NSString *> *methodComponents = [method componentsSeparatedByString:@"."];
    if (methodComponents.count == 2) {
        NSString *messengerName = methodComponents.firstObject;
        NSString *methodName = methodComponents.lastObject;
        id<FLHMessenger> messenger = _messengers.flh_fetch(^BOOL(id<FLHMessenger>  _Nonnull item) {
            return [item.name isEqualToString:messengerName];
        });
        if (messenger) {
            [messenger handleMethodCall:methodName arguments:call.arguments result:result];
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
