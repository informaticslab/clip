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

#import "ClipDataManager.h"


@implementation ClipDataManager

-(id)init
{
    
    if (self = [super init]) {
        clipObjects = [[NSMutableDictionary alloc] init];
        [self addAllObjects];
    }
    
    return self;
}

// creates ClipDataObject and adds it to the collection using the key
-(ClipDataObject *)addNewCdoWithKey:(NSString *)newKey ofType:(NSUInteger)newType
{
    
    ClipDataObject *cdo;
    
    // create object and add it to collection
    cdo = [[ClipDataObject alloc] initWithKey:newKey cdoType:newType];
    [clipObjects setObject:cdo forKey:newKey];
    
    return cdo;
    
}

-(void)addSingleTextValue:(NSString *)newTextValue toCdo:(ClipDataObject *)aCdo
{
    


}

-(void)addAllObjects
{
    ClipDataObject *cdo;
    
    // add objects that are defined in settings
    [self addNewCdoWithKey:CDOKEY_FACILITY_ID ofType:CDO_TEXTBOX_VALUE];
    [self addNewCdoWithKey:CDOKEY_PAT_ID ofType:CDO_TEXTBOX_VALUE];
    [self addNewCdoWithKey:CDOKEY_PAT_LAST_NAME ofType:CDO_TEXTBOX_VALUE];
    [self addNewCdoWithKey:CDOKEY_PAT_FIRST_NAME ofType:CDO_TEXTBOX_VALUE];
    [self addNewCdoWithKey:CDOKEY_PAT_MIDDLE_NAME ofType:CDO_TEXTBOX_VALUE];
    cdo = [self addNewCdoWithKey:CDOKEY_GENDER ofType:CDO_TABLE_SINGLE_VALUE];
    [cdo addTableCdp:CDP_MALE];
    [cdo addTableCdp:CDP_FEMALE];
    [cdo addTableCdp:CDP_OTHER];
    [self addNewCdoWithKey:CDOKEY_BIRTHDATE ofType:CDO_DATE_VALUE];
    [self addNewCdoWithKey:CDOKEY_LOCATION ofType:CDO_INDEXED_TABLE_SINGLE_VALUE];
    [self addNewCdoWithKey:CDOKEY_INSERTION_DATE ofType:CDO_DATE_VALUE];
    cdo = [self addNewCdoWithKey:CDOKEY_PERSON_RECORDING ofType:CDO_TABLE_SINGLE_VALUE];
    [cdo addTableCdp:CDP_INSERTER];
    [cdo addTableCdp:CDP_OBSERVER];
    cdo = [self addNewCdoWithKey:CDOKEY_INSERTER_OCCUPATION ofType:CDO_TABLE_SINGLE_VALUE];
    [cdo addTableCdp:CDP_FELLOW];
    [cdo addTableCdp:CDP_IV_TEAM];
    [cdo addTableCdp:CDP_MEDICAL_STUDENT];
    [cdo addTableCdp:CDP_OTHER_MEDICAL_STAFF];
    [cdo addTableCdp:CDP_PHYSICIAN_ASSISTANT];
    [cdo addTableCdp:CDP_ATTENDING_PHYSICIAN];
    [cdo addTableCdp:CDP_INTERN_RESIDENT];
    [cdo addTableCdp:CDP_OTHER_STUDENT];
    [self addNewCdoWithKey:CDOKEY_PICC_TEAM_MEMBER ofType:CDO_BOOLEAN_VALUE];
    cdo = [self addNewCdoWithKey:CDOKEY_INSERTION_REASON ofType:CDO_TABLE_SINGLE_VALUE];
    [cdo addTableCdp:CDP_NEW_INDICATION_FOR_LINE];
    [cdo addTableCdp:CDP_REPLACE_MALFUNCTION_LINE];
    [cdo addTableCdp:CDP_SUSPECTED_LINE_INFECTION];
    [cdo addTableCdp:CDP_OTHER];
    [self addNewCdoWithKey:CDOKEY_GUIDEWIRE_EXCHANGE ofType:CDO_BOOLEAN_VALUE];
    [self addNewCdoWithKey:CDOKEY_HAND_HYGIENE ofType:CDO_BOOLEAN_VALUE];
    cdo = [self addNewCdoWithKey:CDOKEY_MAXIMAL_BARRIERS ofType:CDO_TABLE_MULTIPLE_VALUE];
    [cdo addTableCdp:CDP_STERILE_MASK];
    [cdo addTableCdp:CDP_STERILE_DRAPE];
    [cdo addTableCdp:CDP_STERILE_GOWN];
    [cdo addTableCdp:CDP_STERILE_GLOVES];
    [cdo addTableCdp:CDP_STERILE_CAP];
    cdo = [self addNewCdoWithKey:CDOKEY_SKIN_PREP ofType:CDO_TABLE_MULTIPLE_VALUE];
    [cdo addTableCdp:CDP_CHLORHEX_GLUCO];
    [cdo addTableCdp:CDP_POVIDONE_IODINE];
    [cdo addTableCdp:CDP_ALCOHOL];
    [cdo addTableCdp:CDP_OTHER];
    [self addNewCdoWithKey:CDOKEY_CHLORHEXIDINE ofType:CDO_BOOLEAN_VALUE];
    [self addNewCdoWithKey:CDOKEY_SKIN_DRY ofType:CDO_BOOLEAN_VALUE];
    cdo = [self addNewCdoWithKey:CDOKEY_INSERTION_SITE ofType:CDO_TABLE_SINGLE_VALUE];
    [cdo addTableCdp:CDP_FEMORAL];
    [cdo addTableCdp:CDP_JUGULAR ];
    [cdo addTableCdp:CDP_LOWER_EXTREMITY ];
    [cdo addTableCdp:CDP_SCALP ];
    [cdo addTableCdp:CDP_SUBCLAVIAN ];
    [cdo addTableCdp:CDP_UMBILICAL ];
    [cdo addTableCdp:CDP_UPPER_EXTREMITY ];
    cdo = [self addNewCdoWithKey:CDOKEY_CATHETER_TYPE ofType:CDO_TABLE_SINGLE_VALUE];
    [cdo addTableCdp:CDP_DIALYSIS_NON_TUNNELED];
    [cdo addTableCdp:CDP_DIALYSIS_TUNNELED];
    [cdo addTableCdp:CDP_NON_TUNNELED];
    [cdo addTableCdp:CDP_TUNNELED];
    [cdo addTableCdp:CDP_PICC];
    [cdo addTableCdp:CDP_UMBILICAL];
    [cdo addTableCdp:CDP_OTHER];
    [self addNewCdoWithKey:CDOKEY_LINE_SUCCESSFUL ofType:CDO_BOOLEAN_VALUE];


}

