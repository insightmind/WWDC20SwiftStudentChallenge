// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

protocol PauseMenuDelegate: AnyObject {
    func didTapCloseButton()
    func didTapResumeButton()
}
