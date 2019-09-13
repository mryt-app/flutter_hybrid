//
//  FLHFlutterHybridPageManager.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/9/13.
//

#import <Foundation/Foundation.h>
#import "FLHFlutterPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHFlutterHybridPageManager : NSObject

@property (nonatomic, readonly) NSUInteger pageCount;

- (NSUInteger)nextPageSerialNumber;

- (void)increasePageCount;
- (void)decreasePageCount;

- (BOOL)containsPage:(id<FLHFlutterPage>)page;
- (void)addPage:(id<FLHFlutterPage>)page;
- (void)removePage:(id<FLHFlutterPage>)page;
- (BOOL)isTopPage:(id<FLHFlutterPage>)page;

@end

NS_ASSUME_NONNULL_END
