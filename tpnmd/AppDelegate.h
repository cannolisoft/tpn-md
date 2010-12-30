/**
 * File: AppDelegate.h 
 * Description: The application delegate class used for
 *              installing the navigation controller. 
 */

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "WaitTimeImporter.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, WaitTimeImporterDelegate>
{
    UIWindow *window;
    UINavigationController *myNavController;
    
    
    WaitTimeImporter *importer;
    NSOperationQueue *operationQueue;
    
    MapViewController *mapViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *myNavController;
@property (nonatomic, retain) IBOutlet MapViewController *mapViewController;

// Properties for the importer and its background processing queue.
@property (nonatomic, retain) WaitTimeImporter *importer;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;

@end
