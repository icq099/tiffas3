package milkmidi.papervision3d{
	import flash.display.*;
	import flash.events.*;
	import org.papervision3d.core.geom.renderables.*;
	import org.papervision3d.materials.special.*;
	import org.papervision3d.core.geom.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.primitives.Plane;

	public class Trident3D extends DisplayObject3D
	{
		// _______________________________________________________________________
		//                                                                  vars3D
		private var _lineLength:uint;		
		// _______________________________________________________________________
		//                                                             Constructor
		public function Trident3D( lineLength:uint = 1600 , showLetters:Boolean = false ,visiblePlane:Boolean = false):void{			
			_lineLength = lineLength;	
			if (visiblePlane) {				
				var planeX	 :Plane	 = new Plane(createMaterial(0xff0000), _lineLength, _lineLength, 1, 1 );
				var planeY   :Plane  = new Plane(createMaterial(0x00ff00), _lineLength, _lineLength, 1, 1 );
				var planeZ   :Plane  = new Plane(createMaterial(0x0000ff), _lineLength, _lineLength, 1, 1 );
				planeX.rotationX 	 = 90;
				planeZ.rotationY 	 = 90;				
				this.addChild(planeX, 'planeX');								
				this.addChild(planeY, 'planeY');								
				this.addChild(planeZ, 'planeZ');				
			}
			var lineMat:LineMaterial = new LineMaterial(0x00FF00, 1);
			var linez:Lines3D = new Lines3D(lineMat, "Trident3DLines");
			this.addChild(linez, "linez");			
			
			
			//X
			var lineMatX:LineMaterial = new LineMaterial(0xff0000, .4);
			linez.addLine(new Line3D(linez, lineMatX, 3, new Vertex3D(_lineLength/-2, 0, 0), new Vertex3D(_lineLength/2, 0, 0)));
			
			//Y
			var lineMatY:LineMaterial = new LineMaterial(0x00ff00, .4);
			linez.addLine(new Line3D(linez, lineMatY, 3, new Vertex3D(0, _lineLength/-2, 0), new Vertex3D(0, _lineLength/2, 0)));
			
			//Z
			var lineMatZ:LineMaterial = new LineMaterial(0x0000ff, .4);
			linez.addLine(new Line3D(linez, lineMatZ, 3, new Vertex3D(0, 0, _lineLength/-2), new Vertex3D(0, 0, _lineLength/2)));
			
			
			
			
			var scaleH:Number = _lineLength / 10;			
			var scaleW:Number = _lineLength / 20;			
			var offset:Number = _lineLength + scaleW;			
			
			if (showLetters) {
				//x
				var scl15:Number = scaleW * 1.5;				
				var sclh3:Number = scaleH * 3;				
				var sclh2:Number = scaleH * 2;				
				var sclh34:Number = scaleH * 3.4;				
				linez.addLine(new Line3D(linez, lineMatX, 3, new Vertex3D(_lineLength + sclh3, scl15 , 0),new Vertex3D(_lineLength + sclh2, -scl15 , 0)));
				linez.addLine(new Line3D(linez, lineMatX, 3,  new Vertex3D(_lineLength + sclh2, scl15 , 0), new Vertex3D(_lineLength + sclh3, -scl15 , 0)));				
				
				//y				
				var cross:Number = _lineLength + (sclh2) + (  ((_lineLength + sclh34) - (_lineLength + sclh2)) / 3  * 2);
				linez.addLine(new Line3D(linez, lineMatY, 3, new Vertex3D( -scaleW * 1.2, _lineLength + sclh34, 0), new Vertex3D( 0, cross, 0)));				
				linez.addLine(new Line3D(linez, lineMatY, 3, new Vertex3D(scaleW * 1.2, _lineLength + sclh34, 0), new Vertex3D(  0, cross, 0)));
				linez.addLine(new Line3D(linez, lineMatY, 3, new Vertex3D( 0, cross, 0), new Vertex3D(0, _lineLength+sclh2, 0)));				
				
				//Z				
				linez.addLine(new Line3D(linez, lineMatZ, 3, new Vertex3D( 0, scl15, _lineLength+sclh3), new Vertex3D( 0, -scl15, _lineLength+sclh2)));				
				linez.addLine(new Line3D(linez, lineMatZ, 3, new Vertex3D( 0, scl15, _lineLength + sclh2), new Vertex3D(0, -scl15, _lineLength + sclh3)));					
				linez.addLine(new Line3D(linez, lineMatZ, 3, new Vertex3D( 0, -scl15, _lineLength + sclh2), new Vertex3D(0, scl15, _lineLength + sclh3)));									
				
				
			}
			
		}
		private function createMaterial(colorUint:uint):ColorMaterial{			
			var _colorMat :ColorMaterial = new ColorMaterial( colorUint , .1);			
			_colorMat.doubleSided = true;
			_colorMat.smooth = false;
			_colorMat.interactive = false;
			return _colorMat;
		}


	}
}