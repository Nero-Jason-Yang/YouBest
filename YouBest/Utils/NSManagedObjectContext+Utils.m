#import "NSManagedObjectContext+Utils.h"

@implementation NSManagedObjectContext (Utils)

+ (id)contextWithModelName:(NSString *)modelName
{
    return [NSManagedObjectContext contextWithModelName:modelName storeName:modelName concurrencyType:NSPrivateQueueConcurrencyType];
}

+ (id)contextWithModelName:(NSString *)modelName storeName:(NSString *)storeName concurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSURL *modelURL = [NSManagedObjectContext modelURLWithModelName:modelName extension:@"momd"];
    NSURL *storeURL = [NSManagedObjectContext storeURLWithStoreName:storeName extension:@"sqlite"];
    return [NSManagedObjectContext contextWithModelURL:modelURL storeURL:storeURL concurrencyType:concurrencyType];
}

+ (id)contextWithModelURL:(NSURL *)modelURL storeURL:(NSURL *)storeURL concurrencyType:(NSManagedObjectContextConcurrencyType)type
{
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES]};
    if (![store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NBLog(@"Unresolved error %@, at file:%s(%d)", error, __FILE__, __LINE__);
        abort();
    }
    
    if (![storeURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error]) {
        NBLog(@"Unresolved error %@, at file:%s(%d)", error, __FILE__, __LINE__);
        abort();
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [context setPersistentStoreCoordinator:store];
    return context;
}

- (void)save
{
    NSError *error;
    if ([self hasChanges] && ![self save:&error]) {
        NBLog(@"Database save error %@", error);
        abort();
    }
}

- (id)createObjectForEntityName:(NSString *)entityName
{
    [self checkEntityName:entityName];
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (NSUInteger)fetchCountForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setReturnsObjectsAsFaults:YES];
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
    if (error) {
        NBLog(@"Database count error: %@", error);
    }
    if (count == NSNotFound) {
        count = 0;
    }
    
    return count;
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)limit fetchOffset:(NSUInteger)offset
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    if (limit > 0) {
        [request setFetchLimit:limit];
    }
    if (offset > 0) {
        [request setFetchOffset:offset];
    }
    
    return [self executeFetchRequest:request];
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [self fetchObjectsForEntityName:entityName withPredicate:predicate sortDescriptors:sortDescriptors fetchLimit:0 fetchOffset:0];
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName
{
    return [self fetchObjectsForEntityName:entityName withPredicate:nil sortDescriptors:nil fetchLimit:0 fetchOffset:0];
}

- (id)fetchFirstObjectForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSArray *array = [self fetchObjectsForEntityName:entityName withPredicate:predicate sortDescriptors:sortDescriptors fetchLimit:1 fetchOffset:0];
    return array.count > 0 ? array[0] : nil;
}

- (id)fetchObjectForURI:(NSString *)uri
{
    if (!uri) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:uri];
    if (!url) {
        return nil;
    }
    NSManagedObjectID *moid = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
    if (!moid) {
        return nil;
    }
    return [self objectRegisteredForID:moid];
}

#pragma mark private

+ (NSURL *)modelURLWithModelName:(NSString *)modelName extension:(NSString *)extension
{
    NSParameterAssert(modelName);
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:extension];
    return modelURL;
}

+ (NSURL *)storeURLWithStoreName:(NSString *)storeName extension:(NSString *)extension
{
    NSParameterAssert(storeName);
    if (extension) {
        storeName = [storeName stringByAppendingPathExtension:extension];
    }
    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:storeName];
    return storeURL;
}

- (void)checkEntityName:(NSString *)entityName
{
    if (![self.persistentStoreCoordinator.managedObjectModel.entitiesByName objectForKey:entityName]) {
        NBLog(@"Database entity was not defined for name: %@", entityName);
        abort();
    }
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
{
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    if (error) {
        NBLog(@"Database fetch error: %@", error);
    }
    return array;
}

@end
