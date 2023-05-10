//  JsonLoader.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 05/01/2021.

import Foundation

func loadFile<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.dataBundle.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in data bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch  {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func loadFile(_ filename: String) -> [String: Any] {
    let data: Data
    
    guard let file = Bundle.dataBundle.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in data bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return dict as! [String: Any]
    } catch  {
        fatalError("Couldn't parse \(filename) as :[String: Any]:\n\(error)")
    }
}
