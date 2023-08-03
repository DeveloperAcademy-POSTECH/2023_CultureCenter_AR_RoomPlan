//
//  SceneViewController.swift
//  RoomPlanExampleApp
//
//  Created by Yun Dongbeom on 2023/08/01.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RoomPlan

class SceneViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    var finalResults: CapturedRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView = ARSCNView(frame : self.view.frame)
        self.view.addSubview(sceneView)
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()

        sceneView.scene = scene
        onModelReady(model: finalResults!)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - 룸 플랜 데이터를 가져와서 Scene에 추가
    private func onModelReady(model: CapturedRoom) {
           let walls = getAllNodes(for: model.walls,length: 0.01, contents: UIImage(named: "wall.jpg"))
           walls.forEach { sceneView?.scene.rootNode.addChildNode($0) }
        
           let doors = getAllNodes(for: model.doors, length: 0.011, contents: UIImage(named: "door.jpeg"))
           doors.forEach { sceneView?.scene.rootNode.addChildNode($0) }
        
           let windows = getAllNodes(for: model.windows, length: 0.011, contents: UIImage(named: "window.jpg"))
           windows.forEach { sceneView?.scene.rootNode.addChildNode($0) }
        
           let openings = getAllNodes(for: model.openings, length: 0.011, contents: UIColor.blue.withAlphaComponent(0.5))
           openings.forEach { sceneView?.scene.rootNode.addChildNode($0) }
//
//        getAllRoomObjectsCategory().forEach { category in
//                   let scannedObjects = model.objects.filter { $0.category == category }
//                   let objectsNode = getAllNodes(for: scannedObjects, category: category)
//                   objectsNode.forEach { sceneView?.scene?.rootNode.addChildNode($0) }
//               }
       }
    
    private func getAllNodes(for surfaces: [CapturedRoom.Surface], length: CGFloat, contents: Any?) -> [SCNNode] {
        var nodes: [SCNNode] = []
        surfaces.forEach { surface in
            let width = CGFloat(surface.dimensions.x)
            let height = CGFloat(surface.dimensions.y)
            let node = SCNNode()
            node.geometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0.0)
            node.geometry?.firstMaterial?.diffuse.contents = contents
            node.transform = SCNMatrix4(surface.transform)
            nodes.append(node)
        }
        return nodes
    }

}

