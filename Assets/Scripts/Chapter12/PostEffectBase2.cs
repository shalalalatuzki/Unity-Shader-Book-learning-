using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectBase2 : MonoBehaviour {

	// Use this for initialization
	protected void checkResources(){
		bool isSupported=checkSupport();
		if(isSupported==false){
			NotSupport();
		}
	}
	protected void NotSupport(){
		enabled=false;
	}
	protected bool checkSupport(){
		if(SystemInfo.supportsImageEffects==false||SystemInfo.supportsRenderTextures==false){
				print("can't render image effect or textures");
				return false;
		}
		return true;
	}
	protected void Start () {
		checkResources();
	}
	
	// Update is called once per frame
	protected Material CheckShaderAndCreateMaterial(Shader shader,Material material){
		if(shader==null){
			return null;
		}
		if(shader.isSupported&&material&&material.shader==shader){
			return material;
		}
		else{
			material=new Material(shader);
			material.hideFlags=HideFlags.DontSave;
			if(material){
				return material;
			}	
			return null;
		}
	}
}
