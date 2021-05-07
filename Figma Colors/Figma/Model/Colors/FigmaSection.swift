//
//  FigmaSection.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation

import Combine
class FigmaSection<Row: FigmaItem>: Identifiable, ObservableObject {

    let id = UUID()
//    typealias Row = FigmaItem
    
    /// "danger"
    let name: String

    var count: Int {
        rows.count
    }
    
    
    
    var selectedCount: Int {
        rows.filter({$0.isSelected}).count
    }
    
    @Published var isSelected = true
    
    private(set) var colorsName = Set<Row.ID>()
    private(set) var rows: [Row] = []
    
    var selectedRows: [Row] {
        rows.filter({$0.isSelected})
    }

    var description: String {
        "    // MARK: - \(name)"
    }
    
    internal init(name: String, colors: [Row] = [Row]()) {
        self.name = name
        self.rows = colors
    
    }
    
    
    func append(_ object: Row) {
        if colorsName.contains(object.id) == false {
            rows.append(object)
            colorsName.insert(object.id)
        }
    }
    
    func selected() -> Bool {
        selectedCount == count
    }
    
    func selectAll() {
        rows.forEach({$0.isSelected = true})
    }
    
    func unSelectAll() {
        rows.forEach({$0.isSelected = false})
    }
    
    func sortColors() {
        rows.sort(by: {$0.fullName < $1.fullName})
    }
}

extension FigmaSection where Row == ColorItem {
    
}
