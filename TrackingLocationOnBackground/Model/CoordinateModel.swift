//
//  CoordinateModel.swift
//  TrackingLocationOnBackground
//
//  Created by Tri Dang on 07/08/2022.
//

import MapKit
import UIKit

struct Coordinate: Codable {
    var latitute: Double
    var longtitue: Double

    static func map(withCLLocationCoordinate2D locate: CLLocationCoordinate2D) -> Self {
        let coordinate = Coordinate(latitute: locate.latitude,
                                    longtitue: locate.longitude)
        return coordinate
    }
}
