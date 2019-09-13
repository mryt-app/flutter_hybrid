//
//  FLHNativeNavigationMessenger.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import <Foundation/Foundation.h>
#import "FLHMessenger.h"
#import "FLHBaseToolMacro.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Send and receive navigation related messages.
 */
@interface FLHNativeNavigationMessenger : NSObject<FLHMessenger>

AS_SINGLETON(FLHNativeNavigationMessenger)

- (void)popOrCloseOnPage:(NSString *)pageId;

@end

NS_ASSUME_NONNULL_END
