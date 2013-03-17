//
//  ISPlacemarkHelper.m
//  TripLog
//
//  Created by Christian Falch on 3/8/13.
//  Copyright (c) 2013 Islandssoftware. All rights reserved.
//

#import "ISPlacemarkHelper.h"

@implementation ISPlacemarkHelper

+(MKPlacemark*) placemarkDeepCopyFromPlacemark:(MKPlacemark *)placemark
{
    NSDictionary* addressDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray* addressLines = [[NSMutableArray alloc] init];
    [addressLines addObject:[ISPlacemarkHelper addressFromPlacemark:placemark forFirstLine:YES]];
    [addressLines addObject:[ISPlacemarkHelper addressFromPlacemark:placemark forFirstLine:NO]];
    [addressDictionary setValue:addressLines forKey:@"FormattedAddressLines"];
    
    return [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(placemark.coordinate.latitude, placemark.coordinate.longitude) addressDictionary:addressDictionary];
}

+(MKPlacemark*) placemarkFromCoordinate:(CLLocationCoordinate2D)coordinate andAddressDictionary:(NSDictionary*)addressDictionary
{
    // get address lines
    NSArray* addressLines = [addressDictionary objectForKey:@"FormattedAddressLines"];
    
    // Create copies
    NSMutableDictionary* addressDictionaryCopy = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray* addressLinesCopy = [[NSMutableArray alloc] init];
    
    [addressLinesCopy addObject:[addressLines objectAtIndex:0]];
    [addressLinesCopy addObject:[addressLines objectAtIndex:1]];
    [addressDictionaryCopy setValue:addressLinesCopy forKey:@"FormattedAddressLines"];
    
    return [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) addressDictionary:addressDictionaryCopy];
}

// Returns a dictionary formatted to be used in a placemark
+(NSMutableDictionary*) dictionaryWithAddress:(NSString*)address withDetails:(NSString*)details
{
    if(address == nil)
        address = @"";
    
    if(details == nil)
        details = @"";
    
    NSMutableDictionary* addressDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray* addressLines = [[NSMutableArray alloc] init];
    [addressLines addObject:address];
    [addressLines addObject:details];
    [addressDictionary setValue:addressLines forKey:@"FormattedAddressLines"];
    return addressDictionary;
}

// Creates a new placemark with the given values
+(MKPlacemark*) placemarkWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString*)name details:(NSString*)details
{
    if(name == nil)
        name = @"";
    
    if(details == nil)
        details = @"";
    
    NSMutableDictionary* addressDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray* addressLines = [[NSMutableArray alloc] init];
    [addressLines addObject:name];
    [addressLines addObject:details];
    [addressDictionary setValue:addressLines forKey:@"FormattedAddressLines"];
    
    return [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) addressDictionary:addressDictionary];
}

// Updates the address dictionary with name or details
+(void) setAddressForPlacemark:(MKPlacemark*)placemark address:(NSString*)address forFirstLine:(BOOL)firstLine
{
    if([self placemarkHasAddress:placemark])
    {
        NSMutableArray* array = [[placemark addressDictionary] objectForKey:@"FormattedAddressLines"];
        
        // ensure element count = 2
        while(array.count < 2)
            [array addObject:@""];
        
        if(firstLine)
        {
            [array removeObjectAtIndex:0];
            [array insertObject:address atIndex:0];
        }
        else {
            [array removeObjectAtIndex:1];
            [array addObject:address];
        }
    }
    else
    {
        dNSLog(@"placemark does not have address!");
    }
}

