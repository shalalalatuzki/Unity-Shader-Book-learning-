using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrightnessSturationAndContrast2 :PostEffectBase2 {
	public Shader BriSatConShader;
	private Material BriSatConMaterial;
	public  Material material{
		get{
			BriSatConMaterial=CheckShaderAndCreateMaterial(BriSatConShader,BriSatConMaterial);
			return BriSatConMaterial;
		}
	}
	public float brightness=1.0f;
	public float saturation=1.0f;
	public float contrast=1.0f;

	void OnRenderImage(RenderTexture src,RenderTexture dest)
	{
		if(material!=null){
			material.SetFloat("_Brightness",brightness);
			material.SetFloat("_Saturation",saturation);
			material.SetFloat("_Contrast",contrast);
			Graphics.Blit(src,dest,material);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
