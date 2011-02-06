//
//  Physician.h
//  tpnmd
//
//  Created by gg on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Office;
@class Specialty;

@interface Physician :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * school;
@property (nonatomic, retain) NSString * residency;
@property (nonatomic, retain) NSString * certification;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* specialty;
@property (nonatomic, retain) Office * office;

@end


@interface Physician (CoreDataGeneratedAccessors)
- (void)addSpecialtyObject:(Specialty *)value;
- (void)removeSpecialtyObject:(Specialty *)value;
- (void)addSpecialty:(NSSet *)value;
- (void)removeSpecialty:(NSSet *)value;

@end

