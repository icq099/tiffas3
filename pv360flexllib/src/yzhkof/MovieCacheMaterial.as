package yzhkof
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.core.render.draw.ITriangleDrawer;
	import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
	import org.papervision3d.materials.MovieMaterial;

	public class MovieCacheMaterial extends MovieMaterial implements ITriangleDrawer, IUpdateBeforeMaterial
	{
		private var movieAsset:MovieClip;
		private var cache:Array = [];
		private var materialIsDrawn:Boolean = false;
		
		public function MovieCacheMaterial( movieAsset:MovieClip=null, transparent:Boolean=false, animated:Boolean=false, precise:Boolean=false, rect:Rectangle=null )
		{
			this.movieAsset = movieAsset;
			super(movieAsset, transparent, animated, precise, rect);
			
			if(!movieCache[movieAsset]){
				cache = new Array();
				movieCache[movieAsset] = cache;
				
			}else{
				cache = movieCache[movieAsset];
			}
			
		}
		
		
		private var completeHandler:Function;
		private var fr:Number = 0;
		
		private var useCached:Boolean = false;
		
		public override function updateBeforeRender(renderSessionData:RenderSessionData):void
		{
			materialIsDrawn = false;
			useCached = (cache[movieAsset.currentFrame-1] != null);
			if(useCached){
				bitmap = cache[movieAsset.currentFrame-1];
			}else{
				
				super.updateBeforeRender(renderSessionData);
				
				cache[movieAsset.currentFrame-1] = getNewCachedBitmap();
			}
		}
		
		private function getNewCachedBitmap():BitmapData{
			var bmp:BitmapData = new BitmapData(bitmap.width, bitmap.height, this.movieTransparent, this.fillColor);
				bmp.copyPixels(bitmap, bitmap.rect, new Point());
				return bmp;
		}
		
		override public function drawTriangle(face3D:Triangle3D, graphics:Graphics, renderSessionData:RenderSessionData, altBitmap:BitmapData = null, altUV:Matrix = null):void
		{
			materialIsDrawn = true;
			super.drawTriangle(face3D,graphics,renderSessionData,altBitmap,altUV);
		}
		
		protected static var movieCache:Dictionary = new Dictionary(true);
		
	}
}