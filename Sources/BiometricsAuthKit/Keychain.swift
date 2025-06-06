//
//  KeychainHelper.swift
//  BiometricsAuthKit
//
//  Created by Djordje Arandjelovic on 6. 6. 2025..
//

import Foundation
import Security

public enum KeychainHelper {
    
    @discardableResult
    public static func save(key: String, value: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            // Remove existing item first
            SecItemDelete(query as CFDictionary)
            // Save new item
            return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
        }
        return false
    }
    
    public static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        // Load from Keychain if exists
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        // Return nil if it does not exist in Keychain
        return nil
    }
    
    // Delete item from Keychain (mostly for testing purposes)
    @discardableResult
    public static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
