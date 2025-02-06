# Flickr Image Search

A simple iOS application that allows users to search for images on Flickr using tags.
https://github.com/sagaya120/FlickrTest/raw/refs/heads/main/demo.mov
[Watch the video](https://github.com/sagaya120/FlickrTest/raw/refs/heads/main/demo.mov)

## Features

- Search for images using tags
- Real-time search results
- Grid layout for image thumbnails
- Detailed view for each image with metadata
- Error handling and loading states
- Unit tests for core functionality

## Requirements

- iOS 18.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open `FlickrTest.xcodeproj` in Xcode
3. Build and run the project

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern and uses SwiftUI for the user interface. It's organized into the following components:

- **Models**: Data models for the Flickr API response
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**: Network layer for API communication

## Testing

The project includes unit tests for the core functionality. To run the tests:

1. Open the project in Xcode
2. Select the test target
3. Press Cmd+U or navigate to Product > Test
