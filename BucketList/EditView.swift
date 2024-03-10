//
//  EditView.swift
//  BucketList
//
//  Created by Margarita Mayer on 28/01/24.
//

import SwiftUI

struct EditView: View {
    
   
    var location: Location
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Location) -> Void
    
    
    @State private var viewModel: ViewModel
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                     
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                        
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            
                            + Text(": \n") +
                            
                            Text(page.description)
                                .italic()
                            
                        }
                        
                    case .failed:
                        Text("Failed...")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    onSave(newLocation)
                   dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces(location: location)
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _viewModel = State(initialValue: ViewModel(name: location.name, description: location.description))
    }
    
    }

#Preview {
    EditView(location: .example ) { _ in }  
}
