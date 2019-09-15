//
//  FLHFlutterHybrid.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import "FLHFlutterHybrid.h"
#import "FLHFlutterEngine.h"
#import "FLHNativeNavigationMessenger.h"

typedef FLHFlutterContainerViewController * (^FLHPageBuilder)(NSString *route, NSDictionary *params);

@interface FLHFlutterHybrid ()

@property (nonatomic, strong) id<FLHRouter> router;
@property (nonatomic, strong) FLHFlutterHybridPageManager *pageManager;
@property (nonatomic, strong) id<FLHFlutterManager> flutterManager;
@property (nonatomic, strong) FLHPageInfo *firstPageInfo;

@property (nonatomic, strong) FLHNativeNavigationMessenger *navigationMessenger;
@property (nonatomic, strong) FLHNativePageLifecycleMessenger *pageLifecyleMessenger;

@property (nonatomic, strong) FLHScreenshotCache *screenshotCache;

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
        _isRendering = NO;
        _isRunning = NO;
        _pageManager = [FLHFlutterHybridPageManager new];
        _navigationMessenger = [FLHNativeNavigationMessenger new];
        _pageLifecyleMessenger = [FLHNativePageLifecycleMessenger new];
        _screenshotCache = [FLHScreenshotCache new];
    }
    return self;
}

#pragma mark - Flutter

- (void)startFlutterWithRouter:(id<FLHRouter>)router {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.router = router;
        self.flutterManager = [[FLHFlutterEngine alloc] init];
        [self.flutterManager resumeFlutterRendering];
        
        self.isRendering = YES;
        self.isRunning = YES;
    });
}

- (void)popOrCloseOnPage:(NSString *)pageId {
    [FLHFlutterHybrid.sharedInstance.navigationMessenger popOrCloseOnPage:pageId];
}

- (void)initializeFirstPageInfo:(FLHPageInfo *)firstPageInfo {
    if (_firstPageInfo == nil) {
        _firstPageInfo = firstPageInfo;
    }
}

#pragma mark - App Control

- (void)inactiveFlutterRendering {
    [self.flutterManager inactiveFlutterRendering];
}

- (void)pauseFlutterRendering {
//    guard(_isRendering) else { return; }
    
    [self.flutterManager pauseFlutterRendering];
    _isRendering = NO;
}

- (void)resumeFlutterRendering {
//    guard(!_isRendering) else { return; }
    
    [self.flutterManager resumeFlutterRendering];
    _isRendering = YES;
}

- (BOOL)isRunning {
    return _isRunning;
}

@end
