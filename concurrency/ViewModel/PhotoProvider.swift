//
//  PhotoProvider.swift
//  modern_concurrency
//
//  Created by Samson Lawrence on 2026-01-21.
//

import UIKit
import Observation

@Observable
class PhotoProvider {
    var photos: [Photo] = []
    var downloadedImages: [UIImage] = [] // Stores the actual UIImages for the grid
    var isLoading = false
    var isDownloadingBatch = false

    func fetchPhotos() async {
        isLoading = true
        // Simulating a small delay to see the loading state
        try? await Task.sleep(for: .seconds(0.5))
        
        self.photos = (1...100).map {
            Photo(id: $0, url: "https://picsum.photos/id/\($0)/200/200")
        }
        self.isLoading = false
    }

    // Parallel Task Group Download
    @MainActor // Ensures UI updates happen on the main thread
    func downloadBatch(limit: Int) async {
        isDownloadingBatch = true
        downloadedImages = [] // Clear previous images
        
        // Use the first X photos from our list
        let batch = photos.prefix(limit)
        
        // withTaskGroup allows multiple child tasks to run at once
        await withTaskGroup(of: UIImage?.self) { group in
            for photo in batch {
                // Add a child task to the group
                group.addTask {
                    guard let url = URL(string: photo.url) else { return nil }
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        return UIImage(data: data)
                    } catch {
                        print("Download error: \(error.localizedDescription)")
                        return nil // Return nil so the group can keep processing other images
                    }
                }
            }
            
            // As each image finishes (in any order), add it to our array
            for await image in group {
                if let image = image {
                    self.downloadedImages.append(image)
                }
            }
        }
        isDownloadingBatch = false
    }
}
