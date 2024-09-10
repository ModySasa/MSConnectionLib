//
//  MatchesExtension.swift
//  MSConnectionLib
//
//  Created by Moha on 9/11/24.
//


extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
