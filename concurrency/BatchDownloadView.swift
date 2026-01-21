//
//  BatchDownloadView.swift
//  modern_concurrency
//
//  Created by Samson Lawrence on 2026-01-21.
//

import SwiftUI

struct BatchDownloadView: View {
    @State private var provider = PhotoProvider()
    let totalItems = 21 // The limit we want to show
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                // Loop through the total count instead of just the downloaded array
                ForEach(0..<totalItems, id: \.self) { index in
                    ZStack {
                        // Check if the image has been downloaded for this index yet
                        if index < provider.downloadedImages.count {
                            Image(uiImage: provider.downloadedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .transition(.opacity.combined(with: .scale))
                        } else {
                            // This shows while the image is still being fetched by the Task Group
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 110, height: 110)
                                .overlay {
                                    ProgressView() // The loader inside the grid cell
                                }
                        }
                    }
                }
            }
            .padding()
            // Animates the transition between ProgressView and Image
            .animation(.default, value: provider.downloadedImages.count)
        }
        .navigationTitle("Parallel Grid")
        .task {
            await provider.fetchPhotos()
            await provider.downloadBatch(limit: totalItems)
        }
    }
}

#Preview {
    BatchDownloadView()
}
