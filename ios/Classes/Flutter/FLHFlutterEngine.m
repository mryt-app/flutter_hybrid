//
//  FLHFlutterEngine.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHFlutterEngine.h"
#import "FLHFlutterViewController.h"

@interface FLHFlutterEngine ()

@property (nonatomic, strong) FlutterEngine *engine;
@property (nonatomic, strong) FLHFlutterViewController *viewController;

@end

@implementation FLHFlutterEngine

- (instancetype)initWithRouter:(id<FLHRouter>)router {
    if (self = [super init]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        _engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
        [_engine runWithEntrypoint:nil];
        
        _viewController = [[FLHFlutterViewController alloc] initWithEngine:_engine nibName:nil bundle:nil];
        [_viewController view]; // force to load view
        
        Class clazz = NSClassFromString(@"GeneratedPluginRegistrant");
        if (clazz) {
            if ([clazz respondsToSelector:NSSelectorFromString(@"registerWithRegistry:")]) {
                [clazz performSelector:NSSelectorFromString(@"registerWithRegistry:")
                            withObject:_engine];
            }
        }
#pragma clang diagnostic pop
    }
    return self;
}

- (FlutterViewController *)viewController {
    return _viewController;
}

- (void)pause {
    [self.viewController flh_viewWillDisappear:NO]; // Send AppLifecycleState.inactive in FlutterViewController
    [self.viewController flh_viewDidDisappear:NO]; // Send AppLifecycleState.paused in FlutterViewController
}

- (void)resume {
    [self.viewController flh_viewWillAppear:NO]; // Send AppLifecycleState.inactive in FlutterViewController
    [self.viewController flh_viewDidAppear:NO]; // Send AppLifecycleState.resumed in FlutterViewController
}

- (void)inactive {
    [self.engine.lifecycleChannel sendMessage:@"AppLifecycleState.inactive"];
}

@end
