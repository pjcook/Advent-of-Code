//
//  Errors.swift
//  Year2019
//
//  Created by PJ COOK on 02/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation

enum Errors: Error {
    case invalidFilename
    case invalidFileData
    case invalidOpCode
    case intCodeInvalidIndex
    case intCodeNoData
    case calculateNounVerbNoResult
    case invalidManhattanInstruction
}
