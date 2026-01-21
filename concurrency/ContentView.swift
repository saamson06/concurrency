//
//  ContentView.swift
//  concurrency
//
//  Created by Samson Lawrence on 2026-01-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var provider = PhotoProvider()
    
    var body: some View {
        NavigationStack {
            
            NavigationLink("Open Parallel Task Group Grid") {
                BatchDownloadView()
            }
            .font(.headline)
            .foregroundColor(.blue)
            
            Group {
                if provider.isLoading && provider.photos.isEmpty {
                    ProgressView("Fetching Gallery...")
                } else {
                    List(provider.photos) { photo in
                        RemoteImageView(imageUrl: photo.url)
                    }
                }
            }
            .navigationTitle("Modern Gallery")
            // This is the Modern Concurrency entry point
            .task {
                await provider.fetchPhotos()
            }
            .refreshable {
                await provider.fetchPhotos()
            }
        }
    }
}

#Preview {
    ContentView()
}
