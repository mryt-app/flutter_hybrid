//
//  FLHFlutterHybrid.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import "FLHFlutterHybrid.h"
#import "FLHFlutterEngine.h"
#import "FLHOrderedDictionary.h"
#import "FLHNativeNavigationMessenger.h"

typedef FLHFlutterContainerViewController * (^FLHPageBuilder)(NSString *route, NSDictionary *params);

@interface FLHFlutterHybrid ()

@property (nonatomic, strong) id<FLHFlutterViewManager> flutterViewManager;
@property (nonatomic, strong) FLHMutableOrderedDictionary<NSString *, NSString *> *containerViewControllers;

@property (nonatomic, assign) BOOL isRendering;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation FLHFlutterHybrid

DEF_SINGLETON(FLHFlutterHybrid)

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _containerViewControllers = [[FLHMutableOrderedDictionary alloc] initWithCapacity:8];
        _isRendering = NO;
        _isRunning = NO;
    }
    return self;
}

#pragma mark - Flutter

- (FlutterViewController *)flutterViewController {
    return [_flutterViewManager viewController];
}

- (void)startFlutterWithRouter:(id<FLHRouter>)router {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.router = router;
        self.flutterViewManager = [[FLHFlutterEngine alloc] initWithRouter:router];
        [self.flutterViewManager resume];
        
        self.isRendering = YES;
        self.isRunning = YES;
    });
}

- (void)popOnPage:(NSString *)pageId {
    [FLHNativeNavigationMessenger.sharedInstance backButtonPressedOnPage:pageId];
}

#pragma mark - Container Management

- (BOOL)containsContainerViewController:(FLHFlutterContainerViewController *)viewController {
    NSParameterAssert(viewController != nil);
    return [[_containerViewControllers allKeys] containsObject:viewController.uniqueID];
}

- (void)addContainerViewController:(FLHFlutterContainerViewController *)viewController {
    NSParameterAssert(viewController != nil);
    _containerViewControllers[viewController.uniqueID] = viewController.uniqueID;
}

- (void)removeContainerViewController:(FLHFlutterContainerViewController *)viewController {
    NSParameterAssert(viewController != nil);
    [_containerViewControllers removeObjectForKey:viewController.uniqueID];
}

- (BOOL)isTopContainerViewController:(FLHFlutterContainerViewController *)viewController {
    NSParameterAssert(viewController != nil);
    guard(_containerViewControllers.count > 0) else { return NO; }
    return [_containerViewControllers.allValues.lastObject isEqualToString:viewController.uniqueID];
}

#pragma mark - App Control

- (void)pause {
    guard(_isRendering) else { return; }
    
    [self.flutterViewManager pause];
    _isRendering = NO;
}

- (void)resume {
    guard(!_isRendering) else { return; }
    
    [self.flutterViewManager resume];
    _isRendering = YES;
}

- (void)inactive {
    [self.flutterViewManager inactive];
}

- (BOOL)isRunning {
    return _isRunning;
}

@end
