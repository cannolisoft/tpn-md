/**
 *
 * File: WaitTime.h 
 * Description: The wait time for an office.
 */

#import <Foundation/Foundation.h>


@interface WaitTime : NSObject {

	NSString *name;
	NSString *type;
	NSString *message;
	NSString *time;
	NSDate *update;
	
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *time;
@property(nonatomic, retain) NSDate *update;

-(NSString *)waitMsg;
-(NSString *)relativeDateString;

@end
