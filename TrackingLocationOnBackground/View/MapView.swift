//
//  MapView.swift
//  TrackingLocationOnBackground
//
//  Created by Tri Dang on 07/08/2022.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.locationJson, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.mapRegion,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow),
                annotationItems: viewModel.locationsSaved) { locate in
                MapAnnotation(coordinate: locate.mapToCLLocate()) {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 10, height: 10)
                }
            }
        }
        .onAppear(perform: {
            items.forEach { item in
                let data = Data(item.locationJson?.utf8 ?? "".utf8)
                let location = try? JSONDecoder().decode(Location.self, from: data)
                if let location = location {
                    viewModel.locationsSaved.append(location)
                    print(location)
                }
                /// Remove all location data saved if want start save new location
//                viewContext.delete(item)
            }
//            do {
//                try viewContext.save()
//
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
        })
        .onReceive(
            viewModel
                .$didAddedLocation
                .debounce(for: 0.1, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()) { locationAdded in
            guard let locationAdded = locationAdded else { return }
            let item = Item(context: viewContext)
            item.locationJson = locationAdded.endCodeTo()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
