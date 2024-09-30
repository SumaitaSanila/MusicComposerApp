//
//  VideoPicker.swift
//  MusicComposerApp
//
//  Created by Sumaita Khan Sanila on 30.09.24.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// A SwiftUI view that wraps a `UIDocumentPickerViewController` to allow users to pick a video file.
/// The selected video URL is bound to the parent view via the `selectedVideoURL` binding.
struct VideoPicker: UIViewControllerRepresentable {
    /// The URL of the selected video, which is bound to a parent view.
    @Binding var selectedVideoURL: URL?

    /// Creates and returns a `UIDocumentPickerViewController` for selecting video files.
    /// - Parameter context: The context used to coordinate between SwiftUI and UIKit.
    /// - Returns: A configured `UIDocumentPickerViewController` that allows selecting movie files.
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Create a document picker limited to movie file types (e.g., .mp4, .mov).
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie])
        picker.delegate = context.coordinator
        return picker
    }

    /// Updates the `UIDocumentPickerViewController` when SwiftUI view state changes.
    /// - Parameters:
    ///   - uiViewController: The document picker view controller that needs to be updated.
    ///   - context: The context used to coordinate between SwiftUI and UIKit.
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No dynamic updates are necessary for the document picker in this case.
    }

    /// Creates and returns a coordinator to manage interactions between SwiftUI and the document picker.
    /// - Returns: A `Coordinator` instance to act as the delegate for the document picker.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// A coordinator class that acts as the delegate for `UIDocumentPickerViewController`.
    /// Handles the selection of video files and binds the selected URL to the parent view.
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        /// A reference to the parent `VideoPicker`, allowing interaction with its properties.
        let parent: VideoPicker

        /// Initializes the coordinator with a reference to the parent `VideoPicker`.
        /// - Parameter parent: The parent `VideoPicker` instance.
        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        /// Called when the user picks a document. Assigns the selected video URL to the parent view's binding.
        /// - Parameters:
        ///   - controller: The document picker view controller.
        ///   - urls: The array of URLs selected by the user. The first URL is taken as the selected video.
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let pickedURL = urls.first else { return }
            // Assign the selected video URL to the bound property.
            parent.selectedVideoURL = pickedURL
        }

        /// Called when the user cancels the document picker without selecting a file.
        /// - Parameter controller: The document picker view controller.
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle the cancel action if needed (e.g., logging, resetting state, etc.)
        }
    }
}
