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



#import "Debug.h"
#import "AppDelegate.h"
#import "ClipDataManager.h"


@interface AppManager : NSObject {
	
    NSString *appName;
    ClipDataManager *cdMgr;
    AppDelegate *appDelegate;
    
    BOOL agreedWithEula;

    

}

@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) ClipDataManager *cdMgr;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property BOOL agreedWithEula;

+ (id)singletonAppManager;

@end
