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

@interface FLHFlutterHybridViewController ()

@property(nonatomic, copy, readwrite) NSString *routeName;
@property(nonatomic, strong, readwrite) NSDictionary *params;
@property(nonatomic, copy, readwrite) NSString *uniqueID;
@property(nonatomic, strong) FLHPageInfo *pageInfo;

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
    
    // Save first time page info.
    if ([FLHFlutterHybrid.sharedInstance firstPageInfo] == nil) {
        [FLHFlutterHybrid.sharedInstance initializeFirstPageInfo:_pageInfo];
    }
    
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self _notifyLifecyleEvent:FLHHybridPageLifecycleWillDisappear];
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
    [FLHNativePageLifecycleMessenger.sharedInstance
     notifyHybridPageLifecycleChanged:lifecycle
     pageInfo:_pageInfo];
}

@end
