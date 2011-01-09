//
//  TableViewController.m
//
//  Created by gg on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "OfficeAnnotation.h"

@implementation TableViewController

@synthesize officeModel;

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
    if (indexPath.section == 0)
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
    
    return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return [officeModel.urgentCareOffices count];
    }else{
        return [officeModel.practiceOffices count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"Urgent Care";
    }else{
        return @"Practices";
    }
}

@end