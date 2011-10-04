//
//  DocTableViewController.m
//  tpnmd
//
//  Created by gg on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocTableViewController.h"

#import "ActionSheetPicker.h"

#import "Physician.h"
#import "Office.h"
#import "Specialty.h"

@interface DocTableViewController()
    @property (nonatomic, retain) NSArray* sectionNames;
    @property (nonatomic) int filteredSectionIdx;

- (NSArray *)buildSectionNames;
@end

@implementation DocTableViewController

@synthesize detailViewController, navigationItem;
@synthesize fetchedResultsController = _fetchedResultsController, context = _context;
@synthesize sectionNames, filteredSectionIdx;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //trick to keep entra separators from appearing in a non-empty table
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];

    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    self.filteredSectionIdx = 0;
    self.sectionNames = [self buildSectionNames];
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

- (NSArray *)buildSectionNames
{
    NSArray* sections = [[self fetchedResultsController] sections];
    
    NSMutableArray* names = [[NSMutableArray alloc] initWithCapacity: [sections count]];
    [names addObject:@"All"];
    for(id<NSFetchedResultsSectionInfo> section in sections)
    {
        [names addObject: [section name]];
        
    }
    
    return names;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[_fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Specialty *special = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    return [special.physicians count];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Specialty *specialty = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    NSSortDescriptor *descrip = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *docs = [[specialty.physicians allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descrip]];
    
    Physician *doc = [docs objectAtIndex:indexPath.row];
    
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

    DocDetailViewController *detail = [[DocDetailViewController alloc] initWithPhysician:doc];
    
    // The detail view does not want a toolbar so hide it
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];

}

#pragma mark -
#pragma mark ButtonActions

- (IBAction)filterAction:(id)sender
{
    //Display the ActionSheetPicker
	[ActionSheetPicker displayActionPickerWithView:self.view data:[self sectionNames] selectedIndex:self.filteredSectionIdx target:self action:@selector(itemWasSelected::) title:@"Select Specialty"];
    
}

#pragma mark -
#pragma mark ActionSheetPicker action

- (void)itemWasSelected:(NSNumber *)selectedIndex:(id)element {
	//Selection was made
    int idx = self.filteredSectionIdx = [selectedIndex intValue];
    
    NSPredicate *filterPredicate;
    if(idx != 0){
        NSString* sectionName = [[self sectionNames] objectAtIndex:idx];
        filterPredicate = [NSPredicate predicateWithFormat:@"name = %@", sectionName];
    }else{
        filterPredicate = [NSPredicate predicateWithValue:TRUE];
    }
    
    [self.fetchedResultsController.fetchRequest setPredicate: filterPredicate];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    [self.tableView reloadData];
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

