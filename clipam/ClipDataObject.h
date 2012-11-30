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

#import <Foundation/Foundation.h>
#import "ClipDataProperty.h"

// object types
#define CDO_TEXTBOX_VALUE 1
#define CDO_TABLE_SINGLE_VALUE 2
#define CDO_TABLE_MULTIPLE_VALUE 3
#define CDO_DATE_VALUE 4
#define CDO_BOOLEAN_VALUE 5
#define CDO_INDEXED_TABLE_SINGLE_VALUE 6


#define CDOKEY_UNDEFINED @"UNDEFINED"
#define CDOKEY_FACILITY_ID @"CDOKEY_FACILITY_ID"
#define CDOKEY_EVENT_ID @"CDOKEY_EVENT_ID"
#define CDOKEY_PAT_ID @"CDOKEY_PAT_ID"
#define CDOKEY_PAT_LAST_NAME @"CDOKEY_PAT_LAST_NAME"
#define CDOKEY_PAT_FIRST_NAME @"CDOKEY_PAT_FIRST_NAME"
#define CDOKEY_PAT_MIDDLE_NAME @"CDOKEY_PAT_MIDDLE_NAME"
#define CDOKEY_GENDER @"CDOKEY_GENDER"
#define CDOKEY_BIRTHDATE @"CDOKEY_BIRTHDATE"
#define CDOKEY_LOCATION @"CDOKEY_LOCATION"
#define CDOKEY_INSERTION_DATE @"CDOKEY_INSERTION_DATE"
#define CDOKEY_PERSON_RECORDING @"CDOKEY_PERSON_RECORDING"
#define CDOKEY_INSERTER_OCCUPATION @"CDOKEY_INSERTER_OCCUPATION"
#define CDOKEY_PICC_TEAM_MEMBER @"CDOKEY_PICC_TEAM_MEMBER"
#define CDOKEY_INSERTION_REASON @"CDOKEY_INSERTION_REASON"
#define CDOKEY_GUIDEWIRE_EXCHANGE @"CDOKEY_GUIDEWIRE_EXCHANGE"
#define CDOKEY_HAND_HYGIENE @"CDOKEY_HAND_HYGIENE"
#define CDOKEY_MAXIMAL_BARRIERS @"CDOKEY_MAXIMAL_BARRIERS"
#define CDOKEY_SKIN_PREP @"CDOKEY_SKIN_PREP"
#define CDOKEY_CHLORHEXIDINE @"CDOKEY_CHLORHEXIDINE"
#define CDOKEY_SKIN_DRY @"CDOKEY_SKIN_DRY"
#define CDOKEY_INSERTION_SITE @"CDOKEY_INSERTION_SITE"
#define CDOKEY_CATHETER_TYPE @"CDOKEY_CATHETER_TYPE"
#define CDOKEY_LINE_SUCCESSFUL @"CDOKEY_LINE_SUCCESSFUL"

#define CDOVAL_PATIENT_ID_LABEL @"Patient ID"
#define CDOVAL_PATIENT_LAST_NAME_LABEL @"Patient Last Name"
#define CDOVAL_PATIENT_FIRST_NAME_LABEL @"Patient First Name"
#define CDOVAL_PATIENT_MIDDLE_NAME_LABEL @"Patient Middle Name"
#define CDOVAL_LOCATION_LABEL @"Location"


#define CDP_YES @"Yes"
#define CDP_NO @"No"
#define CDP_FEMALE @"Female"
#define CDP_MALE @"Male"
#define CDP_INSERTER @"Inserter"
#define CDP_OBSERVER @"Observer"
#define CDP_FELLOW @"Fellow"
#define CDP_IV_TEAM @"IV Team"
#define CDP_MEDICAL_STUDENT @"Medical Student"
#define CDP_OTHER_MEDICAL_STAFF @"Other Medical Staff"
#define CDP_PHYSICIAN_ASSISTANT @"Physician Assistant"
#define CDP_ATTENDING_PHYSICIAN @"Attending Physician"
#define CDP_INTERN_RESIDENT @"Intern/Resident"
#define CDP_OTHER_STUDENT @"Other Student"
#define CDP_PICC_TEAM @"PICC Team"
#define CDP_NEW_INDICATION_FOR_LINE @"New indication for central line"
#define CDP_REPLACE_MALFUNCTION_LINE @"Replace malfunctioning central line"
#define CDP_SUSPECTED_LINE_INFECTION @"Suspected central line-associated infection"
#define CDP_OTHER @"Other"

#define CDP_STERILE_MASK @"Mask"
#define CDP_STERILE_DRAPE @"Large sterile drape"
#define CDP_STERILE_GOWN @"Sterile gown"
#define CDP_STERILE_GLOVES @"Sterile gloves"
#define CDP_STERILE_CAP @"Cap"

#define CDP_CHLORHEX_GLUCO @"Chlorhexidine gluconate"
#define CDP_POVIDONE_IODINE @"Povidone iodine"
#define CDP_ALCOHOL @"Alcohol"

#define CDP_FEMORAL @"Femoral"
#define CDP_JUGULAR @"Jugular"
#define CDP_LOWER_EXTREMITY @"Lower Extremity"
#define CDP_SCALP @"Scalp"
#define CDP_SUBCLAVIAN @"Subclavian"
#define CDP_UMBILICAL @"Umbilical"
#define CDP_UPPER_EXTREMITY @"Upper Extremity"

#define CDP_DIALYSIS_NON_TUNNELED @"Dialysis non-tunneled"
#define CDP_DIALYSIS_TUNNELED @"Dialysis tunneled"
#define CDP_NON_TUNNELED @"Non-tunneled"
#define CDP_TUNNELED @"Tunneled"
#define CDP_PICC @"PICC"
#define CDP_UMBILICAL @"Umbilical"

@interface ClipDataObject : NSObject
{
    NSString *key;
    NSUInteger  type;
    NSMutableDictionary *cdps;
    ClipDataProperty *cdp;
    BOOL valueSet;
    BOOL required;
}


-(id)initWithKey:(NSString *)newKey cdoType:(NSUInteger)newType;

@property(strong, atomic) ClipDataProperty *cdp;
@property(strong, atomic) NSMutableDictionary *cdps;

@property BOOL valueSet;

-(void)addTableCdp:(NSString *)cdpLabel;
-(void)addTableCdp:(NSInteger)cdpIndex cdpLabel:(NSString *)newLabel;
-(void)removeTableCdps;

-(ClipDataProperty *)getCdpWithLabel:(NSString*)aLabel;
-(ClipDataProperty *)getTableCdpWithIndex:(NSUInteger)aIndex;
-(NSString *)getCheckedLabel;
-(NSString *)getDateString;
-(NSString *)getUrlDateString;
-(void)setDateValue:(NSDate *)aDate;
-(void)setCdpBool:(BOOL)aBool;
-(BOOL)getCdpBool;
-(NSString *)getTextValue;
-(void)setTextValue:(NSString *)aTextValue;
-(BOOL)isValueSet;
-(BOOL)checkCdpInCollectionWithLabel:(NSString *)aLabel;
-(void)checkCdpInCollectionWithIndex:(NSUInteger)anIndex;

- (NSString *)createStringFromMultipleCheckedValues;
-(void)resetObject;


@end
