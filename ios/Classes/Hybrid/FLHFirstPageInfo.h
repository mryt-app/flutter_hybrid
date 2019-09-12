//
//  FLHFirstPageInfo.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import <Foundation/Foundation.h>
#import "FLHPageInfo.h"
#import "FLHBaseToolMacro.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Dart's initialization may be late than the first native page shown.
 * Record the first page info, on dart started,
 * fetch the first page info to show corresponding flutter page.
 */
@interface FLHFirstPageInfo : NSObject

AS_SINGLETON(FLHFirstPageInfo)

@property (nonatomic, readonly) FLHPageInfo *firstPageInfo;

- (void)initializeFirstPageInfo:(FLHPageInfo *)firstPageInfo;

@end

NS_ASSUME_NONNULL_END
