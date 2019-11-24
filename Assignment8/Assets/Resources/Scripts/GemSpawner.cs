using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour {

	public GameObject[] prefabs;

	// Use this for initialization
	void Start () {

		// infinite gem spawning function, asynchronous
		StartCoroutine(SpawnGems());
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	IEnumerator SpawnGems() {
		while (true) {

			// instantiate a gem
			Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);

			// pause 10-50 seconds until the next gem spawns
			yield return new WaitForSeconds(Random.Range(10, 50));
		}
	}
}
