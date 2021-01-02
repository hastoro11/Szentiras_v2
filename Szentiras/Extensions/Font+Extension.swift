//
//  Font+Extension.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 02..
//

import SwiftUI

extension Font {
   static func medium(_ size: CGFloat) -> Font {
      Self.custom("FiraSans-Medium", size: size)
   }
   
   static func bold(_ size: CGFloat) -> Font {
      Self.custom("FiraSans-Bold", size: size)
   }
   
   static func regular(_ size: CGFloat) -> Font {
      Self.custom("FiraSans-Regular", size: size)
   }
   
   static func light(_ size: CGFloat) -> Font {
      Self.custom("FiraSans-Light", size: size)
   }
}
