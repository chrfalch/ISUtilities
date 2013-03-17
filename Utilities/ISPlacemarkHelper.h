//
//  ISPlacemarkHelper.h
//  TripLog
//
//  Created by Christian Falch on 3/8/13.
//  Copyright (c) 2013 Islandssoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ISPlacemarkHelper : NSObject

// Returns the distance in meters between the two placemarks
+(NSInteger) distanceBetweenPlacemark:(MKPlacemark*)placemark1 andPlacemark:(MKPlacemark*)placemark2;

// Gets a two-line address separated with comma
+(NSString*) addressFromPlacemark:(MKPlacemark*)placemark;

// Returns a correctly formatted address line from an address dictionary
+(NSString*) addressFromPlacemark:(MKPlacemark*)placemark forFirstLine:(BOOL)firstLine;

// Returns the street name from a placemark without street number
+(NSString*) streetNameFromPlacemark:(MKPlacemark*)placemark;

// Updates the address dictionary with name or details
+(void) setAddressForPlacemark:(MKPlacemark*)placemark address:(NSString*)address forFirstLine:(BOOL)firstLine;

// Returns true if the location has a coordinate
+(BOOL) placemarkHasCoordinate:(MKPlacemark*)placemark;

// returns true if the placemark has a valid address
+(BOOL) placemarkHasAddress:(MKPlacemark*)placemark;

// creates a copy from a dictonary and a coordinate
+(MKPlacemark*) placemarkFromCoordinate:(CLLocationCoordinate2D)coordinate andAddressDictionary:(NSDictionary*)addressDictionary;

// Returns a dictionary formatted to be used in a placemark
+(NSMutableDictionary*) dictionaryWithAddress:(NSString*)address withDetails:(NSString*)details;

// Performs a deep copy of a placemark
+(MKPlacemark*) placemarkDeepCopyFromPlacemark:(MKPlacemark*)placemark;

// Creates a new placemark with the given values
+(MKPlacemark*) placemarkWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString*)name details:(NSString*)details;

@end
