using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GussianBlur : PostEffectBase2{
	public Shader gaussianBlurShader;
	private Material gaussianBlurMaterail;
	public Material material{
		get{
			gaussianBlurMaterail=CheckShaderAndCreateMaterial(gaussianBlurShader,gaussianBlurMaterail);
			return gaussianBlurMaterail;
		}
	}
	[Range(0,4)]
	public int iterators=3;
	[Range(0.2f,3.0f)]
	public float blurSpread=0.6f;
	[Range(1,8)]
	public int downSample=2;
	 void OnRenderImage(RenderTexture src,RenderTexture dest)
	{
		if(material!=null){
			//申请缓冲空间
			int rtW=src.width/downSample;
			int rtH=src.height/downSample;
			RenderTexture buffer0=RenderTexture.GetTemporary(rtW,rtH,0);
			buffer0.filterMode=FilterMode.Bilinear;
			
			for(int i=0;i<iterators;i++){
			material.SetFloat("_BlurSize",1.0f+i*blurSpread);
            //第一次水平高斯核卷积
			RenderTexture buffer1=RenderTexture.GetTemporary(rtW,rtH,0);
			Graphics.Blit(buffer0,buffer1,material,0);
			RenderTexture.ReleaseTemporary(buffer0);
			
			buffer0=buffer1;
			buffer1=RenderTexture.GetTemporary(rtW,rtH,0);
			Graphics.Blit(buffer0,buffer1,material,1);
			RenderTexture.ReleaseTemporary(buffer0);
			buffer0=buffer1;
			// Graphics.Blit(src,buffer0,material,0);
			// //垂直高斯核卷积
			// Graphics.Blit(buffer0,dest,material,1);
			}
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
