//
//  Utilities.swift
//  MilestoneChallenge
//
//  Created by Yu Fu on 4/2/22.
//

import Foundation

func documentDirectory() -> URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0]
}
