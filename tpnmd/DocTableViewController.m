//
//  DocTableViewController.m
//  tpnmd
//
//  Created by gg on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocTableViewController.h"

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
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Specialty" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *officeGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:officeGroupSort, nil]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context sectionNameKeyPath:@"name" 
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    //_fetchedResultsController.delegate = self;
    
    [officeGroupSort release];
    //[nameSort release];
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
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
    
    
    Specialty *special = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    return [special.physicians count];
    
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Specialty *specialty = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    
    NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *docs = [[specialty.physicians allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descrip]];
    
    Physician *doc = [docs objectAtIndex:indexPath.row];
    
    
    
    
    cell.textLabel.text = doc.name;
    //cell.detailTextLabel.text = doc.specialty.name;
    
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
    [self configureCell:cell atIndexPath:indexPath];
    
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

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_fetchedResultsController sectionIndexTitles];
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor whiteColor]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Specialty *specialty = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *docs = [[specialty.physicians allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descrip]];
    
    Physician *doc = [docs objectAtIndex:indexPath.row];
    
    //Physician *doc = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    
    DocDetailViewController *detail = [[DocDetailViewController alloc] initWithNibName:@"DocDetailViewController" bundle:nil];
    
    
    // The detail view does not want a toolbar so hide it
    detail.hidesBottomBarWhenPushed = YES;
    
    detail.doc = doc;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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
    self.fetchedResultsController = nil;
    
    [super dealloc];
}


@end

