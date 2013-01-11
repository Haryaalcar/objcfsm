//
//  TinyStateMachine.h
//  objcfsm
//
//  Created by Uladzislau Susha on 10.01.2013.
//  Copyright (c) 2013 Haryaalcar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTo @"to"
#define kAction @"action"
#define START_FSM(...) (@{ __VA_ARGS__ })
#define ROW(stateFrom, event, stateTo, action )  @[stateFrom , event] : @{kTo : stateTo, kAction : action}

@interface TinyStateMachine : NSObject {
    NSString *currentState;
    NSString *fsmName;
}

+ (id)stateMachineWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme;
- (id)initWithName:(NSString *)name startingState:(NSString *)startingState andScheme:(NSDictionary *)scheme;
- (void)processEvent:(NSString *)event;

@end
