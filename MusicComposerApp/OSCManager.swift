//
//  OscManager.swift
//  MusicComposerApp
//
//  Created by Sumaita Khan Sanila on 01.10.24.
//

import Foundation
import OSCKit

/// A class responsible for managing OSC (Open Sound Control) communication.
/// This class sends OSC messages containing gesture data (x, y coordinates).
class OSCManager {
    /// The OSC client used to send messages.
    private var client: OSCClient

    /// Initializes the OSCManager and sets up the OSC client.
    init() {
        client = OSCClient()
    }

    /// Sends an OSC message containing the x and y coordinates of a detected gesture.
    /// - Parameters:
    ///   - x: The x-coordinate of the gesture (e.g., thumb tip position).
    ///   - y: The y-coordinate of the gesture (e.g., thumb tip position).
    func sendOSCMessage(x: Float, y: Float) {
        // Create an OSC message with the address "/gesture" and the x, y values as payload.
        let message = OSCMessage("/gesture", values: [x, y])
        
        do {
            // Send the OSC message to the specified IP address and port.
            try client.send(message, to: "127.0.0.1", port: 8732)
            print("send success")
        } catch {
            // Handle errors that may occur during sending.
            print("Failed to send OSC message: \(error)")
        }
    }
}
