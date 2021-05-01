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

    var isSelected: Bool {
        selectedCount == count
    }
    var count: Int {
        rows.count
    }
    
    var selectedCount: Int {
        rows.filter({$0.isSelected}).count
    }
    
    @Published var selected = true
    
    private(set) var colorsName = Set<Row.ID>()
    private(set) var rows: [Row] = [] {
        didSet {
            rows.forEach { row in
                row.$isSelected.sink { [weak self] value in
                    guard let self = self else { return }
                    self.selected = self.isSelected
                }.store(in: &bag)
            }
        }
    }
    fileprivate var bag = [AnyCancellable]()
    
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
