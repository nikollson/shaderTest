using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyImageEffect : MonoBehaviour
{
	[SerializeField]
	Material mat;
	
	void OnEnable() {
		Camera.main.depthTextureMode = DepthTextureMode.Depth;
	}

	void  OnRenderImage(RenderTexture src,RenderTexture dis)
	{
		Graphics.Blit(src,dis,mat);
	}
}