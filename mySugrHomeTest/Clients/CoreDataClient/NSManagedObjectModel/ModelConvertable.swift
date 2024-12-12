//
//  ModelConvertable.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import Foundation
import CoreData

protocol ModelConvertable {
    associatedtype ModelType
    func toModel(context: NSManagedObjectContext) -> ModelType
}

extension NSOrderedSet {
    func toModel<ModelElement, EntityType: ModelConvertable>(context: NSManagedObjectContext, entityElementType: EntityType.Type) -> [ModelElement] where EntityType.ModelType == ModelElement {
        return self.compactMap { ($0 as? EntityType)?.toModel(context: context) }
    }
}

extension Array: ModelConvertable where Element: ModelConvertable {
     func toModel(context: NSManagedObjectContext) -> [Element.ModelType] {
        self.map { $0.toModel(context: context) }
    }
}
