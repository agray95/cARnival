//
//  ViewController.swift
//  cARnival
//
//  Created by Aaron Gray on 6/21/18.
//  Copyright © 2018 Aaron Gray. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~GAME STATE~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    enum GameState {
        case Browse
        case Play
    }

    var currentGameState: GameState = GameState.Browse
    
    func enableBrowseState(withTracking: Bool = true) {
        print("Enabling BROWSE state")
        
        if withTracking {
            self.browseController.enableTracking()
        }
        
        self.currentGameState = GameState.Browse
        self.sceneView.delegate = self.browseController
    }
    
    func enablePlayState(withTracking: Bool = true) {
        print("Enabling PLAY state")
        
        if withTracking {
            self.playController.enableTracking()
        }
        
        self.currentGameState = GameState.Play
        self.sceneView.delegate = self.playController
    }
    
    func toggleGameState() {
        self.currentGameState = self.currentGameState == GameState.Play ? GameState.Browse : GameState.Play
        
        switch self.currentGameState {
            case GameState.Browse:
                self.enableBrowseState()
                break
            case GameState.Play:
                self.enablePlayState()
                break
        }
    }
    
    func prepareGameForActivation(posterAnchor: ARAnchor, postersize: CGSize){
        enablePlayState()
        self.playController.spawnActivationPlane(anchor: posterAnchor, posterSize: postersize)
    }
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~SESSION HANDLING~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    @IBOutlet var sceneView: ARSCNView!
    
    let browseController: BrowseController = BrowseController()
    let playController: PlayController = PlayController()
    
    let planeDetectionTypes: ARWorldTrackingConfiguration.PlaneDetection = [.vertical]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Inject sceneView into controllers
        browseController.sceneView = self.sceneView
        playController.sceneView = self.sceneView
        
        browseController.viewController = self
        playController.viewController = self
        
//        Add tap handler
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(rec:)))
        self.sceneView.addGestureRecognizer(tapRecognizer)
        
//        Add swipe handler
//        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(handleSwipe(rec:)))
//        swipeRecognizer.direction = [.up]
//        self.sceneView.addGestureRecognizer(swipeRecognizer)
        
//        Add pan handler (hehe)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(rec:)))
        self.sceneView.addGestureRecognizer(panRecognizer)
        
        // Set the view's delegate to appropriate controller for handling anchors
        switch self.currentGameState {
            case GameState.Browse:
                self.enableBrowseState()
                break
            case GameState.Play:
                self.enablePlayState()
                break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~INPUT HANDLING~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    @objc func handleTap(rec: UITapGestureRecognizer) {
        if rec.state != .ended {
            return
        }
        
//        *******TESTING*******
//        toggleGameState()
        
        switch self.currentGameState {
            case GameState.Browse:
                self.browseController.handleTap(rec.location(in: self.sceneView))
                break
            case GameState.Play:
                self.playController.handleTap(rec.location(in: self.sceneView))
                break
        }
        
    }
    
    @objc func handleSwipe(rec: UISwipeGestureRecognizer) {
        print(rec)
        
        switch self.currentGameState {
            case GameState.Browse:
                self.browseController.handleSwipe()
                break
            case GameState.Play:
                self.playController.handleSwipe()
                break
        }
    }
    
    @objc func handlePan(rec: UIPanGestureRecognizer) {
        print(rec)
        print(rec.translation(in: self.sceneView))
        print(rec.velocity(in: self.sceneView))
        print("----------")
    }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~ANCHOR MGMT~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    var anchors: [ARAnchor] = [ARAnchor]()
    
    func addAnchor(_ anchor: ARAnchor) {
        self.anchors.append(anchor)
    }

}
