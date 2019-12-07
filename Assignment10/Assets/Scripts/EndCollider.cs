using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndCollider : MonoBehaviour {

	public GameObject endText;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	void OnTriggerEnter() {
		Color color = endText.GetComponent<Text>().color;
		color.a = 1;
		endText.GetComponent<Text>().color = color;
	}
}
