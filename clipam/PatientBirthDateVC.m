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

#import "PatientBirthDateVC.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "AppManager.h"
#import "ClipDataObject.h"
#import "Debug.h"


@implementation PatientBirthDateVC
@synthesize pickerBirthDate;

AppManager *appMgr;
ClipDataObject *birthdateDO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    // Do any additional setup after loading the view from its nib.
    self.pickerBirthDate.datePickerMode = UIDatePickerModeDate;
    // init reference to ClipDataManager
    appMgr = [AppManager singletonAppManager];
    birthdateDO = [appMgr.cdMgr getCdoForKey:CDOKEY_BIRTHDATE];
    

}

- (void)viewDidUnload
{
    [self setPickerBirthDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)btnSelectTouchUp:(id)sender {
    
    [birthdateDO setDateValue:[self.pickerBirthDate date]];    
    [appMgr.appDelegate.vc1 setPatientBirthDate:[birthdateDO getDateString]];

}
@end
