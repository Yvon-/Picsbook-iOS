// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Face.h instead.

#import <CoreData/CoreData.h>


extern const struct FaceAttributes {
	__unsafe_unretained NSString *nsrectstring;
} FaceAttributes;

extern const struct FaceRelationships {
	__unsafe_unretained NSString *pic_face;
} FaceRelationships;

extern const struct FaceFetchedProperties {
	__unsafe_unretained NSString *fetchedProperty;
} FaceFetchedProperties;

@class Pic;



@interface FaceID : NSManagedObjectID {}
@end

@interface _Face : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FaceID*)objectID;





@property (nonatomic, strong) NSString* nsrectstring;



//- (BOOL)validateNsrectstring:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Pic *pic_face;

//- (BOOL)validatePic_face:(id*)value_ error:(NSError**)error_;




@property (nonatomic, readonly) NSArray *fetchedProperty;


@end

@interface _Face (CoreDataGeneratedAccessors)

@end

@interface _Face (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveNsrectstring;
- (void)setPrimitiveNsrectstring:(NSString*)value;





- (Pic*)primitivePic_face;
- (void)setPrimitivePic_face:(Pic*)value;


@end
