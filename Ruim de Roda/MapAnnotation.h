//
//  MapAnnotation.h
//  Ruim de Roda
//
//  Created by Henrique Velloso on 4/11/15.
//  Copyright (c) 2015 Ruim de Roda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
