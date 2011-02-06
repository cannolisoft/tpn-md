//
//  TableViewController.m
//
//  Created by gg on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "Office.h"

enum
{
    URGENTCARE_SECTION,
    PRACTICE_SECTION,
    SECTION_COUNT /* Must always be last entry */
};

@implementation TableViewController

@synthesize detailViewController;
@synthesize fetchedResultsController = _fetchedResultsController, context = _context;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// TODO: Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}



- (void)viewDidAppear:(BOOL)animated
{
    //work around problem with translucent toolbar which caused each display
    //of the tableview to push the bottom content inset up by the height
    //of the row. This is a good thing but we only need it once.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tableView.rowHeight, 0);
    
    // Bring back the toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    
    self.fetchedResultsController = nil;
}


- (void)dealloc {
    self.fetchedResultsController = nil;
    
    [super dealloc];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Office" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:groupSort, nameSort, nil]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context
                                          sectionNameKeyPath:@"type"
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    
    [groupSort release];
    [nameSort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}

#pragma mark -
#pragma mark UITableViewDelegate

/**
 * Handler for the UITableView, detect which office was selected and pass that
 * office onto the DetailView UI.
 */
- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Office *office = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    // The detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    self.detailViewController.office = office;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *SubtitleCellIdentifier = @"subtitleCell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubtitleCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SubtitleCellIdentifier] autorelease];
    }
    
    Office *office = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = office.name;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.detailTextLabel.text = [office subtitle];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

/**
 * Handler for the UITableView, how many rows are in a section of the table.
 * @return an NSInteger with the number of offices in thatsection.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

/**
 * Handler for the UITableView, what is the title for a given section.
 * @return an NSString* with the corresponding title.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

@end
