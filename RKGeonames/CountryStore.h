//
//  CountryStore.h
//  RKGeonames
//
//  Created by Stefan Buretea on 1/16/14.
//  Copyright (c) 2014 Stefan Burettea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Singleton.h"

@class CountryData;
@class CountryModel;
@class CountryGeonames;

@interface CountryStore : NSObject
{
    NSMutableArray *allItems;
    NSManagedObjectModel *model;
}

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStore;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

SingletonInterface(CountryStore);

- (NSArray *)allItems;
- (CountryModel *)createItem;
- (CountryModel *)createItem:(NSManagedObjectContext *)context;
- (NSManagedObject *)managedObjectOfType:(NSString *)entity;

- (void)saveChanges;
//- (BOOL) updateItem:(CountryGeonames *)source;
- (void)removeAll:(NSString *)entity;
- (NSManagedObject *)getItem:(NSString *)name;
- (NSManagedObject *)getItemAsync:(NSString *)name;

- (void)fetchItem:(NSString *)entity withPredicate:(NSPredicate *)predicate completion:(void(^)(NSArray *results))block;
- (CountryData *)fetchItem:(NSString *)entity withPredicate:(NSPredicate *)predicate;

+ (void)saveAsyncDataInContext:(void(^)(NSManagedObjectContext *context))saveBlock;
- (void)saveDataInContext:(void(^)(NSManagedObjectContext *context))saveBlock;
- (void)saveDataInContext:(void(^)(NSManagedObjectContext *context))saveBlock updateMainContext:(BOOL)update;
- (void)saveData:(id)source withBlock:(void(^)(id obj, NSManagedObjectContext *context))saveBlock updateMainContext:(BOOL)update;

- (void)writeToDisk;

@end
