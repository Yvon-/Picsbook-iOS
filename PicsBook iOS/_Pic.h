// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Pic.h instead.

#import <CoreData/CoreData.h>


extern const struct PicAttributes {
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *path;
} PicAttributes;

extern const struct PicRelationships {
	__unsafe_unretained NSString *pic_face;
} PicRelationships;

extern const struct PicFetchedProperties {
} PicFetchedProperties;

@class Face;






@interface PicID : NSManagedObjectID {}
@end

@interface _Pic : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PicID*)objectID;





@property (nonatomic, strong) NSNumber* latitude;



@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* path;



//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *pic_face;

- (NSMutableSet*)pic_faceSet;





@end

@interface _Pic (CoreDataGeneratedAccessors)

- (void)addPic_face:(NSSet*)value_;
- (void)removePic_face:(NSSet*)value_;
- (void)addPic_faceObject:(Face*)value_;
- (void)removePic_faceObject:(Face*)value_;

@end

@interface _Pic (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePath;
- (void)setPrimitivePath:(NSString*)value;





- (NSMutableSet*)primitivePic_face;
- (void)setPrimitivePic_face:(NSMutableSet*)value;


@end
