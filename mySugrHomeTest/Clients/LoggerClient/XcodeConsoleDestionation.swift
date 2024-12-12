//
//  XcodeConsoleDestionation.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import Foundation
import SwiftyBeaver

// Sets the warning type & emoji according to importance
class XcodeConsoleDestination: ConsoleDestination {
  override init() {
    super.init()
    setLevelColors()
  }

  private func setLevelColors() {
    levelColor.verbose = "📓 "
    levelColor.debug = "🐞 "
    levelColor.info = "ℹ️ "
    levelColor.warning = "⚠️ "
    levelColor.error = "📛 "
  }
}
