#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Utils)

+ (id)contextWithModelURL:(NSURL *)modelURL storeURL:(NSURL *)storeURL concurrencyType:(NSManagedObjectContextConcurrencyType)type;
+ (id)contextWithModelName:(NSString *)modelName storeName:(NSString *)storeName;
+ (id)contextWithModelName:(NSString *)modelName;

- (void)save;
- (id)createObjectForEntityName:(NSString *)entityName;
- (NSUInteger)fetchCountForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)limit fetchOffset:(NSUInteger)offset;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName;
- (id)fetchFirstObjectForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (id)fetchObjectForURI:(NSString *)uri;
@end
