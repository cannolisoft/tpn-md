//
//  DocTableViewController.m
//  tpnmd
//
//  Created by gg on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocTableViewController.h"

#import "DocSearchViewController.h"
#import "Physician.h"
#import "Office.h"
#import "Specialty.h"

@implementation DocTableViewController

@synthesize detailViewController, navigationItem;
@synthesize fetchedResultsController = _fetchedResultsController, context = _context;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchDisplayController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Specialty" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *officeGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:officeGroupSort, nil]];    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context sectionNameKeyPath:@"name" 
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    
    [officeGroupSort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[_fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        id<NSFetchedResultsSectionInfo> info = [[_fetchedResultsController sections] objectAtIndex:0];
        return info.numberOfObjects;
    }
    else
    {
        Specialty *special = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        return [special.physicians count];
    }
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath inTable: (UITableView *)tableView {
    Physician *doc;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        doc = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        NSString *txt = self.searchDisplayController.searchBar.text;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"name contains[cd] %@", txt];
        NSArray *specialties = [doc.specialty allObjects];
        NSArray *matches = [specialties filteredArrayUsingPredicate:pred];
        
        NSString *result = [[matches valueForKey:@"name"] componentsJoinedByString:@", "];
        cell.detailTextLabel.text = result;
    }
    else
    {
        Specialty *specialty = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        
        NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *docs = [[specialty.physicians allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descrip]];
        
        doc = [docs objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = doc.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath inTable:tableView];
    
    return cell;
}

/**
 * Handler for the UITableView, what is the title for a given section.
 * @return an NSString* with the corresponding title.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor whiteColor]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Physician *doc;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        doc = [_fetchedResultsController objectAtIndexPath:indexPath];
    }
    else
    {
        Specialty *specialty = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *docs = [[specialty.physicians allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descrip]];
        doc = [docs objectAtIndex:indexPath.row];
    }

    DocDetailViewController *detail = [[DocDetailViewController alloc] initWithPhysician:doc];
    
    // The detail view does not want a toolbar so hide it
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];

}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger
                                                                )scope
{

    NSPredicate *filterPredicate;
    
    //Specialty
    if(scope == 0){
        filterPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    }
    else
    {
        filterPredicate = [NSPredicate predicateWithFormat:@"ANY specialty.name CONTAINS[cd] %@", searchText];        
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate: filterPredicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Physician" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *officeGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:officeGroupSort, nil]];    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context sectionNameKeyPath:nil 
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    
    [officeGroupSort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.fetchedResultsController = nil;
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSInteger searchOption = [controller.searchBar selectedScopeButtonIndex];
    
    [self filterContentForSearchText: searchString scope: searchOption];

    
    
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = [controller.searchBar text];
    
    [self filterContentForSearchText: searchString scope: searchOption];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    
    self.fetchedResultsController = nil;
}


- (void)dealloc {
    [navigationItem release];
    [detailViewController release];
    
    [_fetchedResultsController release];
    [_context release];
    
    [super dealloc];
}


@end

