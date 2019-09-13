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
#import "FLHHybridPageLifecycle.h"
#import "FLHNativePageLifecycleMessenger.h"
#import "FLHFlutterHybridPageManager.h"

#define FLUTTER_VIEW_CONTROLLER                       \
  FLHFlutterHybrid.sharedInstance.flutterManager.flutterViewController

@interface FLHFlutterContainerViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, copy, readwrite) NSString *routeName;
@property(nonatomic, strong, readwrite) NSDictionary *params;
@property(nonatomic, copy, readwrite) NSString *uniqueID;
@property(nonatomic, strong) FLHPageInfo *pageInfo;

@property(nonatomic, strong) UIImageView *screenshotView;

@end

@implementation FLHFlutterContainerViewController

#pragma mark - Lifecycle

- (void)dealloc {
  [self _notifyWillDealloc];
  [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithRoute:(NSString *)route params:(NSDictionary *)params {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _routeName = [route copy];
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

#pragma mark - Setup

- (void)_setup {
  NSUInteger serialNumber = [FLHFlutterHybrid.sharedInstance.pageManager nextPageSerialNumber];
  _uniqueID = [NSString stringWithFormat:@"%lu", (unsigned long)serialNumber];
  _pageInfo = [[FLHPageInfo alloc] initWithRouteName:_routeName
                                              params:_params
                                            uniqueID:_uniqueID];
  [FLHFlutterHybrid.sharedInstance.pageManager increasePageCount];

  SEL sel = @selector(onFlutterShownPageChanged:);
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:sel
                                             name:@"FlutterShownPageChanged"
                                           object:nil];

  [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidInit];
}

- (void)_setupView {
  // setup screenshot view
  self.screenshotView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  self.screenshotView.backgroundColor = [UIColor whiteColor];
  self.screenshotView.opaque = YES;
  [self.view addSubview:self.screenshotView];
}

#pragma mark - View Lifecyle

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // For new page, we should attach flutter view in viewWillAppear
  // for better performance.
  if (![FLHFlutterHybrid.sharedInstance.pageManager containsPage:self]) {
    [self attatchFlutterView];
  }

  [self showScreenshotView];

  [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillAppear];

  // Save first time page info.
  if ([FLHFlutterHybrid.sharedInstance firstPageInfo] == nil) {
    [FLHFlutterHybrid.sharedInstance initializeFirstPageInfo:_pageInfo];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
    
  // Ensure flutter view is attached.
  [FLHFlutterHybrid.sharedInstance resume];
  [self attatchFlutterView];

  [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidAppear];

  [FLHFlutterHybrid.sharedInstance.pageManager addPage:self];

  self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
  if ([FLHFlutterHybrid.sharedInstance.pageManager isTopPage:self]) {
    [self cacheScreenshot];
  }

  self.screenshotView.image = [self cachedScreenshotImage];
  if (self.screenshotView.image) {
    [self.view bringSubviewToFront:self.screenshotView];
  }

  [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillDisappear];
  [FLHFlutterHybrid.sharedInstance inactive];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidDisappear];

  [self clearScreenshot];
  [super viewDidDisappear:animated];
}

#pragma mark - Notification Handler

- (void)onFlutterShownPageChanged:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"newPage"] isEqual:self.uniqueID]) {
        // After page transitioned, flutter resumed and start rendering
        // may flash the past page, so we delay show the flutter view
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf showFlutterView];
        });
    }
}

#pragma mark - Screenshot

- (void)cacheScreenshot {
  UIImage *screenshot = [self.view flh_screenshot];
  if (screenshot) {
    FLHStackCacheImageObject *cacheImageObject =
        [[FLHStackCacheImageObject alloc] initWithImage:screenshot];
    [FLHScreenshotCache.sharedInstance pushObject:cacheImageObject
                                           forKey:self.uniqueID];
  }
}

- (void)clearScreenshot {
  self.screenshotView.image = nil;
}

- (UIImage *)cachedScreenshotImage {
  FLHStackCacheImageObject *cachedImageObject =
      [FLHScreenshotCache.sharedInstance objectForKey:self.uniqueID];
  return cachedImageObject.image;
}

- (BOOL)showScreenshotView {
  self.screenshotView.image = [self cachedScreenshotImage];

  if ([self isFlutterViewAttatched]) {
    UIViewController *flutterViewController = FLUTTER_VIEW_CONTROLLER;
    NSUInteger flutterViewIndex =
        [self.view.subviews indexOfObject:flutterViewController.view];
    NSUInteger screenshotViewIndex =
        [self.view.subviews indexOfObject:self.screenshotView];
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
    [self.view insertSubview:flutterViewController.view
                belowSubview:self.screenshotView];
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
    NSUInteger flutterViewIndex =
        [self.view.subviews indexOfObject:flutterView];
    NSUInteger screenshotViewIndex =
        [self.view.subviews indexOfObject:self.screenshotView];
    self.screenshotView.backgroundColor = UIColor.clearColor;
    if (screenshotViewIndex > flutterViewIndex) {
      [self.view insertSubview:self.screenshotView belowSubview:flutterView];
    }
  }

  [self clearScreenshot];

  // Invalidate obsolete screenshot.
  [FLHScreenshotCache.sharedInstance invalidateObjectForKey:self.uniqueID];
}

#pragma mark - Public

- (void)popOrClose {
    [FLHFlutterHybrid.sharedInstance popOrCloseOnPage:self.pageInfo.uniqueID];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    If used Navigator.push to present new page in Flutter,
//    the interactivePopGestureRecognizer should be handle by flutter
    return (FLHFlutterHybrid.sharedInstance.router.flutterCanPop == NO);
}

#pragma mark - Action

- (void)_notifyWillDealloc {
  [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillDealloc];

  [FLHScreenshotCache.sharedInstance removeObjectForKey:self.uniqueID];
  [FLHFlutterHybrid.sharedInstance.pageManager removePage:self];

  [FLHFlutterHybrid.sharedInstance.pageManager decreasePageCount];
}

- (void)_notifyLifecyleEvent:(FLHHybridPageLifecycle)lifecycle {
  [FLHNativePageLifecycleMessenger.sharedInstance
      notifyHybridPageLifecycleChanged:lifecycle
                              pageInfo:_pageInfo];
}

@end
