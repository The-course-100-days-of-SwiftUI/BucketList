//
//  Attributes.swift
//  BucketList
//
//  Created by Margarita Mayer on 25/01/24.
//

import Foundation
import SwiftUI

extension View {
    
    func writeAndReadData<T: Codable>(data: T, path: String) -> T? {
        
        
        let url = URL.documentsDirectory.appending(path: path)
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            
            try encodedData.write(to: url, options: [.atomic, .completeFileProtection])
            
            let inputData = try Data(contentsOf: url)
            
            let decodedData = try JSONDecoder().decode(T.self, from: inputData)
            print(decodedData)
            return decodedData
            
            
        } catch {
            print(error.localizedDescription )
            return nil
        }
    }
    
}
