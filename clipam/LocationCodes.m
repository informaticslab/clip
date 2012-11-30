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

#import "LocationCodes.h"
#import "AppDelegate.h"
#import "ClipDataManager.h"

@implementation LocationCodes

@synthesize facilityId, statusCode, statusString;
@synthesize localCode, standardCode;


-(id)initWithObject:(id)plist 
{
   
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //init reference to ClipDataManager
    ClipDataManager *cdMgr = appDelegate.cdMgr;

    NSArray *locationCodes = plist;
        
    // get status string and code
    NSDictionary *status = [locationCodes objectAtIndex:0];
    self.statusCode = [status objectForKey:@"status_code"];
    self.statusString = [status objectForKey:@"status_string"];
    NSLog(@"Status code = %@", self.statusCode);
    NSLog(@"Status string = %@", self.statusString);
    
    if ([self.statusCode isEqualToString:@"0"]) {
        // get all of the location local codes and standard codes
        NSInteger index = 0;
        for (NSDictionary *currCode in (NSDictionary *)(locationCodes)) {
            
            if((self.localCode = [currCode objectForKey:@"local_code"]) != nil) {
                [cdMgr addProperty:localCode toObject:CDOKEY_LOCATION withIndex:index++];
                NSLog(@"Local code = %@", localCode);
                self.standardCode = [currCode objectForKey:@"standard_code"];
                NSLog(@"Standard code = %@", self.standardCode);
            }
        }
    }

    return self;
}

-(BOOL)isValidFacility
{
    if ([statusCode isEqualToString:@"1"]) {
        return NO;
    }
         
    return YES;

}

-(BOOL)isFacilityInPlan
{
    if ([statusCode isEqualToString:@"2"]) {
        return NO;
    }
    
    return YES;
    
}

@end
