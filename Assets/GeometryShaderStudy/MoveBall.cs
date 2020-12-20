using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveBall : MonoBehaviour
{


	public float LoopTime = 2;

	public Vector3 Move1 = Vector3.forward;

	public Vector3 Move2 = Vector3.right;


	public void Update()
	{
		float AllTime = LoopTime * 4;
		float MovePar = (Time.time / AllTime) - Mathf.Floor(Time.time / AllTime);

		if (MovePar < 0.25)
		{
			transform.position += Move1 * Time.deltaTime / LoopTime;

		}else if (MovePar < 0.5)
		{
			transform.position += Move2 * Time.deltaTime / LoopTime;
		}else if (MovePar < 0.75)
		{
			transform.position -= Move1 * Time.deltaTime / LoopTime;
		}
		else
		{
			transform.position -= Move2 * Time.deltaTime / LoopTime;
		}

	}
	
}
