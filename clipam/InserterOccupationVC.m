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

#import "InserterOccupationVC.h"
#import "AppDelegate.h"
#import "AppManager.h"
#import "ViewController.h"

@implementation InserterOccupationVC

@synthesize checkedCell, tv;

AppManager *appMgr;
ClipDataObject *inserterOccupationDO;
ClipDataProperty *cdp;


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
    inserterOccupationDO = [appMgr.cdMgr getCdoForKey:CDOKEY_INSERTER_OCCUPATION];
    
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
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InserterOccupationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // perform cell specific operations
    switch (indexPath.row) 
    {
            
        case 0:
            [cell.textLabel setText:CDP_FELLOW];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_FELLOW];
            break;
        case 1:
            [cell.textLabel setText:CDP_IV_TEAM];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_IV_TEAM];
            break;
        case 2:
            [cell.textLabel setText:CDP_MEDICAL_STUDENT];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_MEDICAL_STUDENT];
            break;
        case 3:
            [cell.textLabel setText:CDP_OTHER_MEDICAL_STAFF];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_OTHER_MEDICAL_STAFF];
            break;
        case 4:
            [cell.textLabel setText:CDP_PHYSICIAN_ASSISTANT];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_PHYSICIAN_ASSISTANT];
            break;
        case 5:
            [cell.textLabel setText:CDP_ATTENDING_PHYSICIAN];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_ATTENDING_PHYSICIAN];
            break;
        case 6:
            [cell.textLabel setText:CDP_INTERN_RESIDENT];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_INTERN_RESIDENT];
            break;
        case 7:
            [cell.textLabel setText:CDP_OTHER_STUDENT];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_OTHER_STUDENT];
            break;
        case 8:
            [cell.textLabel setText:CDP_PICC_TEAM];
            cdp = [inserterOccupationDO getCdpWithLabel:CDP_PICC_TEAM];
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
    // Navigation logic may go here. Create and push another view controller.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
    [currCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    switch (indexPath.row) 
    {
            
        case 0:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_FELLOW];
            break;
        case 1:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_IV_TEAM];
            break;
        case 2:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_MEDICAL_STUDENT];
            break;
        case 3:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_OTHER_MEDICAL_STAFF];
            break;
        case 4:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_PHYSICIAN_ASSISTANT];
            break;
        case 5:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_ATTENDING_PHYSICIAN];
            break;
        case 6:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_INTERN_RESIDENT];
            break;
        case 7:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_OTHER_STUDENT];
            break;
        case 8:
            [inserterOccupationDO checkCdpInCollectionWithLabel:CDP_PICC_TEAM];
            break;
    }
    
    // if check mark on row is not set
    if (checkedCell != indexPath)
        [tableView reloadData];
    

    [appDelegate.vc1 setInserterOccupation:currCell.textLabel.text];

}

@end
