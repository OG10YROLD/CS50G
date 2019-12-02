using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnFall : MonoBehaviour {

	public int yToFallBelow;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (transform.position.y < yToFallBelow) {

			// reset the maze number
			LevelGenerator.mazeNumber = 1;

			// we load the game over scene
			SceneManager.LoadScene("Over");
		}
	}
}
