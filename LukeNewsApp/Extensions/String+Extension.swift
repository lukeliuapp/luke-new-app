//
//  String+Extension.swift
//  NewsApp
//
//  Created by Luke Liu on 1/11/2023.
//

import Foundation

extension String {
    func formatDateToReadableStyle() -> String? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        ]
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.locale = .autoupdatingCurrent
        convertDateFormatter.setLocalizedDateFormatFromTemplate("dd MMM yyyy HH:mm")
        
        // Because NewsAPI returns two kinds of Date formats.
        // Iterating over each date format to try to match and convert the date string.
        for format in dateFormats {
            let oriDateFormatter = DateFormatter()
            oriDateFormatter.dateFormat = format
            if let date = oriDateFormatter.date(from: self) {
                return convertDateFormatter.string(from: date)
            }
        }
        
        return nil
    }
}
