# BiometricsAuthKit

A lightweight Swift package to handle biometric authentication easily.

## Usage

Import `BiometricsAuthKit` and call:

```swift
BiometricsAuthenticator().authenticate { result in
    DispatchQueue.main.async {
        switch result {
        case .success:
            Handle success
        case .failure:
            Handle failure
        }
    }
}
