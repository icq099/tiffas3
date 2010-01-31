/*
 * Design by milkmidi
 * http://milkmidi.com
 * */
package lxfa.milkmidi.papervision3d.materials
{
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import lxfa.milkmidi.utils.BitmapUtil;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import lxfa.org.papervision3d.core.log.PaperLogger;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	
	public class ReflectionFileMaterial extends BitmapMaterial
	{		
		public var checkPolicyFile:Boolean = false;
		private var _url:String = "";
		public function ReflectionFileMaterial(url :String = "", precise:Boolean = false)		
		{		
			super( new BitmapData(10, 10, true, 0xeeeeee) , precise)		
			
			var _ldr:Loader = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete , false, 0, true);			
			_url = url;
			
			
			try {
				
			
				var loaderContext:LoaderContext = new LoaderContext();				
				loaderContext.checkPolicyFile = checkPolicyFile;				
			
				_ldr.load(new URLRequest(_url), loaderContext);							
			}catch (e:Error){
				
			}
		}
		
		private function onLoaderComplete(e:Event):void {
			
			
			var _ldr:Loader = Loader( e.target.loader );
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);				
			var _bitmapData	:BitmapData = Bitmap( _ldr.content ).bitmapData;			
			var _refBMP		:BitmapData = BitmapUtil.reflect(_bitmapData);
			var _joinBMP	:BitmapData = BitmapUtil.mergeBitmap(_bitmapData, _refBMP);			
			_ldr.unload();
			_ldr = null;
			_refBMP.dispose();
			_bitmapData.dispose();
			this.texture = _joinBMP;
			var fileEvent:FileLoadEvent = new FileLoadEvent( FileLoadEvent.LOAD_COMPLETE, _url );			
			this.dispatchEvent( fileEvent );
			PaperLogger.info( "ReflectionFileMaterial: Loading bitmap from " + _url );
		}
		
		
	
		
		
		
	}
}
