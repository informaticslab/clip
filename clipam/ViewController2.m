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

#import "ViewController2.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "HandHygienePerformedVC.h"
#import "SterileBarriersUsedVC.h"
#import "SkinPrepUsed.h"
#import "InsertionSiteVC.h"
#import "CatheterTypeVC.h"
#import "Debug.h"

@implementation ViewController2
@synthesize btnSubmit;
@synthesize btnClearAll;
@synthesize btnPreviousPage, imageViewBackground;

AppDelegate *appDelegate;
ClipDataManager *cdMgr;
NSString *directAddress;

@synthesize btnYesHandHygienePerformed;
@synthesize btnNoHandHygienePerformed;
@synthesize btnSterileBarriersUsed;
@synthesize btnSkinPrepared;
@synthesize btnYesSkinDry;
@synthesize btnNoSkinDry;
@synthesize btnInsertionSite;
@synthesize btnCatheterType;
@synthesize btnYesSuccessfulLine, btnNoSuccessfulLine;
@synthesize btnNoChlorhexidineContraindication, btnYesChlorhexidineContraindication;

#define SUBMIT_ALERT_VIEW_TAG 1
#define CLEAR_ALERT_VIEW_TAG 2
#define INVALID_CREDENTIALS_ALERT_VIEW_TAG 3
#define SUBMISSION_COMPLETE_ALERT_VIEW_TAG 4

@synthesize popoverController;

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
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //init reference to ClipDataManager
    cdMgr = appDelegate.cdMgr;
    [self initHandHygienePerformedButtons];
    [self initSkinDryButtons];
    [self initSuccessfulLineButtons];
    [self initChlorhexidineContraindicationButtons];
    [self formatButton:btnSterileBarriersUsed withTitle:[[cdMgr getCdoForKey:CDOKEY_MAXIMAL_BARRIERS] createStringFromMultipleCheckedValues] ];
    [self formatButton:btnSkinPrepared withTitle:[[cdMgr getCdoForKey:CDOKEY_SKIN_PREP] createStringFromMultipleCheckedValues]];
    [self formatButton:self.btnInsertionSite withTitle:[[cdMgr getCdoForKey:CDOKEY_INSERTION_SITE] getCheckedLabel]];
    [self formatButton:self.btnCatheterType withTitle:[[cdMgr getCdoForKey:CDOKEY_CATHETER_TYPE] getCheckedLabel]];
    appDelegate.vc1 = nil;

    

}

