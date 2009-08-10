/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
 */

/*
 * Copyright 2006 (c) Carlos Ulloa Matesanz, noventaynueve.com.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

// _______________________________________________________________________ FREECAMERA3D

package org.papervision3d.cameras{
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	* The FreeCamera3D class creates a camera that views the area in the direction the camera is aimed.
	* <p/>
	* A camera defines the view from which a scene will be rendered. Different camera settings would present a scene from different points of view.
	* <p/>
	* 3D cameras simulate still-image, motion picture, or video cameras of the real world. When rendering, the scene is drawn as if you were looking through the camera lens.
	*/
	public class FreeCamera3D extends CameraObject3D {

		public static  const TYPE:String = "FREECAMERA3D";
		// ___________________________________________________________________ NEW

		// NN  NN EEEEEE WW    WW
		// NNN NN EE     WW WW WW
		// NNNNNN EEEE   WWWWWWWW
		// NN NNN EE     WWW  WWW
		// NN  NN EEEEEE WW    WW

		/**
		* The FreeCamera3D constructor lets you create a camera that views the area in the direction the camera is aimed.
		*
		* Its initial position can be specified in the initObject.
		*
		* @paramzoomThis value specifies the scale at which the 3D objects are rendered. Higher values magnify the scene, compressing distance. Use it in conjunction with focus.
		* <p/>
		* @paramfocusThis value is a positive number representing the distance of the observer from the front clipping plane, which is the closest any object can be to the camera. Use it in conjunction with zoom.
		* <p/>
		* @paraminitObjectAn optional object that contains user defined properties with which to populate the newly created DisplayObject3D.
		* <p/>
		* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined extra object.
		* <p/>
		* If extra is not an object, it is ignored. All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
		* <p/>
		* The following initObject property is also recognized by the constructor:
		* <ul>
		* <li><b>sort</b>: A Boolean value that determines whether the 3D objects are z-depth sorted between themselves when rendering. The default value is true.</li>
		* </ul>
		*/
		public function FreeCamera3D( zoom:Number=2, focus:Number=100, initObject:Object=null ) {
			super( zoom, focus, initObject );
		}

		/**
		* [internal-use] Transforms world coordinates into camera space.
		*/
		// TODO OPTIMIZE (LOW)
		public override function transformView( transform:Matrix3D=null ):void {
			if ( this._transformDirty ) {
				updateTransform();
			}

			// Rotate Z
			super.transformView();
		}
		///-flab3d.com-18/11/08,绕Y轴旋转的类//////////////////////////////
		///第一个参数是摄像机看着的物体，第二个参数是每祯旋转度数；第三个参数摄像机是离物体的距离，第四个是摄像机的高度

		private var angled:Number=0;

		public function orbitY(do3d:DisplayObject3D=null,angelIncrease:Number=1,distance:int=1000,heightY:Number=0):void {
			this.lookAt(do3d);

			var radius:int=distance;
			angled+=angelIncrease;


			var ss:Number = angled*Math.PI/180;
			//var zz:Number = radius*Math.PI/180;


			this.x = do3d.x + radius * Math.sin(ss);
			this.y=do3d.y+heightY;
			//this.y = do3d.x + radius * Math.cos(zz) * Math.sin(ss);
			this.z = do3d.z + radius * Math.cos(ss);
		}
		/////////////////////////////////////////////
	}
}