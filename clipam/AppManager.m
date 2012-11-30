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

#import "AppManager.h"


@implementation AppManager

//AppDelegate *appDelegate;


@synthesize appName, cdMgr, appDelegate, agreedWithEula;
static AppManager *sharedAppManager = nil;


#pragma mark Singleton Methods
+ (id)singletonAppManager {
	@synchronized(self) {
		if(sharedAppManager == nil)
			sharedAppManager = [[self alloc] init];
        
	}
	return sharedAppManager;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedAppManager == nil)  {
			sharedAppManager = [super allocWithZone:zone];
			return sharedAppManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)init {
	if ((self = [super init])) 
    {
		self.appName = @"CDC NHSN CLIP App";
        // Do any additional setup after loading the view, typically from a nib.
        self.appDelegate = [[UIApplication sharedApplication] delegate];
        
        //init reference to ClipDataManager
        self.cdMgr = appDelegate.cdMgr;
        agreedWithEula = FALSE;


	}
    
	return self;
}

@end
