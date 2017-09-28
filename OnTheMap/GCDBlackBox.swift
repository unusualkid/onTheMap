//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Kenneth Chen on 9/27/17.
//  Copyright © 2017 Cotery. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
