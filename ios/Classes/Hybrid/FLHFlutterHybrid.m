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
    }
    return self;
}

#pragma mark - Flutter

- (void)startFlutterWithRouter:(id<FLHRouter>)router {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.router = router;
        self.flutterManager = [[FLHFlutterEngine alloc] init];
        [self.flutterManager resume];
        
        self.isRendering = YES;
        self.isRunning = YES;
    });
}

- (void)popOrCloseOnPage:(NSString *)pageId {
    [FLHNativeNavigationMessenger.sharedInstance popOrCloseOnPage:pageId];
}

- (void)initializeFirstPageInfo:(FLHPageInfo *)firstPageInfo {
    if (_firstPageInfo == nil) {
        _firstPageInfo = firstPageInfo;
    }
}

#pragma mark - App Control

- (void)pause {
    guard(_isRendering) else { return; }
    
    [self.flutterManager pause];
    _isRendering = NO;
}

- (void)resume {
    guard(!_isRendering) else { return; }
    
    [self.flutterManager resume];
    _isRendering = YES;
}

- (void)inactive {
    [self.flutterManager inactive];
}

- (BOOL)isRunning {
    return _isRunning;
}

@end
