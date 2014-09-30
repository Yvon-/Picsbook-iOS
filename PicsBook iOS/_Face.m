// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Face.m instead.

#import "_Face.h"

const struct FaceAttributes FaceAttributes = {
	.nsrectstring = @"nsrectstring",
};

const struct FaceRelationships FaceRelationships = {
	.pic_face = @"pic_face",
};

const struct FaceFetchedProperties FaceFetchedProperties = {
	.fetchedProperty = @"fetchedProperty",
};

@implementation FaceID
@end

@implementation _Face

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Face" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Face";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Face" inManagedObjectContext:moc_];
}

- (FaceID*)objectID {
	return (FaceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic nsrectstring;






@dynamic pic_face;

	



@dynamic fetchedProperty;




@end
