//
//  FLHFlutterPage.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FLHFlutterPage <NSObject>

@property (nonatomic, copy, readonly) NSString *routeName;
@property (nonatomic, strong, readonly, nullable) NSDictionary *params;
@property (nonatomic, copy, readonly) NSString *uniqueID;

- (instancetype)initWithRoute:(NSString *)route params:(nullable NSDictionary *)params;
- (void)popOrClose;

@end

NS_ASSUME_NONNULL_END