+(NSString*) streetNameFromPlacemark:(MKPlacemark*)placemark
{
    // First, check if we have a nil value. Just return information on what to di
    if(!placemark)
        return NSLocalizedString(@"No location selected", @"Placemarkhelper - no streetname was found");
    
    // If we have address information
    if([self placemarkHasAddress:placemark])
    {
        
        NSString* street = [[placemark addressDictionary] objectForKey:@"Street"];
        if(street && street.length > 0)
        {
            NSArray* streetComps = [street componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- ,"]];
            
            NSMutableString* streetWithOutNumbers = [[NSMutableString alloc] init];
            NSNumberFormatter* ns = [[NSNumberFormatter alloc] init];
            
            for(NSString* s in streetComps)
            {
                // Does the component begin with a number?
                BOOL beginsWithNumber = [s length] && isnumber([s characterAtIndex:0]);
                
                if(beginsWithNumber || [ns numberFromString:s])
                    continue;
                
                // Not a number and does not start with a number
                [streetWithOutNumbers appendFormat:@"%@%@", (streetWithOutNumbers.length > 0 ? @" " : @""), s];
            }
            
            street = [NSString stringWithString:streetWithOutNumbers];
        }
        
        if(street && street.length > 0)
            return street;
        else
            return [self addressFromPlacemark:placemark];
        
    }
    else if([self placemarkHasCoordinate:placemark])
    {
        NSString *latString = (placemark.coordinate.latitude < 0) ? NSLocalizedString(@"South", @"Placemark helper - direction") : NSLocalizedString(@"North", @"Placemark helper - direction");
        
        NSString *lonString = (placemark.coordinate.longitude < 0) ? NSLocalizedString(@"West", @"Placemark helper - direction") : NSLocalizedString(@"East", @"Placemark helper - direction");
        
        return [NSString stringWithFormat:@"%.4f° %@, %.4f° %@", fabs(placemark.coordinate.latitude), latString, fabs(placemark.coordinate.longitude), lonString];
    }
    else
    {
        
        return NSLocalizedString(@"No location selected", @"Placemarkhelper - no streetname was found");
    }
    
}

+(NSString*) addressFromPlacemark:(MKPlacemark*)placemark
{
    return [NSString stringWithFormat:@"%@, %@", [self addressFromPlacemark:placemark forFirstLine:YES], [self addressFromPlacemark:placemark forFirstLine:NO]];
}

// Returns a correctly formatted address line from an address dictionary
+(NSString*) addressFromPlacemark:(MKPlacemark*)placemark forFirstLine:(BOOL)firstLine
{
    // First, check if we have a nil value. Just return information on what to di
    if(!placemark)
    {
        if(firstLine)
            return NSLocalizedString(@"No location selected", @"Placemarkhelper - no location was found");
        else
            return NSLocalizedString(@"Click to select location", @"Placemarkhelper - click to select location text");
    }
    
    // If we have address information
    if([self placemarkHasAddress:placemark])
    {
        if(firstLine)
        {
            return [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] objectAtIndex:0];
        }
        else
        {
            NSArray* arr = (NSArray*)[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
            
            NSRange range;
            range.location = 1;
            range.length = [arr count]-1;
            
            
            NSArray* tmp = [[NSArray alloc] initWithArray: [arr subarrayWithRange:range]];
            
            return [tmp componentsJoinedByString:@", "];
        }
    }
    else if([self placemarkHasCoordinate:placemark])
    {
        NSString *latString = (placemark.coordinate.latitude < 0) ? NSLocalizedString(@"South", @"Placemark helper - direction") : NSLocalizedString(@"North", @"Placemark helper - direction");
        
        NSString *lonString = (placemark.coordinate.longitude < 0) ? NSLocalizedString(@"West", @"Placemark helper - direction") : NSLocalizedString(@"East", @"Placemark helper - direction");
        
        if(firstLine)
            return [NSString stringWithFormat:@"%.4f° %@, %.4f° %@", fabs(placemark.coordinate.latitude), latString, fabs(placemark.coordinate.longitude), lonString];
        else
            return @"";
        
    }
    else
    {
        
        if(firstLine)
            return NSLocalizedString(@"No location selected", @"Placemarkhelper - no location was found");
        else
            return NSLocalizedString(@"Click to select location", @"Placemarkhelper - click to select location text");
    }
}

+(BOOL) placemarkHasCoordinate:(MKPlacemark*)placemark
{
    return placemark && placemark.coordinate.latitude != 0.0 && placemark.coordinate.longitude != 0.0;
}

// returns true if the placemark has a valid address
+(BOOL) placemarkHasAddress:(MKPlacemark*)placemark
{
    return placemark && placemark.addressDictionary && [placemark.addressDictionary allKeys].count > 0 && [placemark.addressDictionary valueForKey:@"FormattedAddressLines"] != nil && ![[((NSArray*)[placemark.addressDictionary valueForKey:@"FormattedAddressLines"]) componentsJoinedByString:@""] isEqualToString:@""];
}

// Returns the distance in meters between the two placemarks
+(NSInteger) distanceBetweenPlacemark:(MKPlacemark*)placemark1 andPlacemark:(MKPlacemark*)placemark2
{
    CLLocation* loc1 = [[CLLocation alloc] initWithLatitude:placemark1.coordinate.latitude longitude:placemark1.coordinate.longitude];
    
    CLLocation* loc2 = [[CLLocation alloc] initWithLatitude:placemark2.coordinate.latitude longitude:placemark2.coordinate.longitude];
    
    return [loc2 distanceFromLocation:loc1];
}
@end


