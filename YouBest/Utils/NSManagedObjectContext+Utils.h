#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Utils)

+ (id)contextWithModelName:(NSString *)modelName;

- (void)save;

- (id)createObjectForEntityName:(NSString *)entityName;

- (NSUInteger)fetchCountForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)limit fetchOffset:(NSUInteger)offset;

- (id)fetchFirstObjectForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (id)fetchObjectForURI:(NSString *)uri;

@end
