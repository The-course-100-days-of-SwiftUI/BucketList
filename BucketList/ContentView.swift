//
//  ContentView.swift
//  BucketList
//
//  Created by Margarita Mayer on 25/01/24.
//

import MapKit
import SwiftUI


struct ContentView: View {
    
    let startPosition = MapCameraPosition.region(
    MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56, longitude: -3 ) ,
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
                
                ZStack {
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate  ) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle  )
                                        .onLongPressGesture {
                                            viewModel.selectedPlace = location
                                        }
                                }
                            }
                        }
                        .mapStyle(viewModel.mapStyle == "Standart" ? .standard : .hybrid)
                        .onTapGesture { position in
                            
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        .sheet(item: $viewModel.selectedPlace) { place in
                            EditView(location: place) {
                                viewModel.update(location: $0)
                            }
                        }
                        
                    }
                    VStack {
                    
                        Menu("Select a style") {
                            Picker("Select a style", selection: $viewModel.mapStyle) {
                                ForEach(viewModel.mapStyles, id: \.self) { mapStyle in
                                    Text(mapStyle)
                                    
                                }
                            }
                        }
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(.capsule)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    Spacer()
                }
            }
          
            
        } else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Error", isPresented: $viewModel.showingAlert) {
                    Button("Ok") {}
                } message: {
                    Text("There was an error")
                }
        }
    }
}
    

#Preview {
    ContentView()
}
