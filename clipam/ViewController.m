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

#import "AppDelegate.h"
#import "ViewController.h"
#import "PatientGenderVC.h"
#import "PatientBirthDateVC.h"
#import "PatientIdVC.h"
#import "LocationVC.h"
#import "InsertionDateVC.h"
#import "PersonRecordingVC.h"
#import "InserterOccupationVC.h"
#import "InsertionReasonVC.h"
#import "HandHygienePerformedVC.h"
#import "SterileBarriersUsedVC.h"
#import "SkinPrepUsed.h"
#import "SkinDryVC.h"
#import "InsertionSiteVC.h"
#import "CatheterTypeVC.h"
#import "ViewController2.h"
#import "EulaViewController.h"
#import "AppManager.h"
#import "LocationCodes.h"

@implementation ViewController
@synthesize btnInsertionReason;
@synthesize txtPatientId;
@synthesize lblFacilityId;
@synthesize imageViewBackground;
@synthesize btnGender;
@synthesize btnDateOfBirth;
@synthesize btnLocation;
@synthesize txtLocation;
@synthesize btnDateOfInsertion;
@synthesize btnInserterRecordingData;
@synthesize btnObserverRecordingData;
@synthesize txtFacilityId;
@synthesize btnInserterOccupation;
@synthesize btnNextPage;
@synthesize txtLastName;
@synthesize txtFirstName;
@synthesize txtMiddleName;

@synthesize popoverController;
@synthesize btnYesPiccTeamMember;
@synthesize btnNoPiccTeamMember;
@synthesize btnYesLineExchangeViaGuidewire;
@synthesize btnNoLineExchangeViaGuidewire;
@synthesize hasLocationsInPlan;

AppDelegate *appDelegate;
ClipDataManager *cdMgr;
AppManager *appMgr;

bool inPlanFacility;



- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
}

-(void)resignAllFirstResponders
{
    [txtFacilityId resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtLocation resignFirstResponder];
    [txtMiddleName resignFirstResponder];
    [txtPatientId resignFirstResponder];
    
}

- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)presentEulaModalView
{
    
    if (appMgr.agreedWithEula == TRUE)
        return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@", 
                            [appInfo objectForKey:@"CFBundleShortVersionString"], 
                            [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the 
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed]) {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        NSLog(@"Data saved");
        NSLog(@"%@", currVersion);

        // Create the modal view controller
        EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        
        // we are the delegate that is responsible for dismissing the help view
        eulaVC.delegate = self;
        eulaVC.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentModalViewController:eulaVC animated:YES];
    
    }
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //init reference to ClipDataManager
    cdMgr = appDelegate.cdMgr;
    appDelegate.vc2 = nil;
    appMgr = [AppManager singletonAppManager];
    
    self.hasLocationsInPlan = NO;
    
    // register for notifcations regarding facility and location code updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facilityUpdated:) name:@"gov.cdc.clipam.facilityupdated" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webServiceTimeout:) name:@"gov.cdc.clipam.webservicetimeout" object:nil];
    
    

}

