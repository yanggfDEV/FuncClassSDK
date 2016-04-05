//
//  FZiOSCache+TMCache.h
//  Pods
//
//  Created by huyanming on 15/6/22.
//
//

#import "FZiOSCache.h"
#import "TMCache.h"

@interface FZiOSCache (TMCache)
+ (NSInteger)TMCacheSize;

+ (void)objectForKey:(NSString *)key block:(TMCacheObjectBlock)block;

+ (void)removeObjectForKey:(NSString *)key block:(TMCacheObjectBlock)block;

+ (void)trimToDate:(NSDate *)date block:(TMCacheBlock)block;

+ (void)removeAllObjects:(TMCacheBlock)block;

+ (id)objectForKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;

+ (void)trimToDate:(NSDate *)date;

+ (void)removeAllObjects;

+ (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

+ (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(TMCacheObjectBlock)block;

@end
