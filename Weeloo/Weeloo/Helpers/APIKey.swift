//
//  APIKey.swift
//  Weeloo
//
//  Created by TEDDY 237 on 22/04/2025.
//

import Foundation

enum APIKey {
    /// THIS API_KEY  IS FOR THE GEMINI Ai MODEL WE ARE GOING TO USE FOR OUR WEELOO APP
    /// Fetch the API KEY From "GenerativeAI-Info.plist"
    static var `default` : String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAi-info", ofType: "plist")
        else {
           fatalError("Couldn't find file 'GenerativeAi-info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAi-info.plist'.")
        }
        if value.starts(with: "_") {
            fatalError(
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
}
