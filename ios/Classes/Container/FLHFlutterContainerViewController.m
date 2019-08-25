//
//  FLHFlutterContainerViewController.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHFlutterContainerViewController.h"
#import "FLHScreenshotCache.h"
#import "FLHStackCacheImageObject.h"
#import "FLHFlutterHybrid.h"
#import "UIView+Screenshot.h"
#import "FLHFirstPageInfo.h"

#define FLUTTER_VIEW_CONTROLLER FLHFlutterHybrid.sharedInstance.flutterViewController

@interface FLHFlutterContainerViewController ()

@property (nonatomic, copy, readwrite) NSString *route;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, copy, readwrite) NSString *uniqueID;

@property (nonatomic, strong) UIImageView *screenshotView;
@property (nonatomic,assign) BOOL interactivePopGestureActive;

@end

@implementation FLHFlutterContainerViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    [self notifyWillDealloc];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithRoute:(NSString *)route params:(NSDictionary *)params {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _route = [route copy];
        _params = params;
        [self _setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self _setupView];
}

#pragma mark - View Lifecyle

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [FLHFlutterHybrid.sharedInstance resume];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController.interactivePopGestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        self.interactivePopGestureActive = true;
    }
    
    [FLHFlutterHybrid.sharedInstance resume];
    // For new page, we should attach flutter view in viewWillAppear
    // for better performance.
    if (![FLHFlutterHybrid.sharedInstance containsContainerViewController:self]) {
        [self attatchFlutterView];
    }
    
    [self showScreenshotView];
    
    //    TODO: Notify flutter pageWillShow
    
    // Save first time page info.
    if (![FLHFirstPageInfo.sharedInstance hasInitialized]) {
        [FLHFirstPageInfo.sharedInstance initializeWithRoute:_route params:_params uniqueID:_uniqueID];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [FLHFlutterHybrid.sharedInstance resume];
    
    // Ensure flutter view is attached.
    [self attatchFlutterView];
    
    //    TODO: Notify flutter pageDidShow
    
    [FLHFlutterHybrid.sharedInstance addContainerViewController:self];
    
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (weakSelf.isViewLoaded && weakSelf.view.window) {
                           // viewController is visible
                           [weakSelf showFlutterView];
                       }
                   });
    
    self.interactivePopGestureActive = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([FLHFlutterHybrid.sharedInstance isTopContainerViewController:self] &&
        self.navigationController.interactivePopGestureRecognizer.state != UIGestureRecognizerStateBegan &&
        !self.interactivePopGestureActive) {
        [self cacheScreenshot];
    }
    self.interactivePopGestureActive = NO;
    
    self.screenshotView.image = [self cachedScreenshotImage];
    if (self.screenshotView.image) {
        [self.view bringSubviewToFront:self.screenshotView];
    }
    
//    Notify flutter pageWillDisappear
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
//    Notify flutter pageDidDisappear
    
    [self clearScreenshot];
    [super viewDidDisappear:animated];
    
    [FLHFlutterHybrid.sharedInstance inactive];
    self.interactivePopGestureActive = NO;
}

#pragma mark - Instance Counter

static NSUInteger kInstanceCount = 0;

+ (NSUInteger)instanceCount {
    return kInstanceCount;
}

+ (void)increaseInstanceCount {
    kInstanceCount++;
    if (kInstanceCount == 1) {
        [FLHFlutterHybrid.sharedInstance resume];
    }
}

+ (void)decreaseInstanceCount {
    kInstanceCount--;
    if ([self.class instanceCount] == 0) {
        [[FLHScreenshotCache sharedInstance] clearAllObjects];
        [FLHFlutterHybrid.sharedInstance pause];
    }
}

#pragma mark - Setup

- (void)_setup
{
    static long long serialNumber = 0;
    serialNumber++;
    _uniqueID = [NSString stringWithFormat:@"%lld", serialNumber];
    
    [self.class increaseInstanceCount];
    
    SEL sel = @selector(flutterViewDidShow:);
    NSString *notiName = @"flutter_boost_container_showed";
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:sel
                                               name:notiName
                                             object:nil];
    
    //    TODO: Notify InitPage
}

