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

#import "SterileBarriersUsedVC.h"
#import "AppDelegate.h"
#import "AppManager.h"
#import "ViewController2.h"
#import "ViewController.h"

@implementation SterileBarriersUsedVC
@synthesize tv;

AppManager *appMgr;
ClipDataObject *sterileBarriersDO;
ClipDataProperty *cdp;


//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

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
    sterileBarriersDO = [appMgr.cdMgr getCdoForKey:CDOKEY_MAXIMAL_BARRIERS];

}

- (void)viewDidUnload
{
    [self setTv:nil];
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

-(ClipDataProperty *)getCdpForRow:(NSInteger)row
{
    ClipDataProperty *newCdp = nil;
    switch (row) 
    {
            
        case 0:
            newCdp = [sterileBarriersDO getCdpWithLabel:CDP_STERILE_MASK];
            break;
        case 1:
            newCdp = [sterileBarriersDO getCdpWithLabel:CDP_STERILE_DRAPE];
            break;
        case 2:
            newCdp = [sterileBarriersDO getCdpWithLabel:CDP_STERILE_GOWN];
            break;
        case 3:
            newCdp = [sterileBarriersDO getCdpWithLabel:CDP_STERILE_GLOVES];
            break;
        case 4:
            newCdp = [sterileBarriersDO getCdpWithLabel:CDP_STERILE_CAP];
            break;
    }
    
    return newCdp;
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SterileBarriersCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Configure the cell...
    // perform cell specific operations
    cdp = [self getCdpForRow:indexPath.row];
    [cell.textLabel setText:cdp.label];
    
    
    if (cdp.isChecked) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
    
    cdp = [self getCdpForRow:indexPath.row];

    if ([sterileBarriersDO checkCdpInCollectionWithLabel:cdp.label]) 
        currCell.accessoryType = UITableViewCellAccessoryCheckmark;
    else 
        currCell.accessoryType = UITableViewCellAccessoryNone;
        
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:indexPath];
    
    cdp = [self getCdpForRow:indexPath.row];
    
    if ([sterileBarriersDO checkCdpInCollectionWithLabel:cdp.label]) 
        currCell.accessoryType = UITableViewCellAccessoryCheckmark;
    else 
        currCell.accessoryType = UITableViewCellAccessoryNone;
    
}

- (IBAction)btnDoneTouchUp:(id)sender {

    // Navigation logic may go here. Create and push another view controller.
    
    NSString *choices = [sterileBarriersDO createStringFromMultipleCheckedValues];
    
    [appMgr.appDelegate.vc2 setSterileBarriers:choices];

}


@end
