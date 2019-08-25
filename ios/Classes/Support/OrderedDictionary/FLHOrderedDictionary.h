//
//  FLHOrderedDictionary.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Ordered subclass of NSDictionary.
 * Supports all the same methods as NSDictionary, plus a few
 * new methods for operating on entities by index rather than key.
 */
@interface FLHOrderedDictionary<__covariant KeyType, __covariant ObjectType> : NSDictionary<KeyType, ObjectType>

/**
 * These methods can be used to load an XML plist file. The file must have a
 * dictionary node as its root object, and all dictionaries in the file will be
 * treated as ordered. Currently, only XML plist files are supported, not
 * binary or ascii. Xcode will automatically convert XML plists included in the
 * project to binary files in built apps, so  you will need to disable that
 * functionality if you wish to load them with these functions. A good approach
 * is to rename such files with a .xml extension instead of .plist.
 */
+ (nullable instancetype)dictionaryWithContentsOfFile:(NSString *)path;
+ (nullable instancetype)dictionaryWithContentsOfURL:(NSURL *)url;
- (nullable instancetype)initWithContentsOfFile:(NSString *)path;
- (nullable instancetype)initWithContentsOfURL:(NSURL *)url;

/** Returns the nth key in the dictionary. */
- (KeyType)keyAtIndex:(NSUInteger)index;
/** Returns the nth object in the dictionary. */
- (ObjectType)objectAtIndex:(NSUInteger)index;
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)index;
/** Returns the index of the specified key, or NSNotFound if key is not found. */
- (NSUInteger)indexOfKey:(KeyType)key;
/** Returns an enumerator for backwards traversal of the dictionary keys. */
- (NSEnumerator<KeyType> *)reverseKeyEnumerator;
/** Returns an enumerator for backwards traversal of the dictionary objects. */
- (NSEnumerator<ObjectType> *)reverseObjectEnumerator;
/** Enumerates keys ands objects with index using block. */
- (void)enumerateKeysAndObjectsWithIndexUsingBlock:(void (^)(KeyType key, ObjectType obj, NSUInteger idx, BOOL *stop))block;

@end


/**
 * Mutable subclass of FLHOrderedDictionary.
 * Supports all the same methods as NSMutableDictionary, plus a few
 * new methods for operating on entities by index rather than key.
 * Note that although it has the same interface, FLHMutableOrderedDictionary
 * is not a subclass of NSMutableDictionary, and cannot be used as one
 * without generating compiler warnings (unless you cast it).
 */
@interface FLHMutableOrderedDictionary<KeyType, ObjectType> : FLHOrderedDictionary<KeyType, ObjectType>

+ (instancetype)dictionaryWithCapacity:(NSUInteger)count;
- (instancetype)initWithCapacity:(NSUInteger)count;

- (void)addEntriesFromDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keyArray;
- (void)setDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;
- (void)setObject:(ObjectType)object forKey:(KeyType)key;
- (void)setObject:(ObjectType)object forKeyedSubscript:(KeyType)key;

/** Inserts an object at a specific index in the dictionary. */
- (void)insertObject:(ObjectType)object forKey:(KeyType)key atIndex:(NSUInteger)index;
/** Replace an object at a specific index in the dictionary. */
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)object;
- (void)setObject:(ObjectType)object atIndexedSubscript:(NSUInteger)index;
/** Swap the indexes of two key/value pairs in the dictionary. */
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
/** Removes the nth object in the dictionary. */
- (void)removeObjectAtIndex:(NSUInteger)index;
/** Removes the objects at the specified indexes from the mutable ordered set. */
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;

@end

NS_ASSUME_NONNULL_END
