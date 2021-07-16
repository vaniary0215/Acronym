//
//  Acronym.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import Foundation

// MARK: - AcronymDetails
struct AcronymDetails: Codable {
    var sf: String?
    var lfs: [Acronym]?
}

// MARK: - Acronym
struct Acronym: Codable {
    var lf: String?
    var freq, since: Int?
    var vars: [Acronym]?
    
    var allVars:String {
        return vars?.map({ (a) -> String in
            return a.lf ?? ""
        }).joined(separator: "\n") ?? ""
    }
}


