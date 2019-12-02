using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyWhisperSource : MonoBehaviour {

	// Use this for initialization
	void Start () {
		// destroy the whisper source
		Destroy(GameObject.Find("WhisperSource"));
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
