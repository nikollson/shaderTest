using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshMaker : MonoBehaviour {


	MeshFilter _meshFilter;
	
	public void Start ()
	{
		_meshFilter = GetComponent<MeshFilter>();
		
	}
	
	
}
