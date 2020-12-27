//
//  HomeworkWidgetBundle.swift
//  HomeworkWidgetExtension
//
//  Created by Anthony Peres da Cruz on 26/12/2020.
//

import SwiftUI

@main
struct HomeworkWidgetBundle: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        CustomHomeworkWidget()
    }
}
