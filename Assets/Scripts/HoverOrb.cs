
// Floating orb script with randomized start times for Unity

// Copyright (c) 2017 Shealyn Hindenlang

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoverOrb : MonoBehaviour 
{
	public float Speed = 0.75f;

	Vector3 origin;
	Material material;
	float offset;
	bool isFloating;

	void Start() 
	{
		offset = 0;
		isFloating = false;
		origin = transform.position;	

		material = GetComponent<MeshRenderer>().material;

		StartCoroutine("Delay");
	}
	
	void Update() 
	{
		if (isFloating)
		{
			offset += Time.deltaTime * Speed;

			if (offset > 2.8f)
			{
				offset = 0;
				isFloating = false;
				StartCoroutine("Delay");
			}
			else
			{
				material.SetFloat("_EffectRadius", origin.y + offset - 2);

				Vector3 pos = transform.position;
				pos.y = origin.y + offset;
				transform.position = pos;
			}
		}
	}

	IEnumerator Delay()
	{
		float delayTime = Random.Range(0.5f, 10f);
		float time = 0;

		while (time < delayTime)
		{
			time += Time.deltaTime;
			yield return null;
		}

		isFloating = true;
	}
}
