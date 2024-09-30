# Music Composer App

This project is an iOS application that processes videos to detect hand gestures using Apple's Vision framework. It identifies human hand poses in the video frames and sends the recognized hand gesture coordinates (e.g., thumb tip) over OSC (Open Sound Control) protocol to a specified port to localhost.

## Features

- **Video Processing**: Users can select a video file from their device and process it to detect hand gestures.
- **Hand Gesture Detection**: Detects hand gestures such as thumb tip position using Apple's Vision framework.
- **OSC Communication**: Sends detected gesture coordinates (x, y) over OSC to a specified IP address and port.
- **SwiftUI Interface**: The app uses SwiftUI for the interface, enabling a smooth and modern user experience.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Vision Framework**: For detecting hand gestures in video frames.
- **AVKit**: For video playback.
- **OSC**: Open Sound Control protocol for sending detected gesture data.

## Installation

### Prerequisites

- Xcode 12 or later
- iOS 14 or later
- macOS 11 or later
- An iOS device or simulator to run the app

### Steps

1. **Clone the repository**:
   Clone the repository from GitHub to your local machine:
   ```bash\
   git clone https://github.com/your-username/hand-gesture-video-app.git
2. For pure data install pure data app for OSX and open the .pd file with it.
}
