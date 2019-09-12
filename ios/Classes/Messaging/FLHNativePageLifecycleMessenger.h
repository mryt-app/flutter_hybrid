//
//  FLHNativePageLifecycleMessenger.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import <Foundation/Foundation.h>
#import "FLHMessenger.h"
#import "FLHBaseToolMacro.h"
#import "FLHHybridPageLifecycle.h"
#import "FLHPageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Send native page lifecycle messages.
 * Flutter side rely on native page lifecyle messages to sync pages with native.
 */
@interface FLHNativePageLifecycleMessenger : NSObject <FLHMessenger>

AS_SINGLETON(FLHNativePageLifecycleMessenger)

- (void)notifyHybridPageLifecycleChanged:(FLHHybridPageLifecycle)lifecycle pageInfo:(FLHPageInfo *)pageInfo;

@end

NS_ASSUME_NONNULL_END
