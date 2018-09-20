using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour {
	public Transform SphereRotation;
	// Use this for initialization
	void Start () {
		SphereRotation=this.GetComponent<Transform>();
	}
	
	// Update is called once per frame
	void Update () {
		SphereRotation.Rotate(Vector3.up*0.3f);
		SphereRotation.Rotate(Vector3.forward*0.3f);
	}
}
