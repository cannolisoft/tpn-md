//
//  TableViewController.m
//
//  Created by gg on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "OfficeAnnotation.h"

enum
{
    URGENTCARE_SECTION,
    PRACTICE_SECTION,
    SECTION_COUNT /* Must always be last entry */
};

@implementation TableViewController

@synthesize officeModel, detailViewController;


- (void)viewDidAppear:(BOOL)animated
{
    // Bring back the toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate

/**
 * Handler for the UITableView, detect which office was selected and pass that
 * office onto the DetailView UI.
 */
- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfficeAnnotation *office = nil;
    if (indexPath.section == URGENTCARE_SECTION)
    {
        office = [officeModel.urgentCareOffices objectAtIndex:indexPath.row];
    }
    else
    {
        office = [officeModel.practiceOffices objectAtIndex:indexPath.row];
    }
    
    // The detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.detailViewController.annotation = office;
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
    
    OfficeAnnotation *office = nil;
    if (indexPath.section == URGENTCARE_SECTION)
    {
        office = [officeModel.urgentCareOffices objectAtIndex:indexPath.row];
    }
    else
    {
        office = [officeModel.practiceOffices objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = office.name;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.detailTextLabel.text = [office subtitle];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_COUNT;
}

/**
 * Handler for the UITableView, how many rows are in a section of the table.
 * @return an NSInteger with the number of offices in thatsection.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == URGENTCARE_SECTION) {
        return [officeModel.urgentCareOffices count];
    }else{
        return [officeModel.practiceOffices count];
    }
    
}

/**
 * Handler for the UITableView, what is the title for a given section.
 * @return an NSString* with the corresponding title.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == URGENTCARE_SECTION) {
        return @"Urgent Care";
    }else{
        return @"Practices";
    }
}

@end
