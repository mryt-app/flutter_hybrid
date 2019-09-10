//
//  FLHFlutterViewManager.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>

@class FlutterViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol FLHFlutterViewManager <NSObject>

@required

- (FlutterViewController *)viewController;

/**
 * AppLifecycleState.paused
 * The FlutterViewController's parentViewController is nil(isn't visible to user).
 */
- (void)pause;
/**
 * AppLifecycleState.resumed
 * The FlutterViewController is visible and responding to user input.
 */
- (void)resume;
/**
 * AppLifecycleState.inactive
 * The FlutterViewController is transitioning.
 */
- (void)inactive;

@end

NS_ASSUME_NONNULL_END
