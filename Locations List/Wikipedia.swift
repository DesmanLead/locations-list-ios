//
//  Wikipedia.swift
//  Locations List
//
//  Created by Artem Kirienko on 11/03/2026.
//

import Foundation

struct Wikipedia {
    private init() {}

    static func url(for location: Location) -> URL {
        URL(string: "wikipedia://places?lat=\(location.latitude)&lon=\(location.longitude)")!
    }
}