- (void)viewDidUnload
{
    // de-register for notifcations regarding facility and location code updates
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gov.cdc.clipam.facilityupdated" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gov.cdc.clipam.webservicetimeout" object:nil];
    
    [self setLblFacilityId:nil];
    [self setTxtPatientId:nil];
    [self setBtnGender:nil];
    [self setBtnDateOfBirth:nil];
    [self setBtnLocation:nil];
    [self setBtnDateOfInsertion:nil];
    [self setBtnInserterRecordingData:nil];
    [self setBtnInserterOccupation:nil];
    [self setBtnInsertionReason:nil];
    [self setBtnInsertionReason:nil];
    [self setBtnNextPage:nil];
    [self setTxtLastName:nil];
    [self setTxtPatientId:nil];
    [self setBtnObserverRecordingData:nil];
    [self setTxtLocation:nil];
    [self setBtnYesPiccTeamMember:nil];
    [self setBtnNoPiccTeamMember:nil];
    [self setImageViewBackground:nil];
    [self setBtnYesLineExchangeViaGuidewire:nil];
    [self setBtnNoLineExchangeViaGuidewire:nil];
    [self setTxtFacilityId:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)formatButton:(UIButton *)currButton withTitle:(NSString *)currTitle
{
    UIColor *initColor = [UIColor blackColor];
    
    [currButton setTitle:currTitle forState:UIControlStateNormal];
    [currButton setTitleColor:initColor forState:UIControlStateNormal];
    [currButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}

-(void)answeredButton:(UIButton *)currButton withTitle:(NSString *)currTitle
{
    
    UIColor *initColor = [UIColor blackColor];
    
    [currButton setTitle:currTitle forState:UIControlStateNormal];
    [currButton setTitleColor:initColor forState:UIControlStateNormal];
    [currButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    UIColor *initColor = [UIColor blackColor];
    
    [super viewDidAppear:animated];
    
    [self presentEulaModalView];
               
    // initialize UILabels
    
    // init facility ID with value in iOS Settings app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultFacilityId = [defaults stringForKey:@"facility_preference"];
    ClipDataObject *facId = [cdMgr getCdoForKey:CDOKEY_FACILITY_ID];
    if ([facId isValueSet] == YES) 
        self.txtFacilityId.text = [facId getTextValue];
    else {
        if ((defaultFacilityId != nil) && (![defaultFacilityId isEqualToString:@""])) {
            self.txtFacilityId.text = defaultFacilityId;
            [facId setTextValue:defaultFacilityId];
        }
    }
    self.lblFacilityId.textColor = initColor;
    
    // init insertion date with today
    NSDate *today = [NSDate date];
    ClipDataObject *insertionDateDO = [cdMgr getCdoForKey:CDOKEY_INSERTION_DATE];
    if ([insertionDateDO isValueSet] == NO) {
        [insertionDateDO setDateValue:today];    
        [self setInsertionDate:[insertionDateDO getDateString]];
    } else {
        [self formatButton:self.btnDateOfInsertion withTitle:[[cdMgr getCdoForKey:CDOKEY_INSERTION_DATE] getDateString]];
        
    }
    
    self.txtPatientId.textColor = initColor;
    
    // initialize UIButtons
    self.txtPatientId.text = [cdMgr getCdoForKey:CDOKEY_PAT_ID].cdp.textValue;
    self.txtLastName.text = [cdMgr getCdoForKey:CDOKEY_PAT_LAST_NAME].cdp.textValue;
    self.txtFirstName.text = [cdMgr getCdoForKey:CDOKEY_PAT_FIRST_NAME].cdp.textValue;
    self.txtMiddleName.text = [cdMgr getCdoForKey:CDOKEY_PAT_MIDDLE_NAME].cdp.textValue;
    [self formatButton:self.btnLocation withTitle:[[cdMgr getCdoForKey:CDOKEY_LOCATION] getCheckedLabel]];
    [self formatButton:self.btnGender withTitle:[[cdMgr getCdoForKey:CDOKEY_GENDER] getCheckedLabel]];
    [self formatButton:self.btnDateOfBirth withTitle:[[cdMgr getCdoForKey:CDOKEY_BIRTHDATE] getDateString]];
    [self initPiccTeamMemberButtons];
    [self initPersonRecordingDataButtons];
    [self formatButton:self.btnInserterOccupation withTitle:[[cdMgr getCdoForKey:CDOKEY_INSERTER_OCCUPATION] getCheckedLabel]];
    [self formatButton:self.btnInsertionReason withTitle:[[cdMgr getCdoForKey:CDOKEY_INSERTION_REASON] getCheckedLabel]];
    [self initGuidewireQuestion];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    // only support portrait orientation and upside down
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;
    
    return NO;
        
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


-(void)initForm
{
    // initialize UIButtons
    //self.txtPatientId.text = @"Enter Patient ID";
    //[self formatButton:self.btnGender withTitle:@"Enter Gender" ];
    [self formatButton:self.btnDateOfBirth withTitle:@"Enter Date of Birth"  ];
    [self formatButton:self.btnLocation withTitle:@"Enter Location of Patient" ];
    [self formatButton:self.btnDateOfInsertion withTitle:@"Enter Date of Insertion" ];
    [self formatButton:self.btnInserterRecordingData withTitle:@"Select Inserter or Observer" ];
    [self formatButton:self.btnInserterOccupation withTitle:@"Select Occupation of Inserter" ];
    [self formatButton:self.btnInsertionReason withTitle:@"Enter Reason for Insertion" ];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    DebugLog(@"User hit Cancel on Submit Form Alert View.");
}


-(void)presentInvalidFacilityAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Facility ID Error"
                          message: @"No facility exists for this Facility ID.  Log into the NHSN application, navigate to the Facility Info Screen and check the value of your facility ID.  Make sure that matches what is in the CLIP app settings for Facility ID."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}

-(void)presentOutOfPlanFacilityAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Date Out Of Plan Error"
                          message: @"Your facility exists but CLIP is not in your monthly reporting plan for this date of insertion.  Check the insertion date for accuracy. If the insertion date is correct then please log into the NHSN application and create a monthly reporting plan for CLIP data."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}

-(void)presentInvalidDataAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Complete Required Fields"
                          message: @"The current page contains required fields that are incomplete. Please complete all required fields before proceeding to the next page."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}

-(void)presentWebServiceTimeoutAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Location Code Web Service Timeout"
                          message: @"A request to the NHSN CLIP Web Service that is used to get in plan location codes for each facility has timed out. Valid location codes can not be displayed. Please try again later."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}


- (void)webServiceTimeout:(NSNotification *)notif 
{
    
    [self presentWebServiceTimeoutAlert];
    
}


-(void)updateLocationCodes
{
    
    // clear all previous stored locations
    [cdMgr removePropertiesForCdoKey:CDOKEY_LOCATION];
    
    // clear location button label
    [self answeredButton:btnLocation withTitle:@""];

    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *facId = txtFacilityId.text;
    ClipDataObject *insertionDateDO = [cdMgr getCdoForKey:CDOKEY_INSERTION_DATE];
    NSString *dateOfInsertion = [insertionDateDO getUrlDateString];
    
    [appDelegate.clipWS getCurrentFacilityLocations:facId forInsertionDate:dateOfInsertion];
    
}


#pragma mark - Facility ID methods
- (IBAction)txtFacilityIdEditEnd:(id)sender {
    
    [self resignFirstResponder];
    
    if (txtFacilityId.text != nil && ![txtFacilityId.text isEqualToString:@""]) {
        
        ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_FACILITY_ID];
    
        [cdo setTextValue:txtFacilityId.text];
        
        [self updateLocationCodes];
        
    }
    
}

- (void)facilityUpdated:(NSNotification *)notif 
{

    LocationCodes* locationCodes = [notif object];
    
    if (![locationCodes isValidFacility])
        [self presentInvalidFacilityAlert];
    if (![locationCodes isFacilityInPlan])
        [self presentOutOfPlanFacilityAlert];
    

}
#pragma mark - Patient ID methods

- (IBAction)txtPatientIdTouchUp:(id)sender 
{
    self.txtPatientId.text = @"";
}

- (IBAction)txtPatientIdEditEnd:(id)sender {
    
	[sender resignFirstResponder];
    ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_PAT_ID];
    [cdo setTextValue:txtPatientId.text];
    
}

- (void)setPatientId:(NSString *)currPatientId
{
    //    patientId = currPatientId;
    //    [self answeredButton:btnPatientId withTitle:currPatientId];
    //    [self.popoverController dismissPopoverAnimated:YES];
    
}


#pragma mark - Patient Name methods
- (IBAction)btnPatientLastNameEndOnExit:(id)sender {
	[sender resignFirstResponder];
    ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_PAT_LAST_NAME];
    cdo.cdp.textValue = txtLastName.text;
}

- (IBAction)txtPatientLastNameEditEnd:(id)sender {
    
    ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_PAT_LAST_NAME];
    cdo.cdp.textValue = txtLastName.text;
    
}

