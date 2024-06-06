//
//  GoalsWidgetBundle.swift
//  GoalsWidget
//
//  Created by Andrew on 6/6/24.
//

import WidgetKit
import SwiftUI

@main
struct GoalsWidgetBundle: WidgetBundle {
    var body: some Widget {
        GoalsWidget()
        GoalsWidgetLiveActivity()
    }
}
