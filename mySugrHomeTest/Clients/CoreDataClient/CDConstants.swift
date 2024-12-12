//
//  CDConstants.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

/*
 When a Core Data model (.xcdatamodeld) is compiled by Xcode, it is packaged into a .momd bundle (Managed Object Model Directory) if there are multiple versions of the model (for versioning support). This .momd directory contains one or more .mom files, which are the compiled representations of your Core Data model.
 */
struct CDConstants {
    static let model = "CDModel"
    static let subdirectory = "CDModel.momd"
}
