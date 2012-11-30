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

#import "PatientGenderVC.h"
#import "ViewController.h"
#import "AppManager.h"
#import "ClipDataObject.h"
#import "Debug.h"

@implementation PatientGenderVC


AppManager *appMgr;
ClipDataObject *genderDO;
ClipDataProperty *femaleCdp;
ClipDataProperty *maleCdp;
ClipDataProperty *otherCdp;

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
    // Do any additional setup after loading the view, typically from a nib.
    
    // init reference to ClipDataManager
    appMgr = [AppManager singletonAppManager];
    genderDO = [appMgr.cdMgr getCdoForKey:CDOKEY_GENDER];
    femaleCdp = [genderDO getCdpWithLabel:CDP_FEMALE];
    maleCdp = [genderDO getCdpWithLabel:CDP_MALE];
    otherCdp = [genderDO getCdpWithLabel:CDP_OTHER];


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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GenderCell";
    ClipDataProperty *cdp;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // perform cell specific operations
    switch (indexPath.row) 
    {
        // put female first
        case 0:
            [cell.textLabel setText:femaleCdp.label];
            cdp = femaleCdp;
            break;
        case 1:
            [cell.textLabel setText:maleCdp.label];
            cdp = maleCdp;
            break;
        case 2:
            [cell.textLabel setText:otherCdp.label];
            cdp = otherCdp;
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
    
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
    [currCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
    if (indexPath.row == 0) {
        femaleCdp.isChecked = YES;
        maleCdp.isChecked = NO;
        otherCdp.isChecked = NO;
    } else if (indexPath.row == 1) {
        maleCdp.isChecked = YES;
        femaleCdp.isChecked = NO;
        otherCdp.isChecked = NO;
    } else if (indexPath.row == 2 ){
        maleCdp.isChecked = NO;
        femaleCdp.isChecked = NO;
        otherCdp.isChecked = YES;
        
    }
    
    // if check mark on row is not set
    if (checkedCell != indexPath)
        [tableView reloadData];
    
    genderDO.valueSet = YES; 
    [appMgr.appDelegate.vc1 setPatientGender:currCell.textLabel.text];
            
}

@end
