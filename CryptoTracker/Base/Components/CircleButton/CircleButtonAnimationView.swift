//
//  CircleButtonAnimationView.swift
//  CryptoTracker
//
//  Created by Maryam Kaveh on 11.co/23/1401 AP.
//

import SwiftUI

struct CircleButtonAnimationView: View {
  @Binding var animate: Bool
  
    var body: some View {
        Circle()
          .stroke(lineWidth: 5.8)
          .scaleEffect(animate ? 1.0 : 0.0)
          .opacity(animate ? 0.0 : 1.0)
          .animation(animate ?  Animation.easeOut(duration: 1.3) : nil , value: animate)
//          .padding()
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
      CircleButtonAnimationView(animate: .constant(false))
    }
}
