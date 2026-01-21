//
//  RemoteImageView.swift
//  modern_concurrency
//
//  Created by Samson Lawrence on 2026-01-21.
//

import SwiftUI

struct RemoteImageView: View {
    let imageUrl: String // A sample image URL

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    // 1. While loading
                    ProgressView()
                        .frame(width: 300, height: 200)
                
                case .success(let image):
                    // 2. Image loaded successfully
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                
                case .failure:
                    // 3. Error state (broken link, no internet)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 300, height: 200)
            
            Text("Sample Remote Image")
                .font(.caption)
                .padding()
        }
    }
}

// --- PREVIEW SECTION ---
#Preview {
    RemoteImageView(imageUrl: "https://picsum.photos/id/1/200")
}
