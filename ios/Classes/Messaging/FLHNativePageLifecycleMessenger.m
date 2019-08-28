//
//  FLHNativePageLifecycleMessenger.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import "FLHNativePageLifecycleMessenger.h"

@implementation FLHNativePageLifecycleMessenger
@synthesize methodChannel;

DEF_SINGLETON(FLHNativePageLifecycleMessenger)

- (NSString *)name {
    return @"NativePageLifecycle";
}

- (void)handleMethodCall:(NSString *)method arguments:(id)arguments result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
}

- (void)notifyHybridPageLifecycleChanged:(FLHHybridPageLifecycle)lifecycle pageInfo:(FLHPageInfo *)pageInfo {
    NSDictionary<NSNumber *, NSString *> *methods = @{
                                                      @(FLHHybridPageLifecycleDidInit): @"nativePageDidInit",
                                                      @(FLHHybridPageLifecycleWillAppear): @"nativePageWillAppear",
                                                      @(FLHHybridPageLifecycleDidAppear): @"nativePageDidAppear",
                                                      @(FLHHybridPageLifecycleWillDisappear): @"nativePageWillDisappear",
                                                      @(FLHHybridPageLifecycleDidDisappear): @"nativePageDidDisappear",
                                                      @(FLHHybridPageLifecycleWillDealloc): @"nativePageWillDealloc",
                                                      };
    NSString *methodName = methods[@(lifecycle)];
    NSAssert(methodName != nil, @"Lifecycle %lu is invalid.", (unsigned long)lifecycle);
    
    NSString *flutterMethodName = [NSString stringWithFormat:@"%@.%@", self.name, methodName];
    [self.methodChannel invokeMethod:flutterMethodName arguments:pageInfo.toJSON];
}

@end
