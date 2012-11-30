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

#import "CatheterTypeVC.h"
#import "AppDelegate.h"
#import "AppManager.h"
#import "ViewController2.h"

@implementation CatheterTypeVC


AppManager *appMgr;
ClipDataObject *cathTypeDO;
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
    cathTypeDO = [appMgr.cdMgr getCdoForKey:CDOKEY_CATHETER_TYPE];
    
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CatheterTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // perform cell specific operations
    switch (indexPath.row) 
    {
            
        case 0:
            [cell.textLabel setText:CDP_DIALYSIS_NON_TUNNELED];
            cdp = [cathTypeDO getCdpWithLabel:CDP_DIALYSIS_NON_TUNNELED];
            break;
        case 1:
            [cell.textLabel setText:CDP_DIALYSIS_TUNNELED];
            cdp = [cathTypeDO getCdpWithLabel:CDP_DIALYSIS_TUNNELED];
            break;
        case 2:
            [cell.textLabel setText:CDP_NON_TUNNELED];
            cdp = [cathTypeDO getCdpWithLabel:CDP_NON_TUNNELED];
            break;
        case 3:
            [cell.textLabel setText:CDP_TUNNELED];
            cdp = [cathTypeDO getCdpWithLabel:CDP_TUNNELED];
            break;
        case 4:
            [cell.textLabel setText:CDP_PICC];
            cdp = [cathTypeDO getCdpWithLabel:CDP_PICC];
            break;
        case 5:
            [cell.textLabel setText:CDP_UMBILICAL];
            cdp = [cathTypeDO getCdpWithLabel:CDP_UMBILICAL];
            break;
        case 6:
            [cell.textLabel setText:CDP_OTHER];
            cdp = [cathTypeDO getCdpWithLabel:CDP_OTHER];
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
    AppDelegate *appDelegate = 
    [[UIApplication sharedApplication] delegate];
    
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
    [currCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    // perform cell specific operations
    switch (indexPath.row) 
    {
            
        case 0:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_DIALYSIS_NON_TUNNELED];
            break;
        case 1:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_DIALYSIS_TUNNELED];
            break;
        case 2:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_NON_TUNNELED];
            break;
        case 3:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_TUNNELED];
            break;
        case 4:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_PICC];
            break;
        case 5:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_UMBILICAL];
            break;
        case 6:
            [cathTypeDO checkCdpInCollectionWithLabel:CDP_OTHER];
            break;
    }
    
    // if check mark on row is not set
    if (checkedCell != indexPath)
        [tableView reloadData];
    


    
    [appDelegate.vc2 setCatheterType:currCell.textLabel.text];
    
}

@end
