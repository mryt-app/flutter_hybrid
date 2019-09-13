//
//  FLHFlutterHybridPageManager.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/9/13.
//

#import "FLHFlutterHybridPageManager.h"
#import "FLHFlutterHybrid.h"
#import "FLHScreenshotCache.h"
#import "FLHOrderedDictionary.h"

static NSUInteger pageSerialNumber = 0;

@interface FLHFlutterHybridPageManager ()

@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, strong) FLHMutableOrderedDictionary<NSString *, NSString *> *pages;

@end

@implementation FLHFlutterHybridPageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pages = [[FLHMutableOrderedDictionary alloc] initWithCapacity:8];
    }
    return self;
}

- (NSUInteger)nextPageSerialNumber {
    return ++pageSerialNumber;
}

- (void)increasePageCount {
    _pageCount++;
    if (_pageCount == 1) {
        //        On the first Flutter page is readying to show, we also think it is resumed.
        [FLHFlutterHybrid.sharedInstance resume];
    }
}

- (void)decreasePageCount {
    _pageCount--;
    if (_pageCount == 0) {
        [[FLHScreenshotCache sharedInstance] clearAllObjects];
        //        The FlutterViewController isn't visible to user, we think the Flutter app is paused.
        [FLHFlutterHybrid.sharedInstance pause];
    }
}

- (BOOL)containsPage:(id<FLHFlutterPage>)page {
    NSParameterAssert(page != nil);
    return [[_pages allKeys] containsObject:page.uniqueID];
}

- (void)addPage:(id<FLHFlutterPage>)page {
    NSParameterAssert(page != nil);
    _pages[page.uniqueID] = page.uniqueID;
}

- (void)removePage:(id<FLHFlutterPage>)page {
    NSParameterAssert(page != nil);
    [_pages removeObjectForKey:page.uniqueID];
}

- (BOOL)isTopPage:(id<FLHFlutterPage>)page {
    NSParameterAssert(page != nil);
    guard(_pages.count > 0) else { return NO; }
    return [_pages.allValues.lastObject isEqualToString:page.uniqueID];
}

@end
