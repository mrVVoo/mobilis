//
//  MXiConnection.m
//  MXi
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "MXiConnection.h"
#import "XMPP.h"

@implementation MXiConnection

@synthesize jabberID, password, hostName, port, serviceJID, coordinatorJID, serviceNamespace,
	xmppStream, presenceDelegate, stanzaDelegate, beanDelegate, incomingBeanPrototypes;

+ (id)connectionWithJabberID:(NSString* )aJabberID
					password:(NSString* )aPassword
					hostName:(NSString* )aHostName
						port:(NSInteger )port
			  coordinatorJID:(NSString* )theCoordinatorJID
			serviceNamespace:(NSString* )theServiceNamespace
			presenceDelegate:(id<MXiPresenceDelegate> )aPresenceDelegate
			  stanzaDelegate:(id<MXiStanzaDelegate> )aStanzaDelegate
				beanDelegate:(id<MXiBeanDelegate>)aBeanDelegate
   listeningForIncomingBeans:(NSArray *)theIncomingBeanPrototypes {
	MXiConnection* connection = [[MXiConnection alloc] init];
	
	XMPPJID* tempJid = [XMPPJID jidWithString:aJabberID];
	[connection setJabberID:tempJid];
	[connection setPassword:aPassword];
	if (aHostName && ![aHostName isEqualToString:@""]) {
		[connection setHostName:aHostName];
	} else {
		[connection setHostName:[tempJid domain]];
	}
	[connection setPort:port];
	[connection setCoordinatorJID:theCoordinatorJID];
	[connection setServiceNamespace:theServiceNamespace];
	[connection setPresenceDelegate:aPresenceDelegate];
	[connection setStanzaDelegate:aStanzaDelegate];
	[connection setBeanDelegate:aBeanDelegate];
	[connection setIncomingBeanPrototypes:theIncomingBeanPrototypes];
	
	[connection setupStream];
	[connection connect];
	return connection;
}

- (BOOL)reconnectWithJabberID:(NSString *)aJabberID
					 password:(NSString *)aPassword
					 hostname:(NSString *)aHostname
						 port:(NSInteger )thePort
				   coordinatorJID:(NSString *)theCoordinatorJID
			 serviceNamespace:(NSString *)theServiceNamespace {
	[self disconnect];
	
	[self setJabberID:[XMPPJID jidWithString:aJabberID]];
	[self setPassword:aPassword];
	if (aHostname && ![aHostname isEqualToString:@""]) {
		[self setHostName:aHostname];
	}
	[self setPort:thePort];
	[self setCoordinatorJID:theCoordinatorJID];
	[self setServiceNamespace:theServiceNamespace];
	
	return [self connect];
}

/*
 * XMPPStream delegate methods
 */