- (void)viewDidUnload
{
    [self setBtnPreviousPage:nil];
    [self setBtnSubmit:nil];
    [self setBtnClearAll:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setBtnYesHandHygienePerformed:nil];
    [self setBtnNoHandHygienePerformed:nil];
    [self setBtnSterileBarriersUsed:nil];
    [self setBtnSkinPrepared:nil];
    [self setBtnYesSkinDry:nil];
    [self setBtnNoSkinDry:nil];
    [self setBtnInsertionSite:nil];
    [self setBtnCatheterType:nil];
    [self setBtnYesSuccessfulLine:nil];
    [self setBtnNoSuccessfulLine:nil];
    [self setBtnYesChlorhexidineContraindication:nil];
    [self setBtnNoChlorhexidineContraindication:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    // initialize UILabels
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    directAddress = [defaults stringForKey:@"direct_address"];

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    // only support portrait orientation and upside down
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;
    
    return NO;
}


-(void)answeredButton:(UIButton *)currButton withTitle:(NSString *)currTitle
{
    
    UIColor *initColor = [UIColor blackColor];
    
    [currButton setTitle:currTitle forState:UIControlStateNormal];
    [currButton setTitleColor:initColor forState:UIControlStateNormal];
    [currButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}

-(void)formatButton:(UIButton *)currButton withTitle:(NSString *)currTitle
{
    UIColor *initColor = [UIColor blackColor];
    
    [currButton setTitle:currTitle forState:UIControlStateNormal];
    [currButton setTitleColor:initColor forState:UIControlStateNormal];
    [currButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
}


#pragma mark Init CLIP widgets
-(void)initForm
{
    // initialize UIButtons
    
}

#pragma mark - Hand Hygiene methods
-(void)selectYesHandHygienePerformed
{
    [btnYesHandHygienePerformed setImage:[UIImage imageNamed:@"yes_selected.png"] forState:UIControlStateSelected];
    [btnYesHandHygienePerformed setSelected:YES];
    [btnNoHandHygienePerformed setImage:[UIImage imageNamed:@"no_unselected.png"] forState:UIControlStateNormal];
    [btnNoHandHygienePerformed setSelected:NO];
    
}

-(void)selectNoHandHygienePerformed
{
    [btnNoHandHygienePerformed setImage:[UIImage imageNamed:@"no_selected.png"] forState:UIControlStateSelected];
    [btnNoHandHygienePerformed setSelected:YES];
    [btnYesHandHygienePerformed setImage:[UIImage imageNamed:@"yes_unselected.png"] forState:UIControlStateNormal];
    [btnYesHandHygienePerformed setSelected:NO];
    
}

-(void)initHandHygienePerformedButtons
{
    ClipDataObject *handHygieneDO = [cdMgr getCdoForKey:CDOKEY_HAND_HYGIENE];
    
    if ([handHygieneDO isValueSet]) {
        if ([handHygieneDO getCdpBool]) {
            [self selectYesHandHygienePerformed];
        } else {
            [self selectNoHandHygienePerformed];
            
        }
    }
    
}

- (IBAction)btnYesHandHygienePerformedTouchUp:(id)sender {
    ClipDataObject *handHygieneDO = [cdMgr getCdoForKey:CDOKEY_HAND_HYGIENE];
    [handHygieneDO setCdpBool:YES];
    [self selectYesHandHygienePerformed];
}

- (IBAction)btnNoHandHygienePerformedTouchUp:(id)sender {
    ClipDataObject *handHygieneDO = [cdMgr getCdoForKey:CDOKEY_HAND_HYGIENE];
    [handHygieneDO setCdpBool:NO];
    [self selectNoHandHygienePerformed];
}


#pragma mark - Sterile Barriers methods

- (IBAction)btnSterileBarriersTouchUp:(id)sender 
{
    
    SterileBarriersUsedVC *sterileBarriersVC = [[SterileBarriersUsedVC alloc] initWithNibName:@"SterileBarriersUsedVC" bundle:[NSBundle mainBundle]];
    [sterileBarriersVC setContentSizeForViewInPopover:CGSizeMake(292,264)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:sterileBarriersVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnSterileBarriersUsed frame] 
                                       fromView:[btnSterileBarriersUsed superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}


- (void)setSterileBarriers:(NSString *)currSterileBarriersUsed
{
    
    sterileBarriersUsed = currSterileBarriersUsed;
    [self answeredButton:btnSterileBarriersUsed withTitle:currSterileBarriersUsed];
    [self.popoverController dismissPopoverAnimated:YES];
    
}

#pragma mark - Skin Dry methods
-(void)selectYesSkinDry
{
    [btnYesSkinDry setImage:[UIImage imageNamed:@"yes_selected.png"] forState:UIControlStateSelected];
    [btnYesSkinDry setSelected:YES];
    [btnNoSkinDry setImage:[UIImage imageNamed:@"no_unselected.png"] forState:UIControlStateNormal];
    [btnNoSkinDry setSelected:NO];
    
}

-(void)selectNoSkinDry
{
    [btnNoSkinDry setImage:[UIImage imageNamed:@"no_selected.png"] forState:UIControlStateSelected];
    [btnNoSkinDry setSelected:YES];
    [btnYesSkinDry setImage:[UIImage imageNamed:@"yes_unselected.png"] forState:UIControlStateNormal];
    [btnYesSkinDry setSelected:NO];
    
}

-(void)initSkinDryButtons
{
    ClipDataObject *skinDryDO = [cdMgr getCdoForKey:CDOKEY_SKIN_DRY];
    
    if ([skinDryDO isValueSet]) {
        if ([skinDryDO getCdpBool]) {
            [self selectYesSkinDry];
        } else {
            [self selectNoSkinDry];
            
        }
    }
    
}

- (IBAction)btnYesSkinDryTouchUp:(id)sender {
    ClipDataObject *skinDryDO = [cdMgr getCdoForKey:CDOKEY_SKIN_DRY];
    [skinDryDO setCdpBool:YES];
    [self selectYesSkinDry];
}

- (IBAction)btnNoSkinDryTouchUp:(id)sender {
    ClipDataObject *skinDryDO = [cdMgr getCdoForKey:CDOKEY_SKIN_DRY];
    [skinDryDO setCdpBool:NO];
    [self selectNoSkinDry];
}



#pragma mark - Skin Prep methods
- (IBAction)btnSkinPreparedTouchUp:(id)sender 
{
    
    SkinPrepUsed *skinPrepUsedVC = [[SkinPrepUsed alloc] initWithNibName:@"SkinPrepUsed" bundle:[NSBundle mainBundle]];
    [skinPrepUsedVC setContentSizeForViewInPopover:CGSizeMake(290,218)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:skinPrepUsedVC]; 
    
    [popover setDelegate:self];
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnSkinPrepared frame] 
                                       fromView:[btnSkinPrepared superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}

- (void)setSkinPreparation:(NSString *)currSkinPrepUsed enableFollowUp:(BOOL)followUpEnable
{
    
    skinPrepUsed = currSkinPrepUsed;
    [self answeredButton:btnSkinPrepared withTitle:currSkinPrepUsed];
    [self.popoverController dismissPopoverAnimated:YES];
    
    if (followUpEnable == YES) {
        [self enableChlorhexidineQuestion];
    } else {
        [self disableChlorhexidineQuestion];

    }
    
}


-(void)enableChlorhexidineQuestion
{
    [self.imageViewBackground setImage:[UIImage imageNamed:@"Page2_background_skip_enabled.png"]];
    [btnYesChlorhexidineContraindication setHidden:NO];
    [btnNoChlorhexidineContraindication setHidden:NO];
    
}

-(void)disableChlorhexidineQuestion
{
    [self.imageViewBackground setImage:[UIImage imageNamed:@"Page2_background_skip_gray.png"]];
    [btnYesChlorhexidineContraindication setHidden:YES];
    [btnNoChlorhexidineContraindication setHidden:YES];
    
}


#pragma mark - Skin Dry methods





#pragma mark - Insertion Site methods
- (IBAction)btnInsertionSiteTouchUp:(id)sender {
    
    InsertionSiteVC *insertionSiteVC = [[InsertionSiteVC alloc] initWithNibName:@"InsertionSiteVC" bundle:[NSBundle mainBundle]];
    [insertionSiteVC setContentSizeForViewInPopover:CGSizeMake(280,350)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:insertionSiteVC]; 
    
    [popover setDelegate:self];
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnInsertionSite frame] 
                                       fromView:[btnInsertionSite superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}


- (void)setInsertionSite:(NSString *)currInsertionSite;
{
    
    insertionSite = currInsertionSite;
    [self answeredButton:btnInsertionSite withTitle:currInsertionSite];
    [self.popoverController dismissPopoverAnimated:YES];
    
}

#pragma mark - Catheter Type methods
- (IBAction)btnCatheterTypeTouchUp:(id)sender {
    
    CatheterTypeVC *catheterTypeVC = [[CatheterTypeVC alloc] initWithNibName:@"CatheterTypeVC" bundle:[NSBundle mainBundle]];
    [catheterTypeVC setContentSizeForViewInPopover:CGSizeMake(300,350)];
    
    UIPopoverController *popover = 
    [[UIPopoverController alloc] initWithContentViewController:catheterTypeVC]; 
    
    popover.delegate = self;
    
    self.popoverController = popover;
    
    CGRect popoverRect = [self.view convertRect:[self.btnCatheterType frame] 
                                       fromView:[btnCatheterType superview]];
    
    [self.popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}

- (void)setCatheterType:(NSString *)currCatheterType
{
    catheterType = currCatheterType;
    [self answeredButton:btnCatheterType withTitle:currCatheterType];
    [self.popoverController dismissPopoverAnimated:YES];
    
}

-(void)presentInvalidDataAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Complete Required Fields"
                          message: @"The current page contains required fields that are incomplete. Please complete all required fields before submitting the data."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}




#pragma mark - Submit and Cancel methods

- (IBAction)btnSubmitTouchUp:(id)sender {
    
    if ([self isDataOnPageValid]) {

    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"CLIP Form Submission"
                          message: nil
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil];
    
    alert.tag = SUBMIT_ALERT_VIEW_TAG;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField *directAddressField = [alert textFieldAtIndex:0];
    [directAddressField setPlaceholder:@"Direct Address"];
    
    if (directAddress != nil && ![directAddress isEqualToString:@""])
        directAddressField.text = directAddress;
    

    [alert show];
        
    } else {
        [self presentInvalidDataAlert];
    }

}

- (IBAction)btnClearAllTouchUp:(id)sender {

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"CLIP Form Submission"
                          message: @"You are about to clear all the data entered into the CLIP Adherence Monitoring form. Would you like to continue?"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Yes",nil];
    alert.tag = CLEAR_ALERT_VIEW_TAG;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
}

#pragma mark - Alert View methods

-(void)presentInvalidCredentialsAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"CLIP Form Submission"
                          message: @"Your username or password was entered incorrectly."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Retry",nil];
    alert.tag = INVALID_CREDENTIALS_ALERT_VIEW_TAG;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];
    
}

-(void)presentSubmissionCompleteAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"CLIP Form Submission Complete."
                          message: @"Thank you for submitting your CLIP data to NHSN. You should receive an email very shortly confirming the receipt and processing status of your submission. For any issues please contact the NHSN help desk at nhsn@cdc.gov."
                          delegate: self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Continue",nil];
    alert.tag = SUBMISSION_COMPLETE_ALERT_VIEW_TAG;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert show];

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if(alertView.tag == SUBMIT_ALERT_VIEW_TAG) {
        if (buttonIndex == 0) {
            DebugLog(@"User hit Cancel on Submit Form Alert View.");
        }
        else {
            DebugLog(@"User hit Yes on Submit Form Alert View.");
            UITextField *userId = [alertView textFieldAtIndex:0];
            UITextField *password = [alertView textFieldAtIndex:1];
            
            NSLog(@"User ID: %@\nPassword: %@", userId.text, password.text);
            
            if ([password.text isEqualToString:@"clip"]) {
                
                [self presentSubmissionCompleteAlert];
                
            } else {
                [self presentInvalidCredentialsAlert];
            }
       }
    } else if (alertView.tag == CLEAR_ALERT_VIEW_TAG) {
        if (buttonIndex == 0) {
            DebugLog(@"User hit Cancel on Clear Form Alert View.");
        }
        else {
            DebugLog(@"User hit Yes on Clear Form Alert View.");
            [cdMgr resetAll];
            [self loadFirstPage];
        }
        
    } else if (alertView.tag == INVALID_CREDENTIALS_ALERT_VIEW_TAG ) {
        DebugLog(@"Invalid Alert View displayed.");
        

    } else if (alertView.tag == SUBMISSION_COMPLETE_ALERT_VIEW_TAG ) {
        [cdMgr resetAll];
        [self loadFirstPage];
        
    
    }
}

