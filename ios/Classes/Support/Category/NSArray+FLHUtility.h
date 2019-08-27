//
//  NSArray+FLHUtility.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import <Foundation/Foundation.h>

typedef id _Nonnull (^FLHMapBlock)(id _Nonnull item);
typedef BOOL(^FLHFilterBlock)(id _Nonnull item);
typedef NSComparisonResult(^FLHSortedBlock)(id _Nonnull item1, id _Nonnull item2);
typedef void(^FLHForEachBlock)(NSUInteger i, id _Nonnull item , BOOL * _Nonnull stop);
typedef BOOL(^FLHContainsBlock)(id _Nonnull item);
typedef id _Nonnull (^FLHDistinctUnionBlock)(id _Nonnull);
typedef BOOL(^FLHFetchBlock)(id _Nonnull item);

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (FLHUtility)

@property(nonatomic, copy, readonly) NSArray* (^flh_map)(FLHMapBlock block);
@property(nonatomic, copy, readonly) NSArray* (^flh_filter)(FLHFilterBlock block);
@property(nonatomic, copy, readonly) NSArray* (^flh_sorted)(FLHSortedBlock block);
@property(nonatomic, copy, readonly) NSArray* (^flh_forEach)(FLHForEachBlock block);
@property(nonatomic, copy, readonly) BOOL (^flh_contains)(FLHContainsBlock block);
@property(nonatomic, copy, readonly) NSArray *(^flh_distinctUnion)(FLHDistinctUnionBlock block);
@property(nonatomic, copy, readonly) id (^flh_fetch)(FLHFetchBlock block);

@end

NS_ASSUME_NONNULL_END
