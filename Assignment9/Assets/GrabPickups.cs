using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	private AudioSource pickupSoundSource;

	public GameObject dungeonGenerator;

	// used to prevent problems with multiple collisions
	private bool isColliding = false;

	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void Update() {
		isColliding = false;
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Pickup" && !isColliding) {
			// we can't collide more than once
			isColliding = true;

			LevelGenerator.mazeNumber += 1;
			pickupSoundSource.Play();
			SceneManager.LoadScene("Play");
		}
	}
}
