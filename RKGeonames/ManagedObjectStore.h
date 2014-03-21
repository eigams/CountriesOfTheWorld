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

- (BOOL)updateItem:(NSString *)entity
         predicate:(NSPredicate *)predicate
             value:(id)newValue
               key:(NSString *)key;

- (BOOL)updateItem:(NSString *)entity
          predicate:(NSPredicate *)predicate
     childPredicate:(NSPredicate *)childPredicate
              value:(id)newValue
                key:(NSString *)key;

- (void)saveData:(id)source updateMainContext:(BOOL)update completion:(void(^)(id obj, NSManagedObjectContext *context))saveBlock;
- (void)saveData:(id)source completion:(void(^)(id obj, NSManagedObjectContext *context))saveBlock;

- (void)writeToDisk;


@end
