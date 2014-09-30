// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Pic.m instead.

#import "_Pic.h"

const struct PicAttributes PicAttributes = {
	.latitude = @"latitude",
	.longitude = @"longitude",
	.name = @"name",
	.path = @"path",
};

const struct PicRelationships PicRelationships = {
	.pic_face = @"pic_face",
};

const struct PicFetchedProperties PicFetchedProperties = {
};

@implementation PicID
@end

@implementation _Pic

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Pic" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Pic";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Pic" inManagedObjectContext:moc_];
}

- (PicID*)objectID {
	return (PicID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic latitude;



- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}





@dynamic longitude;



- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}





@dynamic name;






@dynamic path;






@dynamic pic_face;

	
- (NSMutableSet*)pic_faceSet {
	[self willAccessValueForKey:@"pic_face"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"pic_face"];
  
	[self didAccessValueForKey:@"pic_face"];
	return result;
}
	






@end
