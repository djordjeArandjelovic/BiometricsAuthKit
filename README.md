![BiometricsAuthKit](banner_.png)

# BiometricsAuthKit

**A lightweight Swift package to handle biometric authentication easily with Face ID and Touch ID.**

---

## Features

- Supports Face ID and Touch ID
- Simple static API (`authenticate(reason:)`)
- Custom error handling via `BiometricAuthError`
- Detects biometric type (Face ID, Touch ID, or none)

---

## Installation

### Swift Package Manager

In **Xcode**:

1. Go to **File → Add Packages**
2. Enter: https://github.com/djordjeArandjelovic/BiometricsAuthKit.git


Or in `Package.swift`:

```swift
.package(url: "https://github.com/djordjeArandjelovic/BiometricsAuthKit.git", from: "1.0.0")
```

---

## Usage

Import `BiometricsAuthKit` and call:

```swift
BiometricsAuthenticator().authenticate { result in
    DispatchQueue.main.async {
        switch result {
        case .success:
            print("✅ Auth successful")
        case .failure:
            print("❌ Auth failed")
        }
    }
}
```

Check Biometric Type

```swift
let type = BiometricsAuthenticator.biometryType()
switch type {
case .faceID: print("Face ID available")
case .touchID: print("Touch ID available")
case .none: print("No biometrics")
}
```

---

## Requirements

- iOS 16.0+
- macOS 10.13.2+
- Swift 5+

---