-(void)loadFirstPage
{
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    // Navigation logic may go here. Create and push another view controller.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.vc1 = vc;
    [appDelegate.transitionController transitionToViewController:vc withOptions:UIViewAnimationOptionTransitionCurlDown];

}

- (IBAction)btnPreviousPageTouchUp:(id)sender {
    
    [self loadFirstPage];

}

-(BOOL)shouldChlorhexidineContraindicationQuestionBeEnabled
{
    
    ClipDataObject *skinPrep = [cdMgr getCdoForKey:CDOKEY_SKIN_PREP];
    ClipDataProperty *chlorhexidineUsed = [skinPrep getCdpWithLabel:CDP_CHLORHEX_GLUCO];

    if (chlorhexidineUsed.isChecked == NO) 
        return YES;
    else 
        return NO;
    
}


#pragma mark - Chlorhexidine Contraindication methods
-(void)selectYesChlorhexidineContraindication
{
    [btnYesChlorhexidineContraindication setImage:[UIImage imageNamed:@"yes_selected.png"] forState:UIControlStateSelected];
    [btnYesChlorhexidineContraindication setSelected:YES];
    [btnNoChlorhexidineContraindication setImage:[UIImage imageNamed:@"no_unselected.png"] forState:UIControlStateNormal];
    [btnNoChlorhexidineContraindication setSelected:NO];
    
}

