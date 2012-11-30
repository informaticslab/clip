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

#import "ClipWS.h"
#import "AppManager.h"
#import "LocationCodes.h"

@implementation ClipWS

@synthesize client, cdMgr;

-(id)init
{
    if (self = [super init]) {
        
        self.client = [RKClient clientWithBaseURL:[NSURL URLWithString:@"http://edemo.phiresearchlab.org"]];
        //self.client = [RKClient clientWithBaseURL:@"http://tappinapps.com"];
        // self.client = [RKClient clientWithBaseURL:@"http://localhost:8082"];
        self.client.timeoutInterval = 10.0;

    }
    
    return self;
}

-(id)initWithClipDataManager:(ClipDataManager *)aCdm
{
    
    self = [self init];
    self.cdMgr = aCdm;
    
    return self;
    
}


- (void)getCurrentFacilityLocations:(NSString *)currFacility forInsertionDate:(NSString *)insertionDate {
    
    // initialize UILabels
    NSString *facFilePath = [NSString stringWithFormat:@"%@%@%@%@", @"/clip/locationcodes?facility=", currFacility, @"&date=", insertionDate];
    
    // Perform a simple HTTP GET and call me back with the results
    [ [RKClient sharedClient] get:facFilePath delegate:self];
    
}

- (void)getDefaultFacilityLocations {

    // initialize UILabels
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultFacilityId = [defaults stringForKey:@"facility_preference"];
    NSString *facFilePath = [NSString stringWithFormat:@"%@%@%@", @"/clip/locationcodes/", defaultFacilityId, @".xml"];
    
    
    // Perform a simple HTTP GET and call me back with the results
    [ [RKClient sharedClient] get:facFilePath delegate:self];
    
}


- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gov.cdc.clipam.webservicetimeout" object:nil];
    
}
-(void)requestDidTimeout:(RKRequest *)request
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gov.cdc.clipam.webservicetimeout" object:nil];

}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  

    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            
            NSString *error;  
            NSPropertyListFormat format;  
            id plist;  
                        
            plist = [NSPropertyListSerialization propertyListFromData:response.body mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
            if (!plist) {  
                NSLog(@"Error reading plist = %s", [error UTF8String]);  

            }  else {
                NSLog(@"Success reading plist = %@, object type %@", [plist description], [plist class]);  
                LocationCodes *locationCodes = [[LocationCodes alloc] initWithObject:plist];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gov.cdc.clipam.facilityupdated" object:locationCodes];


            }
            
        } else {
            
            NSLog(@"CLIP Web Service Response Error");  
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gov.cdc.clipam.webservicetimeout" object:nil];


        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
        
    }
}


@end