- (IBAction)txtPatientFirstNameEditEnd:(id)sender {
    
	[sender resignFirstResponder];
    ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_PAT_FIRST_NAME];
    cdo.cdp.textValue = txtFirstName.text;
    
}

- (IBAction)txtPatientMiddleNameEditEnd:(id)sender {
    
	[sender resignFirstResponder];
    ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_PAT_MIDDLE_NAME];
    cdo.cdp.textValue = txtMiddleName.text;
    
}

#pragma mark - Location methods

- (IBAction)txtLocationEditEnd:(id)sender {
    
	[sender resignFirstResponder];
    ClipDataObject *cdo = [cdMgr getCdoForKey:CDOKEY_LOCATION];
    cdo.cdp.textValue = txtLocation.text;

}


- (IBAction)btnLocationTouchUpInside:(id)sender 
{
    [self resignAllFirstResponders];

    LocationVC *locationVC = [[LocationVC alloc] initWithNibName:@"LocationVC" bundle:[NSBundle mainBundle]];
    [locationVC setContentSizeForViewInPopover:CGSizeMake(400,174)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:locationVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnLocation frame] 
                                       fromView:[btnLocation superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}


- (void)setLocation:(NSString *)currLocation
{
    location = currLocation;
    [self answeredButton:btnLocation withTitle:currLocation];
    [self.popoverController dismissPopoverAnimated:YES];

}



#pragma mark - Person Recording Data methods
-(void)selectInserterRecordingDataButton
{
    [btnInserterRecordingData setImage:[UIImage imageNamed:@"inserter_selected.png"] forState:UIControlStateSelected];
    [btnInserterRecordingData setSelected:YES];
    
    [btnObserverRecordingData setImage:[UIImage imageNamed:@"observer_unselected.png"] forState:UIControlStateNormal];
    [btnObserverRecordingData setSelected:NO];

    
}

-(void)selectObserverRecordingDataButton
{
    [btnObserverRecordingData setImage:[UIImage imageNamed:@"observer_selected.png"] forState:UIControlStateSelected];
    [btnObserverRecordingData setSelected:YES];

    [btnInserterRecordingData setImage:[UIImage imageNamed:@"inserter_unselected.png"] forState:UIControlStateNormal];
    [btnInserterRecordingData setSelected:NO];
    
}

-(void)initPersonRecordingDataButtons
{
    ClipDataObject *personRecordingDO = [cdMgr getCdoForKey:CDOKEY_PERSON_RECORDING];
    ClipDataProperty *inserterCdp = [personRecordingDO getCdpWithLabel:CDP_INSERTER];
    ClipDataProperty *observerCdp = [personRecordingDO getCdpWithLabel:CDP_OBSERVER];
    
    if (inserterCdp.isChecked )
        [self selectInserterRecordingDataButton];
    else if (observerCdp.isChecked)
        [self selectObserverRecordingDataButton];

}

- (IBAction)btnInserterRecordingDataTouchUp:(id)sender {
    
    [self resignAllFirstResponders];

    
    if ([sender isSelected]) 
        return;

    ClipDataObject *personRecordingDO = [cdMgr getCdoForKey:CDOKEY_PERSON_RECORDING];
    [personRecordingDO checkCdpInCollectionWithLabel:CDP_INSERTER];
    [self selectInserterRecordingDataButton];
    
}

- (IBAction)btnObserverRecordingDataTouchUp:(id)sender {
    
    [self resignAllFirstResponders];


    if ([sender isSelected]) 
        return;
    
    ClipDataObject *personRecordingDO = [cdMgr getCdoForKey:CDOKEY_PERSON_RECORDING];
    [personRecordingDO checkCdpInCollectionWithLabel:CDP_OBSERVER];
    [self selectObserverRecordingDataButton];
    
}

#pragma mark - PICC Team Member methods
-(void)selectYesPiccTeamMemberButton
{
    [btnYesPiccTeamMember setImage:[UIImage imageNamed:@"yes_selected.png"] forState:UIControlStateSelected];
    [btnYesPiccTeamMember setSelected:YES];
    [btnNoPiccTeamMember setImage:[UIImage imageNamed:@"no_unselected.png"] forState:UIControlStateNormal];
    [btnNoPiccTeamMember setSelected:NO];
    
}

-(void)selectNoPiccTeamMemberButton
{
    [btnNoPiccTeamMember setImage:[UIImage imageNamed:@"no_selected.png"] forState:UIControlStateSelected];
    [btnNoPiccTeamMember setSelected:YES];
    [btnYesPiccTeamMember setImage:[UIImage imageNamed:@"yes_unselected.png"] forState:UIControlStateNormal];
    [btnYesPiccTeamMember setSelected:NO];

}

-(void)initPiccTeamMemberButtons
{
    ClipDataObject *piccTeamDO = [cdMgr getCdoForKey:CDOKEY_PICC_TEAM_MEMBER];
    
    if ([piccTeamDO isValueSet]) {
        if ([piccTeamDO getCdpBool]) {
            [self selectYesPiccTeamMemberButton];
         } else {
            [self selectNoPiccTeamMemberButton];
            
        }
    }
    
}
- (IBAction)btnYesPiccTeamMemberTouchUp:(id)sender {
    
    [self resignAllFirstResponders];

    ClipDataObject *piccTeamDO = [cdMgr getCdoForKey:CDOKEY_PICC_TEAM_MEMBER];
    [piccTeamDO setCdpBool:YES];
    [self selectYesPiccTeamMemberButton];
}

- (IBAction)btnNoPiccTeamMemberTouchUp:(id)sender {
    
    [self resignAllFirstResponders];

    ClipDataObject *piccTeamDO = [cdMgr getCdoForKey:CDOKEY_PICC_TEAM_MEMBER];
    [piccTeamDO setCdpBool:NO];
    [self selectNoPiccTeamMemberButton];
}



#pragma mark - Gender methods
- (IBAction)btnPatientGenderTouchUp:(id)sender 
{
    [self resignAllFirstResponders];

    PatientGenderVC *genderVC = [[PatientGenderVC alloc] initWithNibName:@"PatientGenderVC" bundle:[NSBundle mainBundle]];
    [genderVC setContentSizeForViewInPopover:CGSizeMake(200,174)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:genderVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnGender frame] 
                                       fromView:[btnGender superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}


-(void)setPatientGender:(NSString *)currPatientGender
{
    
    patientGender = currPatientGender;
    [self answeredButton:btnGender withTitle:currPatientGender];
    [self.popoverController dismissPopoverAnimated:YES];
    
}


#pragma mark - Birthdate methods

- (IBAction)btnPatientBirthDateTouchUp:(id)sender {
    
    [self resignAllFirstResponders];

    
    PatientBirthDateVC *birthdateVC = [[PatientBirthDateVC alloc] initWithNibName:@"PatientBirthDateVC" bundle:[NSBundle mainBundle]];
    [birthdateVC setContentSizeForViewInPopover:CGSizeMake(302,258)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:birthdateVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnDateOfBirth frame] 
                                       fromView:[btnDateOfBirth superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}


- (void)setPatientBirthDate:(NSString *)currPatientBirthDate
{
    // print formatted date
    [self answeredButton:btnDateOfBirth withTitle:currPatientBirthDate];
    
    [self.popoverController dismissPopoverAnimated:YES];
    
}

#pragma mark - Insertion Date methods

- (IBAction)btnInsertionDateTouchUp:(id)sender {
    
    [self resignAllFirstResponders];
    
    InsertionDateVC *insertionDateVC = [[InsertionDateVC alloc] initWithNibName:@"InsertionDateVC" bundle:[NSBundle mainBundle]];
    [insertionDateVC setContentSizeForViewInPopover:CGSizeMake(302,258)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:insertionDateVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnDateOfInsertion frame] 
                                       fromView:[btnDateOfInsertion superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)setInsertionDate:(NSString *)currInsertionDate
{
    // print formatted date
    [self answeredButton:btnDateOfInsertion withTitle:currInsertionDate];
    
    [self.popoverController dismissPopoverAnimated:YES];
    
    // update location codes based on insertion date
    [self updateLocationCodes];
    
    
}

#pragma mark - Person Recording methods
- (IBAction)btnPersonRecordingTouchUp:(id)sender 
{
    [self resignAllFirstResponders];

    
    PersonRecordingVC *personRecordingVC = [[PersonRecordingVC alloc] initWithNibName:@"PersonRecordingVC" bundle:[NSBundle mainBundle]];
    [personRecordingVC setContentSizeForViewInPopover:CGSizeMake(200,120)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:personRecordingVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    //    CGRect popoverRect = [self.view convertRect:[self.btnInserterRecordingData frame] 
    //                                       fromView:[btnPersonRecordingData superview]];
    
    //    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}



-(void)setPersonRecording:(NSString *)currPersonRecording
{
    
    personRecording = currPersonRecording;
    //    [self answeredButton:btnPersonRecordingData withTitle:currPersonRecording];
    [self.popoverController dismissPopoverAnimated:YES];
    
}

#pragma mark - Inserter Occupation methods

- (IBAction)btnInserterOccupationTouchUp:(id)sender 
{
    [self resignAllFirstResponders];

    InserterOccupationVC *inserterOccupationVC = [[InserterOccupationVC alloc] initWithNibName:@"InserterOccupationVC" bundle:[NSBundle mainBundle]];
    [inserterOccupationVC setContentSizeForViewInPopover:CGSizeMake(280,440)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:inserterOccupationVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnInserterOccupation frame] 
                                       fromView:[btnInserterOccupation superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}


- (void)setInserterOccupation:(NSString *)currInserterOccupation;
{
    
    inserterOccupation = currInserterOccupation;
    [self answeredButton:btnInserterOccupation withTitle:currInserterOccupation];
    [self.popoverController dismissPopoverAnimated:YES];
    
}


#pragma mark - Insertion reason methods

- (IBAction)btnInsertionReasonTouchUp:(id)sender 
{
    [self resignAllFirstResponders];

    
    InsertionReasonVC *insertionReasonVC = [[InsertionReasonVC alloc] initWithNibName:@"InsertionReasonVC" bundle:[NSBundle mainBundle]];
    [insertionReasonVC setContentSizeForViewInPopover:CGSizeMake(452,216)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:insertionReasonVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnInsertionReason frame] 
                                       fromView:[btnInsertionReason superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}


- (void)setInsertionReason:(NSString *)currInsertionReason enableFollowUp:(BOOL)shouldEnable;
{
    
    insertionReason = currInsertionReason;
    [self answeredButton:btnInsertionReason withTitle:currInsertionReason];
    [self.popoverController dismissPopoverAnimated:YES];
    
    if (shouldEnable == YES) {
        [self enableGuidewireQuestion];
    } else {
        [self disableGuidewireQuestion];
    }
    
}


#pragma mark - Guidewire methods
-(void)enableGuidewireQuestion
{
    [self.imageViewBackground setImage:[UIImage imageNamed:@"Page1_background_skip_enabled.png"]];
    [btnYesLineExchangeViaGuidewire setHidden:NO];
    [btnNoLineExchangeViaGuidewire setHidden:NO];
    
}

-(void)disableGuidewireQuestion
{
    [self.imageViewBackground setImage:[UIImage imageNamed:@"Page1_background_skip_gray.png"]];
    [btnYesLineExchangeViaGuidewire setHidden:YES];
    [btnNoLineExchangeViaGuidewire setHidden:YES];
    
}

-(void)selectYesLineExchangeViaGuidewireButton
{
    [btnYesLineExchangeViaGuidewire setImage:[UIImage imageNamed:@"yes_selected.png"] forState:UIControlStateSelected];
    [btnYesLineExchangeViaGuidewire setSelected:YES];
    [btnNoLineExchangeViaGuidewire setImage:[UIImage imageNamed:@"no_unselected.png"] forState:UIControlStateNormal];
    [btnNoLineExchangeViaGuidewire setSelected:NO];
    
}


-(void)selectNoLineExchangeViaGuidewireButton
{
    [btnNoLineExchangeViaGuidewire setImage:[UIImage imageNamed:@"no_selected.png"] forState:UIControlStateSelected];
    [btnNoLineExchangeViaGuidewire setSelected:YES];
    [btnYesLineExchangeViaGuidewire setImage:[UIImage imageNamed:@"yes_unselected.png"] forState:UIControlStateNormal];
    [btnYesLineExchangeViaGuidewire setSelected:NO];
    
}


-(void)initGuidewireButtons
{
    ClipDataObject *guidewireExchangeDO = [cdMgr getCdoForKey:CDOKEY_GUIDEWIRE_EXCHANGE];
    
    if ([guidewireExchangeDO isValueSet]) {
        if ([guidewireExchangeDO getCdpBool]) {
            [self selectYesLineExchangeViaGuidewireButton];
        } else {
            [self selectNoLineExchangeViaGuidewireButton];
            
        }
    }
    
}

-(BOOL)shouldGuidewireQuestionBeEnabled
{
    ClipDataProperty *cdp = [[cdMgr getCdoForKey:CDOKEY_INSERTION_REASON] getCdpWithLabel:CDP_SUSPECTED_LINE_INFECTION];
    
    return [cdp isCdpChecked]; 
    
}

-(void)initGuidewireQuestion
{
    
    if ([self shouldGuidewireQuestionBeEnabled]) {
        [self enableGuidewireQuestion];
        [self initGuidewireButtons];
    } else 
        [self disableGuidewireQuestion];
}


- (IBAction)btnYesLineExchangeViaGuidewireTouchUp:(id)sender {
    
    [self resignAllFirstResponders];

    ClipDataObject *guidewireDO = [cdMgr getCdoForKey:CDOKEY_GUIDEWIRE_EXCHANGE];
    [guidewireDO setCdpBool:YES];
    [self selectYesLineExchangeViaGuidewireButton];

}


- (IBAction)btnNoLineExchangeViaGuidewireTouchUp:(id)sender {
    
    [self resignAllFirstResponders];

    ClipDataObject *guidewireDO = [cdMgr getCdoForKey:CDOKEY_GUIDEWIRE_EXCHANGE];
    [guidewireDO setCdpBool:NO];
    [self selectNoLineExchangeViaGuidewireButton];
    
    
}

-(BOOL)isDataOnPageValid {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL reqFieldCheck = [defaults boolForKey:@"req_field_check"];
    
    if(reqFieldCheck == NO)
        return YES;
    
    if (![cdMgr isCdoValidForKey:CDOKEY_FACILITY_ID]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_INSERTION_DATE]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_LOCATION]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_PAT_ID]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_GENDER]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_BIRTHDATE]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_PERSON_RECORDING]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_INSERTER_OCCUPATION]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_PICC_TEAM_MEMBER]) 
        return NO; 
    if (![cdMgr isCdoValidForKey:CDOKEY_INSERTION_REASON]) 
        return NO; 
    if ([self shouldGuidewireQuestionBeEnabled]) {
        if (![cdMgr isCdoValidForKey:CDOKEY_GUIDEWIRE_EXCHANGE]) 
            return NO; 
    }
    
    return YES;

}


- (IBAction)btnNextPageTouchUp:(id)sender {
    
    [self resignAllFirstResponders];
    
    if ([self isDataOnPageValid]) {
    
        ViewController2 *newVC2 = [[ViewController2 alloc] initWithNibName:@"ViewController2" bundle:[NSBundle mainBundle]];
        // Navigation logic may go here. Create and push another view controller.
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.vc2 = newVC2;
        [appDelegate.transitionController transitionToViewController:newVC2 withOptions:UIViewAnimationOptionTransitionCurlUp];
    } else {
        [self presentInvalidDataAlert];

    }

}

@end
