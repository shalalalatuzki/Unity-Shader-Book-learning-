using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection2 : PostEffectBase2 {
	public Shader edgeDetectionShader;
	private Material edgeDetectionMaterial;
	public Material material{
		get{
			edgeDetectionMaterial=CheckShaderAndCreateMaterial(edgeDetectionShader,edgeDetectionMaterial);
			return edgeDetectionMaterial;
		}
	}
	[Range(0.0f,1.0f)]
	public float edgeOnly;
	public Color edgeColor;
	public Color backgroundColor;

	void OnRenderImage(RenderTexture src,RenderTexture dest)
	{
		if(material!=null){
			material.SetFloat("_EdgeOnly",edgeOnly);
			material.SetColor("_EdgeColor",edgeColor);
			material.SetColor("_BackgroundColor",backgroundColor);
			Graphics.Blit(src,dest,material);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
	
}
