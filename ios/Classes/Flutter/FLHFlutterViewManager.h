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

- (void)pause;
- (void)resume;
- (void)inactive;

@end

NS_ASSUME_NONNULL_END
