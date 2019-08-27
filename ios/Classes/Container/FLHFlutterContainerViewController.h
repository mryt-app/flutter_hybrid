//
//  FLHFlutterContainerViewController.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * `FlutterViewController` is embedded in this viewController.
 * The `FlutterViewController` is shared in an application,
 * we use screenshots to seamlessly navigate viewControllers.
 */
@interface FLHFlutterContainerViewController : UIViewController

@property (nonatomic, copy, readonly) NSString *routeName;
@property (nonatomic, strong, readonly, nullable) NSDictionary *params;
@property (nonatomic, copy, readonly) NSString *uniqueID;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithRoute:(NSString *)route params:(nullable NSDictionary *)params NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
