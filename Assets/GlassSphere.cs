using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

[ExecuteInEditMode]
public class GlassSphere : MonoBehaviour
{
	void Update ()
	{
		var _meshRenderer = this.GetComponent<MeshRenderer>();
		
		var screenPos = Camera.main.WorldToViewportPoint(this.transform.position);

		_meshRenderer.material.SetFloat("_CenterX", screenPos.x);
		_meshRenderer.material.SetFloat("_CenterY", screenPos.y);
	}
}

