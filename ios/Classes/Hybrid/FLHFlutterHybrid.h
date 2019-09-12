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

NS_ASSUME_NONNULL_BEGIN

@interface FLHFlutterHybrid : NSObject

@property (nonatomic, strong) id<FLHRouter> router;

AS_SINGLETON(FLHFlutterHybrid)

#pragma mark - Flutter

- (FlutterViewController *)flutterViewController;
- (void)startFlutterWithRouter:(id<FLHRouter>)router;

#pragma mark - Public

/**
 * Pop on page `pageId`.
 * If the flutter page navigated, then call Navigator.pop,
 * else route.closePage.
 */
- (void)popOnPage:(NSString *)pageId;

#pragma mark - Container Management

- (BOOL)containsContainerViewController:(FLHFlutterContainerViewController *)viewController;
- (void)addContainerViewController:(FLHFlutterContainerViewController *)viewController;
- (void)removeContainerViewController:(FLHFlutterContainerViewController *)viewController;
- (BOOL)isTopContainerViewController:(FLHFlutterContainerViewController *)viewController;

#pragma mark - App Control

- (void)pause;
- (void)resume;
- (void)inactive;
- (BOOL)isRunning;

@end

NS_ASSUME_NONNULL_END
