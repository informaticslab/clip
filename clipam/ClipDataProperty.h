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



// person recording data choices
#define CV_INSERTER_RECORDING_DATA 1
#define CV_OBSERVER_RECORDING_DATA 2

// patient gender possible
#define CV_GENDER_MALE 1
#define CV_GENDER_FEMALE 2
#define CV_GENDER_OTHER 3


@interface ClipDataProperty: NSObject
{
    BOOL isChecked;
    NSUInteger valueType;
    NSString *label;
    NSString *textValue;
    NSDate *dateValue;
    
}

@property(strong, nonatomic) NSString *textValue;
@property(strong, nonatomic) NSString *label;
@property BOOL isChecked;
@property(strong, nonatomic) NSDate *dateValue;


-(BOOL)isCdpChecked;

@end
