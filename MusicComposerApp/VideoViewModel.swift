//
//  VideoViewModel.swift
//  MusicComposerApp
//
//  Created by Sumaita Khan Sanila on 30.09.24.
//

import Foundation
import AVFoundation
import Vision

/// ViewModel responsible for handling video processing and hand pose detection
/// Uses Vision and AVFoundation to process video frames and detect hand poses.
/// Detected hand gestures are sent through Open Sound Control (OSC).
class VideoViewModel: ObservableObject {
    
    /// Published property to hold the selected video URL. Observed by SwiftUI views for updates.
    @Published var selectedVideoURL: URL?
    
    /// AVAsset representing the video to be processed.
    private var videoAsset: AVAsset?
    
    /// Vision request for detecting human hand poses in video frames.
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    /// Object responsible for managing Open Sound Control (OSC) communication.
    private let oscManager = OSCManager()
    
    /// Flag to prevent multiple video processing operations running simultaneously.
    private var isProcessing = false

    /// Initializes the ViewModel and configures the Vision request for hand pose detection.
    init() {
        setupVisionRequest()
    }

    /// Sets up the Vision request to detect up to two hands in video frames.
    func setupVisionRequest() {
        // Configure the hand pose request to detect a maximum of two hands.
        handPoseRequest.maximumHandCount = 2
    }

    /// Starts the video processing workflow by reading the selected video and processing each frame.
    /// This function is run on a background thread to avoid blocking the main UI.
    func processVideo() {
        // Ensure a video URL has been selected.
        guard let videoURL = selectedVideoURL else { return }
        
        // Initialize the AVAsset with the selected video URL.
        videoAsset = AVAsset(url: videoURL)
        
        // Ensure the video asset is valid.
        guard let asset = videoAsset else { return }

        // Check if a video is already being processed.
        guard !isProcessing else { return }
        
        // Set the processing flag to true.
        isProcessing = true
        
        // Perform video processing in a background thread.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Process the frames of the video.
            self?.processFrames(asset: asset)
            
            // Reset the processing flag when done.
            self?.isProcessing = false
        }
    }

    /// Processes the frames of the given AVAsset using AVAssetReader and sends hand pose data via OSC.
    /// - Parameter asset: The AVAsset representing the video to process.
    private func processFrames(asset: AVAsset) {
        do {
            // Create an AVAssetReader to extract video frames from the asset.
            let reader = try AVAssetReader(asset: asset)
            
            // Retrieve the video track from the asset.
            guard let videoTrack = asset.tracks(withMediaType: .video).first else {
                print("Error: No video track found.")
                return
            }
            
            // Configure the settings for reading the video frames.
            let outputSettings: [String: Any] = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            
            // Create an output reader for the video track.
            let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: outputSettings)
            reader.add(readerOutput)
            reader.startReading()

            // Loop through video frames until the entire video is processed.
            while reader.status == .reading {
                // Retrieve the next sample buffer (video frame) from the reader.
                if let sampleBuffer = readerOutput.copyNextSampleBuffer() {
                    // Process the video frame.
                    self.processFrame(sampleBuffer: sampleBuffer)
                }
            }

            // Check if the reader completed successfully.
            if reader.status == .completed {
                print("Finished processing video.")
            } else {
                print("Error processing video: \(String(describing: reader.error))")
            }
        } catch {
            // Handle any errors during video reading.
            print("Error reading video: \(error)")
        }
    }

    /// Processes an individual video frame and sends detected hand pose data via OSC.
    /// - Parameter sampleBuffer: A CMSampleBuffer containing the video frame data.
    private func processFrame(sampleBuffer: CMSampleBuffer) {
        // Extract the pixel buffer (image data) from the sample buffer.
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Error: Failed to get pixel buffer from sample buffer.")
            return
        }

        // Create a Vision request handler to process the pixel buffer.
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            // Perform the hand pose detection request.
            try requestHandler.perform([handPoseRequest])
            
            // Retrieve the hand pose observations from the request results.
            guard let observations = handPoseRequest.results else {
                print("No hand pose observations found.")
                return
            }

            // Send hand gesture data (e.g., thumb tip position) via OSC for each hand.
            for observation in observations {
                // Extract the thumb tip position from the observation.
                if let thumbTip = try? observation.recognizedPoints(.thumb)[.thumbTip] {
                    let x = thumbTip.location.x
                    let y = thumbTip.location.y
                    
                    // Send the thumb tip coordinates using OSC.
                    oscManager.sendOSCMessage(x: Float(x), y: Float(y))
                    print("Thumb tip detected at \(x), \(y)")
                }
            }

        } catch {
            // Handle any errors during frame processing.
            print("Error processing frame: \(error)")
        }
    }
}