-(ClipDataObject *)getCdoForKey:(NSString *)cdoKey
{
    ClipDataObject *wantedCdo = [clipObjects objectForKey:cdoKey];
    return wantedCdo;
    
}

-(NSString *)getTextValueForCdoKey:(NSString *)cdoKey
{
    
    ClipDataObject *cdo = [self getCdoForKey:cdoKey];
    return cdo.cdp.textValue;

}

-(BOOL)isCdoValidForKey:(NSString *)cdoKey
{
    ClipDataObject *cdo = [clipObjects objectForKey:cdoKey];
    
    return cdo.valueSet;
    
}

-(void)resetAll
{
    ClipDataObject *iCdo = nil;
    
    for (id key in [clipObjects allKeys]) {
        iCdo = [clipObjects objectForKey:key];
        [iCdo resetObject];
    }
    
}

-(void)addProperty:(NSString *)newProp toObject:(NSString *)cdoKey withIndex:(NSInteger)cdpKey
{
    ClipDataObject *cdo = [self getCdoForKey:cdoKey];
    
    [cdo addTableCdp:cdpKey cdpLabel:newProp];
    
}

-(void)removePropertiesForCdoKey:(NSString *)cdoKey
{
    ClipDataObject *cdo = [self getCdoForKey:cdoKey];
    
    [cdo removeTableCdps];
    [cdo resetObject];
    
}


@end
