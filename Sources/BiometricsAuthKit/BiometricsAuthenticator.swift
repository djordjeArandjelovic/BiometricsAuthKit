// The Swift Programming Language
// https://docs.swift.org/swift-book


import LocalAuthentication
import Foundation

@available(macOS 10.13.2, *)
public struct BiometricsAuthenticator {
    
    public init() { }
    
    public enum BiometricType {
        case touchID
        case faceID
        case none
    }
    
    public enum BiometricAuthError: Error, LocalizedError {
        case unavailable
        case failed
        case cancelled
        case fallback
        case unknown(Error)
        
        public var errorDescription: String? {
            switch self {
            case .unavailable:
                return "Biometric authentication is not available on this device."
            case .failed:
                return "Authentication failed. Please try again."
            case .cancelled:
                return "Authentication was cancelled."
            case .fallback:
                return "Fallback authentication was selected."
            case .unknown(let error):
                return error.localizedDescription
            }
        }
    }
    
    //returns awvailable biometry type
    public static func biometryType() -> BiometricType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
    
    //attempts to authenticate
    public static func authenticate(reason: String = "Authenticate to proceed",
                                    completion: @escaping @Sendable (Result<Void, BiometricAuthError>) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            log("Can evaluate biometric + passcode auth")

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        log("Authentication succeeded")
                        completion(.success(()))
                    } else {
                        log("Authentication failed: \(authError?.localizedDescription ?? "Unknown error")")
                        let convertedError = mapError(authError)
                        completion(.failure(convertedError))
                    }
                }
            }
        } else {
            log("Biometrics unavailable: \(error?.localizedDescription ?? "Unknown error")")
            completion(.failure(.unavailable))
        }
    }
    
    private static func mapError(_ error: Error?) -> BiometricAuthError {
        guard let error = error as? LAError else {
            return .unknown(error ?? NSError(domain: "Unknown", code: -1))
        }
        
        switch error.code {
        case .authenticationFailed:
            return .failed
        case .userCancel:
            return .cancelled
        case .userFallback:
            return .fallback
        case .biometryNotAvailable, .biometryNotEnrolled, .biometryLockout:
            return .unavailable
        default:
            return .unknown(error)
        }
    }
    
    private static func log(_ message: String) {
        #if DEBUG
        print("[BiometricsAuthKit] \(message)")
        #endif
    }
}
