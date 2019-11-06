//
//  Helper.swift
//  AudioRecording
//
//  Created by Ilyasa Azmi on 06/11/19.
//  Copyright © 2019 Ilyasa Azmi. All rights reserved.
//

import Foundation

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}
