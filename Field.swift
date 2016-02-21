//
//  Field.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/20/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit

public struct Field {


    var name: String;
    var source: FieldItemSource;
    var boundary: FieldBoundary;
    var sourceMetadata: String;
    var farmId: String;
    var centroid: FieldCentroid;
    var id: String;
    var symmetricOverlapPercent: Float;
    var area: FieldArea;
    var uuid: String;
    var version: Float;
    var timestamp: Int;
    var enabled: Bool;
    
    init(name: String,
        source:FieldItemSource,
        boundary: FieldBoundary,
        sourceMeta: String,
        farmId: String,
        centroid: FieldCentroid,
        id: String,
        symmetricOverlapPercent: Float,
        area: FieldArea,
        uuid: String,
        version: Float,
        timestamp: Int,
        enabled: Bool){
            
            self.name = name;
            self.source = source;
            self.boundary = boundary;
            self.sourceMetadata = sourceMeta;
            self.farmId = farmId;
            self.centroid = centroid;
            self.id = id;
            self.symmetricOverlapPercent = symmetricOverlapPercent;
            self.area = area;
            self.uuid = uuid;
            self.version = version;
            self.timestamp = timestamp;
            self.enabled = enabled;
            
            
            
    }
    
    
   
    
}

struct FieldItemSource {
    var boundary: String;
    var attributes: String;
    
    init(boundary: String, attributes: String){
        self.boundary = boundary;
        self.attributes = attributes;
    }
}

struct FieldBoundary {
    var type: String;
    
    init(type: String){
        self.type = type;
    }
}


struct FieldCentroid {
    var coordinates: Array<Double>;
    var type: String;
    
    init(coordinates: Array<Double>, type: String){
        self.coordinates = coordinates;
        self.type = type;
    }
}


struct FieldArea {
    var q: Double;
    var u: String;
    
    init (q: Double, u: String){
        self.q = q;
        self.u = u;
    }
    
}
