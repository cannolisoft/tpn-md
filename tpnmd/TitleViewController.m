//
//  TitleViewController.m
//  tpnmd
//
//  Created by gg on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TitleViewController.h"
#import "MapViewController.h"
#import "TableViewController.h"
#import "DocTableViewController.h"


enum
{
    OFFICES_SECTION,
    PHYSICIANS_SECTION,
    
    SECTION_COUNT /* Must always be last entry */
};

enum
{
    OFFICES_HEAD_ITEM,
    OFFICES_LIST_ITEM,
    OFFICES_MAP_ITEM,
    
    OFFICES_ITEM_COUNT /* Must always be last entry */
};

enum
{
    PHYSICIANS_HEAD_ITEM,
    PHYSICIANS_LIST_ITEM,
    
    PHYSICIANS_ITEM_COUNT /* Must always be last entry */
};

@implementation TitleViewController

@synthesize context = _context;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/**
 * Handler for the UITableView, what is the title for a given section.
 * @return an NSString* with the corresponding title.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case OFFICES_SECTION:
            return OFFICES_ITEM_COUNT;
            
        case PHYSICIANS_SECTION:
            return PHYSICIANS_ITEM_COUNT;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case OFFICES_SECTION:
        {
            switch (indexPath.row) {
                case OFFICES_HEAD_ITEM:
                {
                    cell.textLabel.text = @"Care Centers";
                    [cell.imageView setImage: [UIImage imageNamed: @"house.png"]];
                    //cell.backgroundColor = [UIColor colorWithRed:86/255.0 green:159/255.0 blue:211/255.0 alpha:1];
                    break;
                }
                case OFFICES_MAP_ITEM:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.indentationLevel = 2;
                    cell.textLabel.text = @"Map";
                    break;
                }
                case OFFICES_LIST_ITEM:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.indentationLevel = 2;
                    cell.textLabel.text = @"List";
                    break;
                }
            }
            break;
        }
        case PHYSICIANS_SECTION:
        {
            
            switch (indexPath.row) {
                case PHYSICIANS_HEAD_ITEM:
                {
                    cell.textLabel.text = @"Physicians";
                    [cell.imageView setImage: [UIImage imageNamed: @"group.png"]];
                    //cell.backgroundColor = [UIColor colorWithRed:86/255.0 green:159/255.0 blue:211/255.0 alpha:1];
                    break;
                }
                case PHYSICIANS_LIST_ITEM:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.indentationLevel = 2;
                    cell.textLabel.text = @"List";
                    break;
                }
            }
            break;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == OFFICES_HEAD_ITEM
        || indexPath.row == PHYSICIANS_HEAD_ITEM)
    {
        return NULL;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController<DataViewController> *viewController;
    
    switch (indexPath.section) {
        case OFFICES_SECTION:
        {
            switch (indexPath.row) {
                case OFFICES_MAP_ITEM:
                {
                    viewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
                    break;
                }
                case OFFICES_LIST_ITEM:
                {
                    viewController = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
                    break;
                }
            }
            break;
        }
        case PHYSICIANS_SECTION:
        {
            
            switch (indexPath.row) {
                case PHYSICIANS_LIST_ITEM:
                {
                    viewController = [[DocTableViewController alloc] initWithNibName:@"DocTableViewController" bundle:nil];
                    break;
                }
            }
            break;
        }
    }
    
    viewController.context = self.context;

    [self.navigationController pushViewController:viewController animated:YES];
    [self.navigationController setNavigationBarHidden:false animated:true];
    [viewController release];
}

@end