-(void)selectNoChlorhexidineContraindication
{
    [btnNoChlorhexidineContraindication setImage:[UIImage imageNamed:@"no_selected.png"] forState:UIControlStateSelected];
    [btnNoChlorhexidineContraindication setSelected:YES];
    [btnYesChlorhexidineContraindication setImage:[UIImage imageNamed:@"yes_unselected.png"] forState:UIControlStateNormal];
    [btnYesChlorhexidineContraindication setSelected:NO];
    
}

-(void)initChlorhexidineContraindicationButtons
{
    ClipDataObject *chlorhexidineDO = [cdMgr getCdoForKey:CDOKEY_CHLORHEXIDINE];

    if ([chlorhexidineDO isValueSet]) {
        if ([chlorhexidineDO getCdpBool]) {
            [self selectYesChlorhexidineContraindication];
        } else {
            [self selectNoChlorhexidineContraindication];
            
        }
    }
    if ([self shouldChlorhexidineContraindicationQuestionBeEnabled]) 
        [self enableChlorhexidineQuestion];
    else
        [self disableChlorhexidineQuestion];
    
    
}

- (IBAction)btnYesChlorhexidineContraindicationTouchUp:(id)sender {
    ClipDataObject *chlorhexidineDO = [cdMgr getCdoForKey:CDOKEY_CHLORHEXIDINE];
    [chlorhexidineDO setCdpBool:YES];
    [self selectYesChlorhexidineContraindication];
}

