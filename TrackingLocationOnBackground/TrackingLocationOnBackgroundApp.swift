//
//  TrackingLocationOnBackgroundApp.swift
//  TrackingLocationOnBackground
//
//  Created by Tri Dang on 07/08/2022.
//

import SwiftUI

@main
struct TrackingLocationOnBackgroundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MapView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
