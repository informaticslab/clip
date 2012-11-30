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

@interface EulaViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *webView;
    __unsafe_unretained id<ModalViewDelegate>  delegate;

}

//@property(assign) id<ModalViewDelegate> delegate;
@property(nonatomic, assign) id<ModalViewDelegate> delegate;
@property(strong, retain) UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnAgree;

- (IBAction)btnDeclineTouchUp:(id)sender;
- (IBAction)btnAcceptTouchUp:(id)sender;

@end