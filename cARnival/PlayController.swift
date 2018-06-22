//
//  PlayController.swift
//  cARnival
//
//  Created by Aaron Gray on 6/21/18.
//  Copyright © 2018 Aaron Gray. All rights reserved.
//

import SceneKit
import ARKit

class PlayController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView?
    var viewController: ViewController?
    
    var windowSize: CGSize?
    
    var sceneRootAnchor: ARAnchor?
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~ANCHOR HANDLERS~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard
            let planeAnchor = anchor as? ARPlaneAnchor
        else { return }

    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let planeAnchor = anchor as? ARPlaneAnchor
        else { return }
        
        guard
            let centerIndicator: SCNNode = node.childNodes[0],
            let extentIndicator: SCNNode = node.childNodes[1],
            let extentPlane = extentIndicator.geometry as? SCNPlane
        else { return }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard
            let planeAnchor = anchor as? ARPlaneAnchor
        else { return }
    }
    
    func spawnActivationPlane(anchor: ARAnchor, posterSize: CGSize){
        self.windowSize = posterSize
        self.sceneRootAnchor = anchor
        
        self.sceneView?.session.add(anchor: anchor)
        
    }
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~INPUT HANDLERS~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func handleTap(_ location: CGPoint) {
        print("Tapping in Play mode!")
        disablePlaneDetection()
    }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~TRACKING HANDLERS~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    let planeDetectionTypes: ARWorldTrackingConfiguration.PlaneDetection = [.vertical]

    func enableTracking() {
        let cfg = ARWorldTrackingConfiguration()
        
//        Add plane detection types
        cfg.planeDetection = self.planeDetectionTypes
        
//        Run new session
//        self.sceneView!.session.run(cfg, options: [.removeExistingAnchors])
        self.sceneView!.session.run(cfg)
    }
    
//    Restart session w/ no plane detection
    func disablePlaneDetection() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = []
        
        self.sceneView?.session.run(config)
        
    }
}
