using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SinMove : MonoBehaviour
{

	public Vector2 Move = new Vector2(1, 0);
	public float LoopTime = 3;
	
	void Update ()
	{
		transform.position += (Vector3)Move * Mathf.Cos(Time.time/LoopTime * Mathf.PI) * Time.deltaTime;
	}
}
