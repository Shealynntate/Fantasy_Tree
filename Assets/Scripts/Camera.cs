
// Basic FPS movement script for Unity

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

public class Camera : MonoBehaviour 
{
	public float MoveSpeed = 10;
	public float MouseSensitivity = 10;

	Quaternion viewRotation;
	float beatTimer;

	void Start()
	{
		viewRotation = new Quaternion();
		Cursor.visible = false;
	}

	void Update()
	{
		beatTimer += Time.deltaTime * 0.5f;

		if (beatTimer > 0.5f)
			beatTimer = 0;

		InputUpdate();
	}

	void InputUpdate()
	{
		Vector3 rotation = transform.localEulerAngles;
		viewRotation = Quaternion.Euler(0, rotation.y, 0);

		// Key Inputs
		Vector3 position = new Vector3();
		float moveAmount = MoveSpeed * Time.deltaTime;

		if (Input.GetKey(KeyCode.W))
			position.z += moveAmount;
		if (Input.GetKey(KeyCode.S))
			position.z -= moveAmount;
		if (Input.GetKey(KeyCode.A))
			position.x -= moveAmount;
		if (Input.GetKey(KeyCode.D))
			position.x += moveAmount;
		
		transform.position = viewRotation * position + transform.position;

		// Mouse Input
		float deltaX = Input.GetAxis("Mouse X") * MouseSensitivity;
		float deltaY = Input.GetAxis("Mouse Y") * MouseSensitivity;

		rotation.y += deltaX;
		rotation.x -= deltaY;

		transform.localEulerAngles = rotation;
	}
}
