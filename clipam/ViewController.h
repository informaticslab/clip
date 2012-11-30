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

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"


@interface ViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate, ModalViewDelegate>
{
    
    UIPopoverController *popoverController;
    NSString *patientId;
    NSString *patientGender;
    NSDate *patientBirthDate;
    NSString *location;
    NSDate *insertionDate;
    NSString *personRecording;
    NSString *inserterOccupation;
    NSString *insertionReason;
    BOOL hasLocationsInPlan;
    BOOL waitingForLocationCodes;

}

@property BOOL hasLocationsInPlan;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

@property (weak, nonatomic) IBOutlet UIButton *btnGender;
@property (weak, nonatomic) IBOutlet UITextField *txtPatientId;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtMiddleName;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilityId;
@property (weak, nonatomic) IBOutlet UIButton *btnDateOfBirth;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnDateOfInsertion;
@property (weak, nonatomic) IBOutlet UIButton *btnInserterRecordingData;
@property (weak, nonatomic) IBOutlet UIButton *btnObserverRecordingData;
@property (weak, nonatomic) IBOutlet UITextField *txtFacilityId;



@property (weak, nonatomic) IBOutlet UIButton *btnInserterOccupation;
@property (weak, nonatomic) IBOutlet UIButton *btnInsertionReason;
@property (weak, nonatomic) IBOutlet UIButton *btnNextPage;
@property (nonatomic, strong) UIPopoverController *popoverController; 
@property (weak, nonatomic) IBOutlet UIButton *btnYesPiccTeamMember;
@property (weak, nonatomic) IBOutlet UIButton *btnNoPiccTeamMember;
@property (weak, nonatomic) IBOutlet UIButton *btnYesLineExchangeViaGuidewire;
@property (weak, nonatomic) IBOutlet UIButton *btnNoLineExchangeViaGuidewire;

// actions
- (IBAction)txtPatientIdTouchUp:(id)sender;
- (IBAction)btnPatientGenderTouchUp:(id)sender;
- (IBAction)btnPatientBirthDateTouchUp:(id)sender;
- (IBAction)btnLocationTouchUpInside:(id)sender;
- (IBAction)btnInsertionDateTouchUp:(id)sender;
- (IBAction)btnPersonRecordingTouchUp:(id)sender;
- (IBAction)btnInserterOccupationTouchUp:(id)sender;
- (IBAction)btnInsertionReasonTouchUp:(id)sender;

- (IBAction)btnNextPageTouchUp:(id)sender;
- (IBAction)txtPatientIdEditEnd:(id)sender;
- (IBAction)txtPatientLastNameEditEnd:(id)sender;
- (IBAction)txtPatientFirstNameEditEnd:(id)sender;
- (IBAction)txtPatientMiddleNameEditEnd:(id)sender;
- (IBAction)txtLocationEditEnd:(id)sender;
- (IBAction)btnInserterRecordingDataTouchUp:(id)sender;
- (IBAction)btnObserverRecordingDataTouchUp:(id)sender;
- (IBAction)btnYesPiccTeamMemberTouchUp:(id)sender;
- (IBAction)btnNoPiccTeamMemberTouchUp:(id)sender;
- (IBAction)btnYesLineExchangeViaGuidewireTouchUp:(id)sender;
- (IBAction)btnNoLineExchangeViaGuidewireTouchUp:(id)sender;
- (IBAction)txtFacilityIdEditEnd:(id)sender;

- (IBAction)btnPatientLastNameEndOnExit:(id)sender;

// other methods
- (void)setPatientId:(NSString *)currPatientId;
- (void)setPatientGender:(NSString *)currPatientGender;
- (void)setPatientBirthDate:(NSString *)currPatientBirthDate;
- (void)setLocation:(NSString *)currLocation;
- (void)setInsertionDate:(NSString *)currInsertionDate;
- (void)setPersonRecording:(NSString *)currPersonRecording;
- (void)setInserterOccupation:(NSString *)currInserterOccupation;
- (void)setInsertionReason:(NSString *)currInsertionReason enableFollowUp:(BOOL)enable;
-(void)initPiccTeamMemberButtons;
-(void)selectNoPiccTeamMemberButton;
-(void)selectYesPiccTeamMemberButton;

-(void)initPersonRecordingDataButtons;
-(void)selectInserterRecordingDataButton;
-(void)selectObserverRecordingDataButton;
-(void)enableGuidewireQuestion;
-(void)initGuidewireQuestion;
-(void)facilityUpdated:(NSNotification *)notif; 

#define PATIENT_ID_INIT "Enter Patient ID"


@end
