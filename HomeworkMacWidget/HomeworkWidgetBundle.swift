//
//  HomeworkWidgetBundle.swift
//  HomeworkMacWidgetExtension
//
//  Created by Anthony Peres da Cruz on 28/12/2020.
//

import SwiftUI

@main
struct HomeworkWidgetBundle: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        CustomHomeworkWidget()
    }
}
