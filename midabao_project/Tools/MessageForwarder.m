//
//  MessageForwarder.m
//  midabao_project
//
//  Created by 杨路 on 2017/7/31.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "MessageForwarder.h"

@interface MessageForwarder()

@property (strong, nonatomic) NSPointerArray *allRecipient;
@end

@implementation MessageForwarder

- (void)setDelegateTargets:(NSArray *)delegateTargets {
    
    self.allRecipient = [NSPointerArray weakObjectsPointerArray];
    
    for (id target in delegateTargets) {
        [self.allRecipient addPointer:(__bridge void *)target];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    for (id target in self.allRecipient) {
        
        if ([target respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSMethodSignature *signature  = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (id target in self.allRecipient) {
            
            if ((signature = [target methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    for (id target in self.allRecipient) {
        
        if ([target respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:target];
        }
    }
}


@end
