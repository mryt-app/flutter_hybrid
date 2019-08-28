//
//  FLHNativeNavigationMessenger.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import "FLHNativeNavigationMessenger.h"
#import "FLHFirstPageInfo.h"
#import "FLHFlutterHybrid.h"

@implementation FLHNativeNavigationMessenger
@synthesize methodChannel;

DEF_SINGLETON(FLHNativeNavigationMessenger)

- (NSString *)name {
    return @"NativeNavigation";
}

- (void)handleMethodCall:(NSString *)method arguments:(id)arguments result:(FlutterResult)result {
    if ([method isEqualToString:@"flutterCanPopChanged"]) {
        
    } else if ([method isEqualToString:@"fetchStartPageInfo"]) {
        NSDictionary *pageInfo = [FLHFirstPageInfo.sharedInstance.firstPageInfo toJSON];
        result(pageInfo);
    } else if ([method isEqualToString:@"flutterShownPageChanged"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlutterShownPageChanged"
                                                            object:nil
                                                          userInfo:arguments];
        result(@(YES));
    } else if ([method isEqualToString:@"openPage"]) {
        [self _openPageWithArguments:arguments result:result];
    } else if ([method isEqualToString:@"closePage"]) {
        [self _closePageWithArguments:arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)_openPageWithArguments:(id)arguments result:(FlutterResult)result {
    NSString *routeName = arguments[@"routeName"];
    NSDictionary *params = arguments[@"params"];
    BOOL animated = (arguments[@"animated"] ? [arguments[@"animated"] boolValue] : YES);
    [FLHFlutterHybrid.sharedInstance.router openPage:routeName params:params animated:animated completion:^(BOOL finished) {
        result(@(finished));
    }];
}

- (void)_closePageWithArguments:(id)arguments result:(FlutterResult)result {
    NSString *pageId = arguments[@"pageId"];
    NSDictionary *params = arguments[@"params"];
    BOOL animated = (arguments[@"animated"] ? [arguments[@"animated"] boolValue] : YES);
    [FLHFlutterHybrid.sharedInstance.router closePage:pageId params:params animated:animated completion:^(BOOL finished) {
        result(@(finished));
    }];
}

@end
