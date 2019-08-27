//
//  NSArray+FLHUtility.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import "NSArray+FLHUtility.h"

@implementation NSArray (FLHUtility)

- (NSArray *(^)(FLHMapBlock))flh_map {
    return ^(MapBlock block) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
        for (id obj in self) {
            id rtn = block(obj);
            if (rtn) {
                [array addObject:rtn];
            }
        }
        return [array copy];
    };
}

- (NSArray *(^)(FLHFilterBlock))flh_filter {
    return ^(FilterBlock block) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
        for (id obj in self) {
            if (block(obj)) {
                [array addObject:obj];
            }
        }
        return [array copy];
    };
}

- (NSArray *(^)(FLHSortedBlock))flh_sorted {
    return ^(SortedBlock block) {
        return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return block(obj1, obj2);
        }];
    };
}

- (NSArray *(^)(FLHForEachBlock))flh_forEach {
    return ^(ForEachBlock block) {
        BOOL stop = NO;
        for (NSUInteger i = 0; i < self.count; i++) {
            block(i, self[i], &stop);
            if (stop) {
                break;
            }
        }
        return self;
    };
}

- (BOOL(^)(FLHContainsBlock))flh_contains {
    return ^(ContainsBlock block) {
        BOOL flag = NO;
        for (id obj in self) {
            if (block(obj)) {
                flag = YES;
                break;
            }
        }
        return flag;
    };
}

- (NSArray *(^)(FLHDistinctUnionBlock))flh_distinctUnion {
    return ^(DistinctUnionBlock block) {
        NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:self.count];
        NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:self.count];
        for (id item in self) {
            id rtn = block(item);
            if (![array1 containsObject:rtn] && rtn) {
                [array1 addObject:rtn];
                [array2 addObject:item];
            }
        }
        return array2.copy;
    };
}

- (id (^)(FLHFetchBlock))flh_fetch {
    return ^(FetchBlock block) {
        id item;
        for (id obj in self) {
            if (block(obj)) {
                item = obj;
                break;
            }
        }
        return item;
    };
}

@end
