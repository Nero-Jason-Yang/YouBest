//
//  Database.m
//  YouBest
//
//  Created by Jason Yang on 14/11/12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "Database.h"
#import "NSManagedObjectContext+Utils.h"
#import "TaskData.h"
#import "GiftData.h"

#define EntityName_Task @"Task"
#define EntityName_Gift @"Gift"

@interface Database ()
@property (nonatomic) NSManagedObjectContext *context;
@end

@implementation Database

+ (Database *)sharedDatabase {
    static Database *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[Database alloc] init];
    });
    return db;
}

- (id)init {
    if (self = [super init]) {
        self.context = [self load];
        [self addTestingDataSet];
    }
    return self;
}

- (NSManagedObjectContext *)load {
    NSString *modelName = @"Main";
    NSString *storeName = @"Main";
    NSManagedObjectContextConcurrencyType type = NSPrivateQueueConcurrencyType;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:[storeName stringByAppendingPathExtension:@"sqlite"]];
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES]};
    if (![store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        abort();
    }
    if (![storeURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error]) {
        abort();
    }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [context setPersistentStoreCoordinator:store];
    return context;
}

- (void)addTestingDataSet {
    [self.context performBlockAndWait:^{
        if (0 == [self.context fetchCountForEntityName:EntityName_Task withPredicate:nil]) {
            TaskData *data = [self.context createObjectForEntityName:EntityName_Task];
            data.title = @"Clean The Room";
            data.subtitle = @"Mmmmmmmm, Mmmmmmm.";
            data.worth = @(3);
            
            data = [self.context createObjectForEntityName:EntityName_Task];
            data.title = @"Make Your Bed";
            data.subtitle = @"Zzzzzzz.";
            data.worth = @(2);
            
            data = [self.context createObjectForEntityName:EntityName_Task];
            data.title = @"Finish Your Homework";
            data.subtitle = @"Inside one hour.";
            data.worth = @(1);
            
            for (int i = 4; i < 12; i ++) {
                data = [self.context createObjectForEntityName:EntityName_Task];
                data.title = [NSString stringWithFormat:@"Task (%d)", i];
                data.subtitle = @"...";
                data.worth = @(i-3);
            }
        }
        
        [self.context save];
    }];
}

@end