- (IBAction)btnNoChlorhexidineContraindicationTouchUp:(id)sender {
    ClipDataObject *chlorhexidineDO = [cdMgr getCdoForKey:CDOKEY_CHLORHEXIDINE];
    [chlorhexidineDO setCdpBool:NO];
    [self selectNoChlorhexidineContraindication];
}

#pragma mark - Line Successful methods
-(void)selectYesSuccessfulLine
{
    [btnYesSuccessfulLine setImage:[UIImage imageNamed:@"yes_selected.png"] forState:UIControlStateSelected];
    [btnYesSuccessfulLine setSelected:YES];
    [btnNoSuccessfulLine setImage:[UIImage imageNamed:@"no_unselected.png"] forState:UIControlStateNormal];
    [btnNoSuccessfulLine setSelected:NO];
    
}

-(void)selectNoSuccessfulLine
{
    [btnNoSuccessfulLine setImage:[UIImage imageNamed:@"no_selected.png"] forState:UIControlStateSelected];
    [btnNoSuccessfulLine setSelected:YES];
    [btnYesSuccessfulLine setImage:[UIImage imageNamed:@"yes_unselected.png"] forState:UIControlStateNormal];
    [btnYesSuccessfulLine setSelected:NO];
    
}

-(void)initSuccessfulLineButtons
{
    ClipDataObject *successfulLineDO = [cdMgr getCdoForKey:CDOKEY_LINE_SUCCESSFUL];
    
    if ([successfulLineDO isValueSet]) {
        if ([successfulLineDO getCdpBool]) {
            [self selectYesSuccessfulLine];
        } else {
            [self selectNoSuccessfulLine];
            
        }
    }
}

- (IBAction)btnYesSuccessfulLineTouchUp:(id)sender {
    ClipDataObject *successfulLineDO = [cdMgr getCdoForKey:CDOKEY_LINE_SUCCESSFUL];
    [successfulLineDO setCdpBool:YES];
    [self selectYesSuccessfulLine];
}

- (IBAction)btnNoSuccessfulLineTouchUp:(id)sender {
    ClipDataObject *successfulLineDO = [cdMgr getCdoForKey:CDOKEY_LINE_SUCCESSFUL];
    [successfulLineDO setCdpBool:NO];
    [self selectNoSuccessfulLine];
}



- (NSString *)createStringFromMultipleChoice:(NSArray *)choices
{
    // if no choices select return empty string    
    if (choices == nil)
        return @"";
    
    NSString *choiceString = @"";
    NSUInteger choiceCount = [choices count];
    NSUInteger maxChoices = 3;
    NSUInteger currChoice = 0;
    
    // set string to show first few choices,
    // all of them may not fit
    while ((currChoice < maxChoices) && (currChoice < choiceCount)) {
        
        if (currChoice != 0)
            choiceString = [choiceString stringByAppendingString:@", "];
        
        choiceString = [choiceString stringByAppendingString:(NSString *)[choices objectAtIndex:currChoice]];
        
        currChoice += 1;
        
    }
    
    // if there is more choices that will not be displayed add ",..."
    if (currChoice < choiceCount)
        choiceString = [choiceString stringByAppendingString:@", ..."];
    
    return choiceString;
    
}

-(BOOL)isDataOnPageValid {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL reqFieldCheck = [defaults boolForKey:@"req_field_check"];
    
    if(reqFieldCheck == NO)
        return YES;
    
    if (![cdMgr isCdoValidForKey:CDOKEY_HAND_HYGIENE]) 
        return FALSE; 
    if (![cdMgr isCdoValidForKey:CDOKEY_MAXIMAL_BARRIERS]) 
        return FALSE; 
    if (![cdMgr isCdoValidForKey:CDOKEY_SKIN_PREP]) 
        return FALSE; 
    if ([self shouldChlorhexidineContraindicationQuestionBeEnabled]) {
        if (![cdMgr isCdoValidForKey:CDOKEY_CHLORHEXIDINE]) 
            return FALSE; 
    }
    if (![cdMgr isCdoValidForKey:CDOKEY_SKIN_DRY]) 
        return FALSE; 
    if (![cdMgr isCdoValidForKey:CDOKEY_INSERTION_SITE]) 
        return FALSE; 
    if (![cdMgr isCdoValidForKey:CDOKEY_CATHETER_TYPE]) 
        return FALSE; 
    if (![cdMgr isCdoValidForKey:CDOKEY_LINE_SUCCESSFUL]) 
        return FALSE; 
    
    return TRUE;
    
}



@end
