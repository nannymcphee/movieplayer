//
//  CustomError.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import Foundation

struct CustomError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}
