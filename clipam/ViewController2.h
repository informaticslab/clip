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

@interface ViewController2 : UIViewController <UIPopoverControllerDelegate> {
    
    UIPopoverController *popoverController;
    BOOL handHygienePerformed;
    NSString *sterileBarriersUsed;
    NSString *skinPrepUsed;
    BOOL skinDry;
    NSString *insertionSite;
    NSString *catheterType;

}
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousPage;
@property (weak, nonatomic) IBOutlet UIButton *btnYesHandHygienePerformed;
@property (weak, nonatomic) IBOutlet UIButton *btnNoHandHygienePerformed;
@property (weak, nonatomic) IBOutlet UIButton *btnSterileBarriersUsed;
@property (weak, nonatomic) IBOutlet UIButton *btnSkinPrepared;
@property (weak, nonatomic) IBOutlet UIButton *btnYesSkinDry;
@property (weak, nonatomic) IBOutlet UIButton *btnNoSkinDry;
@property (weak, nonatomic) IBOutlet UIButton *btnInsertionSite;
@property (weak, nonatomic) IBOutlet UIButton *btnCatheterType;
@property (weak, nonatomic) IBOutlet UIButton *btnYesSuccessfulLine;
@property (weak, nonatomic) IBOutlet UIButton *btnNoSuccessfulLine;
@property (weak, nonatomic) IBOutlet UIButton *btnYesChlorhexidineContraindication;
@property (weak, nonatomic) IBOutlet UIButton *btnNoChlorhexidineContraindication;
@property (strong, nonatomic) UIPopoverController *popoverController; 
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnClearAll;

- (IBAction)btnPreviousPageTouchUp:(id)sender;
- (IBAction)btnYesHandHygienePerformedTouchUp:(id)sender;
- (IBAction)btnNoHandHygienePerformedTouchUp:(id)sender;
- (IBAction)btnYesChlorhexidineContraindicationTouchUp:(id)sender;
- (IBAction)btnNoChlorhexidineContraindicationTouchUp:(id)sender;
- (IBAction)btnYesSkinDryTouchUp:(id)sender;
- (IBAction)btnNoSkinDryTouchUp:(id)sender;
- (IBAction)btnYesSuccessfulLineTouchUp:(id)sender;
- (IBAction)btnNoSuccessfulLineTouchUp:(id)sender;
- (IBAction)btnSterileBarriersTouchUp:(id)sender;
- (IBAction)btnSkinPreparedTouchUp:(id)sender;
- (IBAction)btnInsertionSiteTouchUp:(id)sender;
- (IBAction)btnCatheterTypeTouchUp:(id)sender;
- (IBAction)btnSubmitTouchUp:(id)sender;
- (IBAction)btnClearAllTouchUp:(id)sender;


- (void)setSterileBarriers:(NSString *)currSterileBarriers;
- (void)setSkinPreparation:(NSString *)currSkinPrep enableFollowUp:(BOOL)followUpEnable;
- (void)setInsertionSite:(NSString *)currInsertionSite;
- (void)setCatheterType:(NSString *)currCatheterType;
-(void)initHandHygienePerformedButtons;
-(void)initSkinDryButtons;
-(void)initSuccessfulLineButtons;
-(void)initChlorhexidineContraindicationButtons;
-(void)enableChlorhexidineQuestion;
-(void)disableChlorhexidineQuestion;

- (NSString *)createStringFromMultipleChoice:(NSArray *)choices;
-(void)formatButton:(UIButton *)currButton withTitle:(NSString *)currTitle;
-(void)loadFirstPage;
-(BOOL)isDataOnPageValid;




@end
