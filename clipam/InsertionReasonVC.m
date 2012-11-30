//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "InsertionReasonVC.h"
#import "AppDelegate.h"
#import "AppManager.h"
#import "ViewController.h"

@implementation InsertionReasonVC

AppManager *appMgr;
ClipDataObject *insertionReasonDO;
ClipDataProperty *cdp;

@synthesize checkedCell, tv;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    appMgr = [AppManager singletonAppManager];
    insertionReasonDO = [appMgr.cdMgr getCdoForKey:CDOKEY_INSERTION_REASON];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InsertionReasonCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // perform cell specific operations
    switch (indexPath.row) 
    {
        case 0:
            [cell.textLabel setText:CDP_NEW_INDICATION_FOR_LINE];
            cdp = [insertionReasonDO getCdpWithLabel:CDP_NEW_INDICATION_FOR_LINE];
            break;
        case 1:
            [cell.textLabel setText:CDP_REPLACE_MALFUNCTION_LINE];
            cdp = [insertionReasonDO getCdpWithLabel:CDP_REPLACE_MALFUNCTION_LINE];
            break;
        case 2:
            [cell.textLabel setText:CDP_SUSPECTED_LINE_INFECTION];
            cdp = [insertionReasonDO getCdpWithLabel:CDP_SUSPECTED_LINE_INFECTION];
            break;
        case 3:
            [cell.textLabel setText:CDP_OTHER];
            cdp = [insertionReasonDO getCdpWithLabel:CDP_OTHER];
            break;
    }
    
    if (cdp.isChecked) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        checkedCell = indexPath;
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    

    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL enableGuidewireQuestion = NO;

    // Navigation logic may go here. Create and push another view controller.
    AppDelegate *appDelegate = 
    [[UIApplication sharedApplication] delegate];
    
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
    [currCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    // if check mark on row is not set
    if (checkedCell != indexPath)
        [tableView reloadData];
    
    switch (indexPath.row) 
    {
        case 0:
            [insertionReasonDO checkCdpInCollectionWithLabel:CDP_NEW_INDICATION_FOR_LINE];
            break;
        case 1:
            [insertionReasonDO checkCdpInCollectionWithLabel:CDP_REPLACE_MALFUNCTION_LINE];
            break;
        case 2:
            [insertionReasonDO checkCdpInCollectionWithLabel:CDP_SUSPECTED_LINE_INFECTION];
            enableGuidewireQuestion = YES;
            break;
        case 3:
            [insertionReasonDO checkCdpInCollectionWithLabel:CDP_OTHER];
            break;
    }

    [appDelegate.vc1 setInsertionReason:currCell.textLabel.text enableFollowUp:enableGuidewireQuestion];

}

@end
