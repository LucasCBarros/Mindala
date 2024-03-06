//
//  String + Localized.swift
//  NelsonMandala_app
//
//  Created by Ricardo Ferreira on 15/12/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
