//
//  Bundle+PlistContents.swift
//  SunriseSunset
//
//  Created by Vasyl Mytko on 11/8/18.
//  Copyright © 2018 Vasyl Mytko. All rights reserved.
//

import Foundation

extension Bundle {
    public static func contentsOfFile(plistName: String, bundle: Bundle? = nil) -> [String : AnyObject] {
        let fileParts = plistName.components(separatedBy: ".")
        guard fileParts.count == 2,
            let resourcePath =  Bundle.main.path(forResource: fileParts[0], ofType: fileParts[1]),
            let contents = NSDictionary(contentsOfFile: resourcePath) as? [String : AnyObject]
            else {
                return [:]
        }
        return contents
    }
}
