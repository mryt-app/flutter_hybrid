//
//  FLHFlutterHybrid.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FLHRouter.h"
#import "FLHFlutterContainerViewController.h"
#import "FLHBaseToolMacro.h"
#import "FLHFlutterHybridPageManager.h"
#import "FLHFlutterManager.h"
#import "FLHPageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHFlutterHybrid : NSObject

@property (nonatomic, readonly) id<FLHRouter> router;
@property (nonatomic, readonly) FLHFlutterHybridPageManager *pageManager;
@property (nonatomic, readonly) id<FLHFlutterManager> flutterManager;
/**
 * Dart's initialization may be late than the first native page shown.
 * Record the first page info, on dart started,
 * fetch the first page info to show corresponding flutter page.
 */
@property (nonatomic, readonly) FLHPageInfo *firstPageInfo;

AS_SINGLETON(FLHFlutterHybrid)

- (void)startFlutterWithRouter:(id<FLHRouter>)router;

- (void)initializeFirstPageInfo:(FLHPageInfo *)firstPageInfo;

/**
 * Pop on page `pageId`.
 * If the flutter page navigated, then call Navigator.pop,
 * else route.closePage.
 */
- (void)popOrCloseOnPage:(NSString *)pageId;

#pragma mark - App Control

- (void)pause;
- (void)resume;
- (void)inactive;
- (BOOL)isRunning;

@end

NS_ASSUME_NONNULL_END
