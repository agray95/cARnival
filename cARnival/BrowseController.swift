//
//  BrowseController.swift
//  cARnival
//
//  Created by Aaron Gray on 6/21/18.
//  Copyright © 2018 Aaron Gray. All rights reserved.
//

import SceneKit
import ARKit

class BrowseController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView?
    var viewController: ViewController?
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~ANCHOR HANDLERS~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    let playButtonScale = SCNVector3(0.1, 0.1, 0.1)
    let playButtonDepthOffset: Float = 0.1
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor
        else { return }
        
        print("Adding image anchor!")
        
        let testPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        let testNode = SCNNode(geometry: testPlane)
        
        let activationButton = SCNScene(named: "art.scnassets/ActivateButton.scn")
        let buttonRootNode = activationButton?.rootNode
        buttonRootNode?.eulerAngles.x = -.pi/2
        buttonRootNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        buttonRootNode?.simdPosition = float3(node.simdPosition.x, node.simdPosition.y + 0.05, node.simdPosition.z + Float(imageAnchor.referenceImage.physicalSize.height/2/2))
        
        testNode.opacity = 0.25
        testNode.eulerAngles.x = -.pi/2
        
        node.addChildNode(testNode)
        node.addChildNode(buttonRootNode!)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor
        else { return }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor
        else { return }
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~INPUT HANDLERS~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func handleTap(_ location: CGPoint) {
        print("Tapping in Browse mode!")
        
        let hit = self.sceneView?.hitTest(location, types: [ARHitTestResult.ResultType.existingPlaneUsingGeometry])
        
        print(hit)
    }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~TRACKING HANDLERS~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    func enableTracking() {
//        let cfg = ARWorldTrackingConfiguration()
        let cfg = ARImageTrackingConfiguration()
        
        
//        Add poster images
        let testPoster = ARReferenceImage(UIImage(named: "testPoster")!.cgImage!, orientation: .up, physicalWidth: 0.73)

//        Add to cfg
//        cfg.detectionImages = [testPoster]
        cfg.trackingImages = [testPoster]
        
//        Run new session
        self.sceneView!.session.run(cfg, options: [.removeExistingAnchors])
    }
}
