//
//  LocationModel.swift
//  TrackingLocationOnBackground
//
//  Created by Tri Dang on 07/08/2022.
//

import MapKit
import UIKit

struct Location: Codable, Identifiable {
    var id = UUID()
    var coordinate: Coordinate

    func endCodeTo() -> String {
        let data = try? JSONEncoder().encode(self)
        guard let data = data else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }

    func decode(data: Data) -> Self? {
        let jsonDecoder = JSONDecoder()
        let location = try? jsonDecoder.decode(Self.self,
                                               from: data)
        guard let location = location else { return nil }
        return location
    }

    func mapToCLLocate() -> CLLocationCoordinate2D {
        let locate = CLLocationCoordinate2D(latitude: coordinate.latitute,
                                            longitude: coordinate.longtitue)
        return locate
    }
}
