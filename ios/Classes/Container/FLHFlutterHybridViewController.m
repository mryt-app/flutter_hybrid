//
//  FLHFlutterHybridViewController.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/9/13.
//

#import "FLHFlutterHybridViewController.h"
#import "FLHPageInfo.h"
#import "FLHNativePageLifecycleMessenger.h"
#import "FLHFlutterHybrid.h"
#import "FLHFlutterHybridPageManager.h"

@interface FLHFlutterHybridViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, copy, readwrite) NSString *routeName;
@property(nonatomic, strong, readwrite) NSDictionary *params;
@property(nonatomic, copy, readwrite) NSString *uniqueID;
@property(nonatomic, strong) FLHPageInfo *pageInfo;

// Method in `FlutterViewController`, we need call it to restart UI rendering
- (void)surfaceUpdated:(BOOL)appeared;

@end

@implementation FLHFlutterHybridViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    [self _notifyWillDealloc];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithRoute:(NSString *)route params:(NSDictionary *)params {
    if (self = [super initWithEngine:FLHFlutterHybrid.sharedInstance.flutterManager.flutterEngine nibName:nil bundle:nil]) {
        _routeName = [route copy];
        _params = params;
        [self _setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([FLHFlutterHybrid.sharedInstance.pageManager containsPage:self]) {
        [self _detachFromEngine];
    } else {
        [self _attachToEngine];
    }
    
    // Save first time page info.
    if ([FLHFlutterHybrid.sharedInstance firstPageInfo] == nil) {
        [FLHFlutterHybrid.sharedInstance initializeFirstPageInfo:_pageInfo];
    }
    
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self _attachToEngine];
    // Must call, or Flutter UI won't update
    [self surfaceUpdated:YES];
    
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidAppear];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillDisappear];
    
    if (self.isMovingFromParentViewController) {
        // Avoid crash on create new instance
        // Note that if we were doing things that might cause the VC
        // to disappear (like using the image_picker plugin)
        // we shouldn't do this.  But in this case we know we're
        // just going back to the navigation controller.
        // If we needed Flutter to tell us when we could actually go away,
        // we'd need to communicate over a method channel with it.
        [self _detachFromEngine];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidDisappear];
}

#pragma mark - Override

- (void)installSplashScreenViewIfNecessary {
    // Don't install splash screen
}

- (BOOL)loadDefaultSplashScreenView {
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //    If used Navigator.push to present new page in Flutter,
    //    the interactivePopGestureRecognizer should be handle by flutter
    return (FLHFlutterHybrid.sharedInstance.router.flutterCanPop == NO);
}

#pragma mark - Setup

- (void)_setup {
    NSUInteger serialNumber = [FLHFlutterHybrid.sharedInstance.pageManager nextPageSerialNumber];
    _uniqueID = [NSString stringWithFormat:@"%lu", (unsigned long)serialNumber];
    _pageInfo = [[FLHPageInfo alloc] initWithRouteName:_routeName
                                                params:_params
                                              uniqueID:_uniqueID];
    [FLHFlutterHybrid.sharedInstance.pageManager increasePageCount];
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidInit];
}

#pragma mark - Public

- (void)popOrClose {
    [FLHFlutterHybrid.sharedInstance popOrCloseOnPage:self.pageInfo.uniqueID];
}

#pragma mark - Private

- (void)_notifyWillDealloc {
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillDealloc];
    
    [FLHFlutterHybrid.sharedInstance.pageManager removePage:self];
    [FLHFlutterHybrid.sharedInstance.pageManager decreasePageCount];
}

- (void)_notifyLifecyleEvent:(FLHHybridPageLifecycle)lifecycle {
    [FLHFlutterHybrid.sharedInstance.pageLifecyleMessenger
     notifyHybridPageLifecycleChanged:lifecycle
     pageInfo:_pageInfo];
}

- (void)_attachToEngine {
    if (FLHFlutterHybrid.sharedInstance.flutterManager.flutterEngine.viewController != self) {
        [FLHFlutterHybrid.sharedInstance.flutterManager.flutterEngine setViewController:self];
    }
}

- (void)_detachFromEngine {
    [FLHFlutterHybrid.sharedInstance.flutterManager.flutterEngine setViewController:nil];
}

@end
