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

#import "ClipDataObject.h"
#import "Debug.h"

@implementation ClipDataObject

@synthesize cdp, cdps, valueSet;


-(id)initWithKey:(NSString *)newKey cdoType:(NSUInteger)newType
{
    
    if (self = [super init]) {
        key = newKey;
        type = newType;
        valueSet = NO;
        
        if ((newType == CDO_TABLE_MULTIPLE_VALUE) || (newType == CDO_TABLE_SINGLE_VALUE)
            || (newType == CDO_INDEXED_TABLE_SINGLE_VALUE)) {
            cdps = [[NSMutableDictionary alloc] init];
        } else {
            cdp = [[ClipDataProperty alloc] init];
        }
    }
    
    return self;
}


-(void)addTableCdp:(NSString *)cdpLabel
{
    ClipDataProperty *newCdp = [[ClipDataProperty alloc] init];
    
    newCdp.label = cdpLabel;
    
    [cdps setObject:newCdp forKey:cdpLabel];
    
    DebugLog("Added CDP with label %@ to CDO %@", cdpLabel, key);
}

-(void)addTableCdp:(NSInteger)cdpIndex cdpLabel:(NSString *)newLabel
{
    ClipDataProperty *newCdp = [[ClipDataProperty alloc] init];
    
    newCdp.label = newLabel;
    NSNumber *newCdpIndex = [[NSNumber alloc] initWithInteger:cdpIndex];
    
    [cdps setObject:newCdp forKey:newCdpIndex];
    
    DebugLog("Added CDP with label %@ to CDO %@ at index %@", newLabel, key, newCdpIndex);
}

-(void)removeTableCdps
{
    [cdps removeAllObjects];
    
    DebugLog("Removing all CDPs from CDO %@", key);
}

-(ClipDataProperty *)getTableCdpWithIndex:(NSUInteger)aIndex 
{
    ClipDataProperty *indexedCdp;
    
    NSNumber *cdpIndex = [[NSNumber alloc] initWithInteger:aIndex];
    
    indexedCdp = [cdps objectForKey:cdpIndex];
    
    DebugLog("Getting CDP with index %@", cdpIndex);
    
    return indexedCdp;
}

-(ClipDataProperty *)getCdpWithLabel:(NSString*)aLabel
{
    
    return [cdps objectForKey:aLabel];
    
}

-(NSString *)getCheckedLabel
{
    ClipDataProperty *currCdp = nil;
    
    if (type == CDO_INDEXED_TABLE_SINGLE_VALUE) {
        for (NSNumber *currKey in cdps) {
            currCdp = [cdps objectForKey:currKey];
            if ([currCdp isCdpChecked] == YES) {
                return currCdp.label;
            }
        }
        
        
    } else {
        for (NSString *currKey in cdps) {
            currCdp = [cdps valueForKey:currKey];
            if ([currCdp isCdpChecked] == YES) {
                return currCdp.label;
            }
        }
    }
    
    return nil;
    
}

-(BOOL)checkCdpInCollectionWithLabel:(NSString *)aLabel
{
    ClipDataProperty *checkCdp = [self getCdpWithLabel:aLabel];
    ClipDataProperty *currCdp;
    
    
    if (type == CDO_TABLE_SINGLE_VALUE) {
        
        checkCdp.isChecked = YES;

        // uncheck all others if necessary
        for (NSString *currKey in cdps) {
            currCdp = [cdps valueForKey:currKey];
            if (currCdp != checkCdp) {
                currCdp.isChecked = NO;
            }
        }
        
        valueSet = YES;

    } else {

        // uncheck if necessary
        if (checkCdp.isChecked == YES)
            checkCdp.isChecked = NO;
        else {
            checkCdp.isChecked = YES;
        }
        
        // see if anyone is checked before setting valueSet of CDO
        BOOL anyChecked = NO;
        for (NSString *currKey in cdps) {
            currCdp = [cdps valueForKey:currKey];
            if (currCdp.isChecked) {
                anyChecked = YES;
            }
        }
        
        valueSet = anyChecked;
    }
    
    return checkCdp.isChecked;
    

}

-(void)checkCdpInCollectionWithIndex:(NSUInteger)anIndex
{
    ClipDataProperty *checkCdp = [self getTableCdpWithIndex:anIndex];
    ClipDataProperty *currCdp;
    
    checkCdp.isChecked = YES;
    
    // uncheck all others if necessary
    if (type == CDO_INDEXED_TABLE_SINGLE_VALUE) {
        
        for (NSNumber *currKey in cdps) {
            currCdp = [cdps objectForKey:currKey];
            if (currCdp != checkCdp) {
                currCdp.isChecked = NO;
            }
        }
        
    }
    
    valueSet = YES;
    
}

-(void)setDateValue:(NSDate *)aDate
{
    cdp.dateValue = aDate;
    valueSet = TRUE;
}

-(NSString *)getDateString
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:cdp.dateValue];
    return dateString;
    
}

-(NSString *)getUrlDateString
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:cdp.dateValue];
    return dateString;
    
}


// return single text value for objects of that type
-(NSString *)getTextValue
{
    return cdp.textValue;
}

// return single text value for objects of that type
-(void)setTextValue:(NSString *)aTextValue
{
    cdp.textValue = aTextValue;
    if ((aTextValue != nil) &&(![aTextValue isEqualToString:@""])) {
        valueSet = YES;
    } else {
        valueSet = NO;
    }
}

-(void)setCdpBool:(BOOL)aBool
{
    cdp.isChecked = aBool;
    valueSet = YES;
}

-(BOOL)getCdpBool
{
    return cdp.isChecked;
}

-(BOOL)isValueSet
{
    return valueSet;
}

- (NSString *)createStringFromMultipleCheckedValues
{
    
    // if no choices select return empty string    
    if (cdps == nil)
        return @"";
    
    
    NSString *choiceString = @"";
    NSUInteger checkedValueCnt = 0;
    NSUInteger maxChoices = 3;
    NSUInteger currChoice = 0;
    
    // set string to show first few choices,
    // all of them may not fit
    
    NSString *currKey;
    ClipDataProperty *currCdp = nil;
    for (currKey in cdps) {
        
        
        currCdp = [cdps objectForKey:currKey];
        
        if (currCdp.isChecked) {
            
            checkedValueCnt += 1;
            
            if (currChoice < maxChoices) {
                
                if (currChoice != 0)
                    choiceString = [choiceString stringByAppendingString:@", "];
                
                choiceString = [choiceString stringByAppendingString:currCdp.label];
                
                currChoice += 1;
                
            }            
            
        }
        
    }
    
    // if there is more choices that will not be displayed add ",..."
    if (currChoice < checkedValueCnt)
        choiceString = [choiceString stringByAppendingString:@", ..."];
    
    return choiceString;
    
}

-(void)resetObject
{
    ClipDataProperty *currCdp = nil;
    
    // clear text value
    if (type == CDO_TEXTBOX_VALUE)
        cdp.textValue = @"";
    
    else if ((type == CDO_TABLE_SINGLE_VALUE) || (type == CDO_TABLE_MULTIPLE_VALUE) ||
             (type == CDO_INDEXED_TABLE_SINGLE_VALUE)) {
        
        for (id iKey in [cdps allKeys]) {
            currCdp = [cdps objectForKey:iKey];
            currCdp.isChecked = NO;
        }
    }
    
    else if (type == CDO_BOOLEAN_VALUE) 
        cdp.isChecked = FALSE;
    
    
    else if (type == CDO_DATE_VALUE)
        cdp.dateValue = nil;
    
    self.valueSet = NO;
    
    
}

@end
