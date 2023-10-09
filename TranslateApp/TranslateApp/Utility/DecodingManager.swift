//
//  DecodingManager.swift
//  TranslateApp
//
//  Created by Min Hyun on 2023/10/10.
//

import UIKit

final class DecodingManager {
    static let shared = DecodingManager()
    let decoder = JSONDecoder()
    
    private init() {}
    
    func decode<T: Decodable>(_ data: Data?) throws -> T {
        guard let data = data,
              let decodedData = try? decoder.decode(T.self, from: data) else {
            throw DecodingError.decodingFailure
        }
        return decodedData
    }
}
