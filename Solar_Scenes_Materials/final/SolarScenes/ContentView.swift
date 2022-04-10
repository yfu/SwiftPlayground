/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import SceneKit

struct ContentView: View {
  // 1
  static func makeScene() -> SCNScene? {
    let scene = SCNScene(named: "Solar Scene.scn")
    applyTextures(to: scene)
    return scene
  }

  static func applyTextures(to scene: SCNScene?) {
    // 1
    for planet in Planet.allCases {
      // 2
      let identifier = planet.rawValue
      // 3
      let node = scene?.rootNode.childNode(withName: identifier, recursively: false)

      // Images courtesy of Solar System Scope https://bit.ly/3fAWUzi
      // 4
      let texture = UIImage(named: identifier)

      // 5
      node?.geometry?.firstMaterial?.diffuse.contents = texture
    }

    // 1
    let skyboxImages = (1...6).map { UIImage(named: "skybox\($0)") }
    // 2
    scene?.background.contents = skyboxImages
  }

  // 2
  var scene = makeScene()

  @ObservedObject var viewModel = ViewModel()

  var body: some View {
    ZStack {
      SceneView(
        // 1
        scene: scene,
        // 2
        pointOfView: setUpCamera(planet: viewModel.selectedPlanet),
        // 3
        options: viewModel.selectedPlanet == nil ? [.allowsCameraControl] : [])
        // 4
        .background(ColorPalette.secondary)
        .edgesIgnoringSafeArea(.all)

      VStack {
        if let planet = viewModel.selectedPlanet {
          VStack {
            PlanetInfoRow(title: "Length of year", value: planet.yearLength)
            PlanetInfoRow(title: "Number of moons", value: "\(planet.moonCount)")
            PlanetInfoRow(title: "Namesake", value: planet.namesake)
          }
          .padding(8)
          .background(ColorPalette.primary)
          .cornerRadius(14)
          .padding(12)
        }

        Spacer()

        HStack {
          HStack {
            Button(action: viewModel.selectPreviousPlanet) {
              Image(systemName: "arrow.backward.circle.fill")
            }
            Button(action: viewModel.selectNextPlanet) {
              Image(systemName: "arrow.forward.circle.fill")
            }
          }

          Spacer()
          Text(viewModel.title).foregroundColor(.white)
          Spacer()

          if viewModel.selectedPlanet != nil {
            Button(action: viewModel.clearSelection) {
              Image(systemName: "xmark.circle.fill")
            }
          }
        }
        .padding(8)
        .background(ColorPalette.primary)
        .cornerRadius(14)
        .padding(12)
      }
    }
  }

  func setUpCamera(planet: Planet?) -> SCNNode? {
    let cameraNode = scene?.rootNode.childNode(withName: "camera", recursively: false)

    // 1
    if let planetNode = planet.flatMap(planetNode(planet:)) {
      // 2
      let constraint = SCNLookAtConstraint(target: planetNode)
      cameraNode?.constraints = [constraint]
      // 3
      let globalPosition = planetNode.convertPosition(SCNVector3(x: 50, y: 10, z: 0), to: nil)
      // 4
      let move = SCNAction.move(to: globalPosition, duration: 1.0)
      cameraNode?.runAction(move)
    }

    return cameraNode
  }

  func planetNode(planet: Planet) -> SCNNode? {
    scene?.rootNode.childNode(withName: planet.rawValue, recursively: false)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
