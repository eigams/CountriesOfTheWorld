//
//  ManagedObjectStore.h
//  RKGeonames
//
//  Created by Stefan Buretea on 1/30/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Singleton.h"

@interface ManagedObjectStore : NSObject

SingletonInterface(ManagedObjectStore);

- (NSArray *)allItems:(NSString *)entity;
- (void)removeAll:(NSString *)entity;

- (NSManagedObject *)managedObjectOfType:(NSString *)entity;

- (void)fetchItem:(NSString *)entity predicate:(NSPredicate *)predicate completion:(void(^)(NSArray *results))block;
- (NSManagedObject *)fetchItem:(NSString *)entity predicate:(NSPredicate *)predicate;
- (BOOL)updateItem:(NSString *)entity predicate:(NSPredicate *)predicate value:(id)newValue key:(NSString *)key;

- (void)saveData:(id)source withBlock:(void(^)(id obj, NSManagedObjectContext *context))saveBlock updateMainContext:(BOOL)update;
- (void)saveData:(id)source withBlock:(void(^)(id obj, NSManagedObjectContext *context))saveBlock;

- (void)writeToDisk;


@end