- (void)xmppStreamDidConnect:(XMPPStream* )sender {
	NSError* error = nil;
	[xmppStream authenticateWithPassword:password error:&error];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
	[presenceDelegate didDisconnectWithError:error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream* )sender {
	[self goOnline];
	[self discoverService];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
	NSLog(@"libMXi.a: Authentication failed");
	
	[presenceDelegate didFailToAuthenticate:error];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	BOOL success = [stanzaDelegate didReceiveIQ:iq];

	NSLog(@"Received iq: %@", [iq prettyXMLString]);
	NSXMLElement* childElement = [iq childElement];
	
	// Did we get a service discovery response?
	if ([[childElement name] isEqualToString:@"serviceDiscovery"]) {
		NSArray* discoveredServiceElements = [childElement children];
		for (int i = 0; i < [discoveredServiceElements count]; i++) {
			NSXMLElement* discoveredServiceElement = [discoveredServiceElements objectAtIndex:i];
			[presenceDelegate didDiscoverServiceWithNamespace:[discoveredServiceElement attributeStringValueForName:@"namespace"]
														 name:[discoveredServiceElement attributeStringValueForName:@"serviceName"]
													  version:[discoveredServiceElement attributeIntegerValueForName:@"version"]
												   atJabberID:[discoveredServiceElement attributeStringValueForName:@"jid"]];
			
			if (i == 0) {
				// choose the first discovered service jid by default
				[self setServiceJID:[discoveredServiceElement attributeStringValueForName:@"jid"]];
			}
		}
	}
	
	// Did we get an incoming mobilis bean?
	for (MXiBean<MXiIncomingBean>* prototype in incomingBeanPrototypes) {
		if ([[[prototype class] elementName] isEqualToString:[childElement name]] &&
				[[[prototype class] iqNamespace] isEqualToString:[childElement xmlns]] &&
				[[MXiIQTypeLookup stringValueForIQType:[prototype beanType]]
					isEqualToString:[iq attributeStringValueForName:@"type"]]) {
			// parse the iq data into the bean object
			[MXiBeanConverter beanFromIQ:iq intoBean:prototype];
			// inform the app about this incoming bean
			[beanDelegate didReceiveBean:prototype];
		}
	}
	
	return success;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	[stanzaDelegate didReceiveMessage:message];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	[stanzaDelegate didReceivePresence:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error {
	[stanzaDelegate didReceiveError:error];
}

/*
 * Preparing and closing the xmpp stream
 */

- (void)setupStream {
	xmppStream = [[XMPPStream alloc] init];
	// inform this very object about stream events
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
	XMPPPresence* presence = [XMPPPresence presence];
	[xmppStream sendElement:presence];
	
	[presenceDelegate didAuthenticate];
}

- (void)goOffline {
	XMPPPresence* presence = [XMPPPresence presenceWithType:@"unavailable"];
	[xmppStream sendElement:presence];
}

- (void)discoverService {
	NSXMLElement* namespaceElement =
		[NSXMLElement elementWithName:@"serviceNamespace"];
	[namespaceElement setStringValue:[self serviceNamespace]];
	NSXMLElement* discoElement =
		[NSXMLElement elementWithName:@"serviceDiscovery"
								xmlns:@"http://mobilis.inf.tu-dresden.de#services/CoordinatorService"];
	[discoElement addChild:namespaceElement];
	NSXMLElement* iqElement = [NSXMLElement elementWithName:@"iq"];
	[iqElement addAttributeWithName:@"to"
						stringValue:[self coordinatorJID]];
	[iqElement addAttributeWithName:@"type" stringValue:@"get"];
	[iqElement addChild:discoElement];
	
	[self sendElement:iqElement];
}

- (BOOL)connect {
	if ([xmppStream isConnected]) {
		return YES;
	}
	
	[xmppStream setMyJID:[self jabberID]];
	[xmppStream setHostName:[self hostName]];
	[xmppStream setHostPort:[self port]];
	
	XMPPReconnect* reconnect = [[XMPPReconnect alloc] init];
	[reconnect activate:xmppStream];
	
	/*
	NSLog(@"Trying to connect with:");
	NSLog(@" - myJid: %@", [xmppStream myJID]);
	NSLog(@" - myPassword: %@", password);
	NSLog(@" - hostname: %@", [xmppStream hostName]);
	NSLog(@" - port: %d", [xmppStream hostPort]);
	*/
	
	NSError* error = nil;
	if (![xmppStream connect:&error]) {
		NSLog(@"Couldn't connect because of error: %@", [error localizedDescription]);
		return NO;
	}
	
	return YES;
}

- (void)sendTestMessageWithContent:(NSString *)content
								to:(NSString *)to {
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	[body setStringValue:content];
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:@"chat"];
	[message addAttributeWithName:@"to" stringValue:to];
	[message addAttributeWithName:@"from" stringValue:[jabberID full]];
	[message addChild:body];
	
	[xmppStream sendElement:message];
}

- (void)sendElement:(NSXMLElement* )element {
	NSLog(@"Sent: %@", [element prettyXMLString]);
	
	[xmppStream sendElement:element];
}

- (void)sendBean:(MXiBean<MXiOutgoingBean>* )bean {
	[bean setFrom:jabberID];
	[bean setTo:[XMPPJID jidWithString:serviceJID]];
	
	[self sendElement:[MXiBeanConverter beanToIQ:bean]];
}

- (void)disconnect {
	[self goOffline];
	[xmppStream disconnect];
}

@end
