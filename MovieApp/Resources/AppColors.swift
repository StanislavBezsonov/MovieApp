import UIKit
import SwiftUI

struct AppColors {
    static let black = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let lightGray = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
    static let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let darkPink = UIColor(red: 153/255, green: 22/255, blue: 70/255, alpha: 1)
    static let deepPink = UIColor(red: 177/255, green: 35/255, blue: 88/255, alpha: 1)
    static let darkRed = UIColor(red: 130/255, green: 12/255, blue: 52/255, alpha: 1)
}

extension Color {
    static let appWhite = Color(AppColors.white)
    static let appBlack = Color(AppColors.black)
    static let appLightGray = Color(AppColors.lightGray)
    static let appDarkPink = Color(AppColors.darkPink)
    static let appDeepPink = Color(AppColors.deepPink)
    static let appDarkRed = Color(AppColors.darkRed)
}