- (void)_setupView {
    // setup screenshot view
    self.screenshotView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.screenshotView.backgroundColor = [UIColor whiteColor];
    self.screenshotView.opaque = YES;
    [self.view addSubview:self.screenshotView];
}

#pragma mark - Notification

- (void)flutterViewDidAppear:(NSDictionary *)params {
  // Notify flutter view appeared.
}

- (void)flutterViewDidShow:(NSNotification *)notification {
  __weak typeof(self) weakSelf = self;
  if ([notification.object isEqual:self.uniqueID]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf showFlutterView];
    });
  }
}

#pragma mark - Screenshot

- (void)cacheScreenshot {
    UIImage *screenshot = [self.view flh_screenshot];
    if (screenshot) {
        FLHStackCacheImageObject *cacheImageObject = [[FLHStackCacheImageObject alloc] initWithImage:screenshot];
        [FLHScreenshotCache.sharedInstance pushObject:cacheImageObject forKey:self.uniqueID];
    }
}

- (void)clearScreenshot {
    self.screenshotView.image = nil;
}

- (UIImage *)cachedScreenshotImage {
    FLHStackCacheImageObject *cachedImageObject = [FLHScreenshotCache.sharedInstance objectForKey:self.uniqueID];
    return cachedImageObject.image;
}

- (BOOL)showScreenshotView {
    self.screenshotView.image = [self cachedScreenshotImage];
    
    if ([self isFlutterViewAttatched]) {
        UIViewController *flutterViewController = FLUTTER_VIEW_CONTROLLER;
        NSUInteger flutterViewIndex = [self.view.subviews indexOfObject:flutterViewController.view];
        NSUInteger screenshotViewIndex = [self.view.subviews indexOfObject:self.screenshotView];
        if (flutterViewIndex > screenshotViewIndex) {
            [self.view insertSubview:flutterViewController.view atIndex:0];
        }
    }
    
    return self.screenshotView.image != nil;
}

#pragma mark - FlutterView

- (BOOL)isFlutterViewAttatched {
    UIView *flutterView = FLUTTER_VIEW_CONTROLLER.view;
    return flutterView.superview == self.view;
}

- (void)attatchFlutterView {
    if ([self isFlutterViewAttatched]) {
        return;
    }
    
    UIViewController *flutterViewController = FLUTTER_VIEW_CONTROLLER;
    [flutterViewController willMoveToParentViewController:nil];
    [flutterViewController removeFromParentViewController];
    [flutterViewController didMoveToParentViewController:nil];
    
    [flutterViewController willMoveToParentViewController:self];
    flutterViewController.view.frame = self.view.bounds;
    
    if (!self.screenshotView.image) {
        [self.view addSubview:flutterViewController.view];
    } else {
        [self.view insertSubview:flutterViewController.view belowSubview:self.screenshotView];
    }
    
    [self addChildViewController:flutterViewController];
    [flutterViewController didMoveToParentViewController:self];
}

- (void)showFlutterView {
    UIViewController *flutterViewController = FLUTTER_VIEW_CONTROLLER;
    UIView *flutterView = flutterViewController.view;
    if (flutterView.superview != self.view) {
        return;
    }
    
    if ([self isFlutterViewAttatched]) {
        NSUInteger flutterViewIndex = [self.view.subviews indexOfObject:flutterView];
        NSUInteger screenshotViewIndex = [self.view.subviews indexOfObject:self.screenshotView];
        self.screenshotView.backgroundColor = UIColor.clearColor;
        if (screenshotViewIndex > flutterViewIndex) {
            [self.view insertSubview:self.screenshotView belowSubview:flutterView];
            [self flutterViewDidAppear:@{ @"uniqueID" : self.uniqueID ?: @"" }];
        }
    }
    
    [self clearScreenshot];
    
    // Invalidate obsolete screenshot.
    [FLHScreenshotCache.sharedInstance invalidateObjectForKey:self.uniqueID];
    
    //    TODO: Notify canPop
}

#pragma mark - Action

- (void)notifyWillDealloc {
    //    TODO: Notify flutter
    
    [FLHScreenshotCache.sharedInstance removeObjectForKey:self.uniqueID];
    [FLHFlutterHybrid.sharedInstance removeContainerViewController:self];
    
    [self.class decreaseInstanceCount];
}



@end
