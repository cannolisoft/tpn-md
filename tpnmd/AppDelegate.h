/**
 * File: AppDelegate.h 
 * Description: The application delegate class used for
 *              installing the navigation controller. 
 */

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "TableViewController.h"
#import "TitleViewController.h"
#import "DocTableViewController.h"
#import "WaitTimeImporter.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, WaitTimeImporterDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
    TitleViewController *titleViewController;
    
    WaitTimeImporter *importer;
    NSOperationQueue *operationQueue;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet TitleViewController *titleViewController;


@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Properties for the importer and its background processing queue.
@property (nonatomic, retain) WaitTimeImporter *importer;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;


- (NSURL *)applicationDocumentsDirectory;

@end
