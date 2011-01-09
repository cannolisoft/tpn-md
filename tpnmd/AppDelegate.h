/**
 * File: AppDelegate.h 
 * Description: The application delegate class used for
 *              installing the navigation controller. 
 */

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "TableViewController.h"
#import "WaitTimeImporter.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, WaitTimeImporterDelegate>
{
    UIWindow *window;
    
    UINavigationController *myNavController;
    MapViewController *mapViewController;
    TableViewController *tableViewController;
    
    
    WaitTimeImporter *importer;
    NSOperationQueue *operationQueue;
    
    OfficeModel *officeModel;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *myNavController;
@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;
@property (nonatomic, retain) IBOutlet TableViewController *tableViewController;

// Properties for the importer and its background processing queue.
@property (nonatomic, retain) WaitTimeImporter *importer;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;

@property (nonatomic, retain) OfficeModel *officeModel;

- (IBAction)listAction:(id)sender;
- (IBAction)mapAction:(id)sender;

@end
