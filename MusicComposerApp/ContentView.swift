//
//  ContentView.swift
//  MusicComposerApp
//
//  Created by Sumaita Khan Sanila on 30.09.24.
//

import SwiftUI
import AVKit

/// The main view of the app that allows users to select a video, view it, and process it using hand pose detection.
struct ContentView: View {
    /// The `VideoViewModel` instance that handles video processing and hand pose detection.
    /// This is observed by the view for changes using `@StateObject`.
    @StateObject private var viewModel = VideoViewModel()

    /// Boolean state to control the display of the video picker sheet.
    @State private var showVideoPicker = false

    var body: some View {
        VStack {
            // If a video is selected, show the video player. Otherwise, display a placeholder text.
            if let videoURL = viewModel.selectedVideoURL {
                // Display the selected video using AVKit's VideoPlayer.
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
            } else {
                // Text displayed when no video is selected.
                Text("No Video Selected")
                    .padding()
            }

            // Button to show the video picker sheet, allowing the user to select a video file.
            Button("Select Video from Files") {
                showVideoPicker.toggle()
            }
            .padding()
            // Sheet for selecting the video. When presented, it displays a VideoPicker view.
            .sheet(isPresented: $showVideoPicker) {
                // Pass the selected video URL to the view model's `selectedVideoURL` property.
                VideoPicker(selectedVideoURL: $viewModel.selectedVideoURL)
            }

            Spacer()

            // Button to trigger the video processing.
            Button("Process Video") {
                viewModel.processVideo()
            }
            // Disable the button if no video is selected.
            .disabled(viewModel.selectedVideoURL == nil)
            .padding()
        }
    }
}

/// Preview provider for Xcode's SwiftUI preview feature.
#Preview {
    ContentView()
}
