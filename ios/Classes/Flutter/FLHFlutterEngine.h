//
//  FLHFlutterEngine.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>
#import "FLHFlutterViewManager.h"
#import "FLHRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHFlutterEngine : NSObject<FLHFlutterViewManager>

- (instancetype)initWithRouter:(id<FLHRouter>)router;

@end

NS_ASSUME_NONNULL_END
