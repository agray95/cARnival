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
        print(imageAnchor.transform.columns.2)
        print(imageAnchor.referenceImage.physicalSize)
        
        print("lol?")
        let x = imageAnchor.transform.columns.2.x * Float(imageAnchor.referenceImage.physicalSize.width)
        print(x)
        
        let testPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        let testNode = SCNNode(geometry: testPlane)
        
        let activationButton = SCNScene(named: "art.scnassets/ActivateButton.scn")
        let buttonRootNode = activationButton?.rootNode
        buttonRootNode?.eulerAngles.x = -.pi/2
        buttonRootNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        buttonRootNode?.simdPosition = float3(node.simdPosition.x, node.simdPosition.y + 0.05, node.simdPosition.z + Float(imageAnchor.referenceImage.physicalSize.height/2/2))
        
        testNode.opacity = 0.25
        testNode.eulerAngles.x = -.pi/2
        
        spawnTestBooth(node: node, imageSize: imageAnchor.referenceImage.physicalSize)
        
//        node.addChildNode(testNode)
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
        print("REMOVING ANCHOR")
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~INPUT HANDLERS~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func handleTap(_ location: CGPoint) {
        print("Tapping in Browse mode!")
        
        let hit = self.sceneView?.hitTest(location, types: [ARHitTestResult.ResultType.existingPlaneUsingGeometry])
        
        print(hit)
    }
    
    func handleSwipe() {
        
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

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~GAME HANDLERS~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    enum OccluderPosition {
        case Top
        case Bottom
        case Left
        case Right
    }
    
    func spawnTestBooth(node: SCNNode, imageSize: CGSize) {
//        Booth testing
        let booth = SCNScene(named: "art.scnassets/booth.scn")
        let boothNode = booth?.rootNode
        boothNode?.simdPosition = float3(node.simdPosition.x, node.simdPosition.y, node.simdPosition.z)
        boothNode?.eulerAngles.x = -.pi/2
        
//        Occluders should be added before scene
        spawnFrameOccluders(imageSize: imageSize, rootNode: node)
        
        node.addChildNode(boothNode!)
    }
    
//    Spawn all occluders for given frame
    func spawnFrameOccluders(imageSize: CGSize, rootNode: SCNNode){
        spawnOccluder(.Top, imageSize: imageSize, rootNode: rootNode)
        spawnOccluder(.Bottom, imageSize: imageSize, rootNode: rootNode)
        spawnOccluder(.Left, imageSize: imageSize, rootNode: rootNode)
        spawnOccluder(.Right, imageSize: imageSize, rootNode: rootNode)
        
    }
    
//    Spawn an occluder relative to the current frame
    func spawnOccluder(_ type: OccluderPosition, imageSize: CGSize, rootNode: SCNNode) {
        var occluderPlane: SCNPlane
        let rootPosition = rootNode.simdPosition

        switch type {
            case OccluderPosition.Top, OccluderPosition.Bottom:
                occluderPlane = SCNPlane(width: imageSize.width * 7.0, height: imageSize.height * 3.0)
                break
            case OccluderPosition.Left, OccluderPosition.Right:
                occluderPlane = SCNPlane(width: imageSize.width * 3.0, height: imageSize.height)
                break
        }
        
        let occluderNode = SCNNode(geometry: occluderPlane)
        
        occluderPlane.materials.first?.colorBufferWriteMask = []
        
        switch type {
            case OccluderPosition.Top:
                occluderNode.simdPosition = float3(rootPosition.x, rootPosition.y, rootPosition.z - Float(imageSize.height * 2.0))
                break
            case OccluderPosition.Bottom:
                occluderNode.simdPosition = float3(rootPosition.x, rootPosition.y, rootPosition.z + Float(imageSize.height * 2.0))
                break
            case OccluderPosition.Left:
                occluderNode.simdPosition = float3(rootPosition.x - Float(imageSize.width * 2.0), rootPosition.y, rootPosition.z)
                break
            case OccluderPosition.Right:
                occluderNode.simdPosition = float3(rootPosition.x + Float(imageSize.width * 2.0), rootPosition.y, rootPosition.z)
                break
        }
        
        occluderNode.eulerAngles.x = -.pi/2
        
        rootNode.addChildNode(occluderNode)
    }
}
