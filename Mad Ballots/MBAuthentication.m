//
//  MBAuthentication.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBAuthentication.h"
#import "RKObjectMapping.h"
#import "RKRelationshipMapping.h"
#import "MBAuthenticationInfo.h"
#import "MBAuthenticationCredentials.h"

@implementation MBAuthentication

@synthesize provider, uid, info, credentials;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *authMapping = [RKObjectMapping mappingForClass:[MBAuthentication class]];
    
    //Add Attributes
    [authMapping addAttributeMappingsFromDictionary:@{
                                                      @"provider": @"provider",
                                                      @"uid": @"uid"}];
    
    //Add Relationships
    [authMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"info"
                                                                                toKeyPath:@"info"
                                                                              withMapping:[MBAuthenticationInfo getObjectMapping]]];
    [authMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"credentials"
                                                                                toKeyPath:@"credentials"
                                                                              withMapping:[MBAuthenticationCredentials getObjectMapping]]];
    
    
//    [authMapping mapKeyPath:@"provider" toAttribute:@"provider"];
//    [authMapping mapKeyPath:@"uid" toAttribute:@"uid"];
//    [authMapping mapKeyPath:@"info" toRelationship:@"info" withMapping:[MBAuthenticationInfo getObjectMapping]];
//    [authMapping mapKeyPath:@"credentials" toRelationship:@"credentials" withMapping:[MBAuthenticationCredentials getObjectMapping]];
    
    return authMapping;
}

-(id)init{

    self = [super init];
    if (self){
        self.info = [[MBAuthenticationInfo alloc] init];
        self.credentials = [[MBAuthenticationCredentials alloc] init];
        return self;
    }
    return NULL;

}



@end
