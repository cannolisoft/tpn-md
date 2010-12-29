/**
 * File: SFAnnotation.h 
 * Description: The custom MKAnnotation object 
 *              representing individual offices. 
 */

#import <MapKit/MapKit.h>

@interface OfficeAnnotation : NSObject <MKAnnotation>
{
    NSString *name;
    NSString *type;
    NSString *imagePath;
    
    NSString *address;
    NSString *address2;
	
    NSString *phone;
    NSNumber *latitude;
    NSNumber *longitude;
}


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *address2;
@property (nonatomic, retain) NSString *imagePath;

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

- (UIImage *) getUIImage;

@end


