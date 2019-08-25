//
//  FLHStackCacheImageObject.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>
#import "FLHStackCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHStackCacheImageObject : NSObject<FLHStackCacheObject>

@property (nonatomic, readonly) UIImage *image;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
