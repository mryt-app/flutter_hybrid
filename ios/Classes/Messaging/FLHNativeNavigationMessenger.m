//
//  FLHNativeNavigationMessenger.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import "FLHNativeNavigationMessenger.h"
#import "FLHFirstPageInfo.h"

@implementation FLHNativeNavigationMessenger
@synthesize methodChannel;

DEF_SINGLETON(FLHNativeNavigationMessenger)

- (NSString *)name {
    return @"NativeNavigation";
}

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel {
    if (self = [super init]) {
        self.methodChannel = methodChannel;
    }
    return self;
}

- (void)handleMethodCall:(NSString *)method arguments:(id)arguments result:(FlutterResult)result {
    if ([method isEqualToString:@"flutterCanPopChanged"]) {
        
    } else if ([method isEqualToString:@"fetchStartPageInfo"]) {
        NSDictionary *pageInfo = [FLHFirstPageInfo.sharedInstance.firstPageInfo toJSON];
        result(pageInfo);
    }
    result(FlutterMethodNotImplemented);
}

@end
