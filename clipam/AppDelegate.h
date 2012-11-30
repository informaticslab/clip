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
#import "TransitionController.h"
#import "ClipDataManager.h"
#import "ClipWS.h"

@class ViewController;
@class ViewController2;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *vc1;
@property (strong, nonatomic) ViewController2 *vc2;
@property (strong, nonatomic) TransitionController *transitionController;
@property (strong, nonatomic) ClipDataManager *cdMgr;
@property (strong, nonatomic) ClipWS *clipWS;
@end
