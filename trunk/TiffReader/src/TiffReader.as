package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import tiff.Tiff;
	
	import yzhkof.BasicAsProject;
	import yzhkof.EfficiencyTestor;
	import yzhkof.tiff.TiffAnalyser;
	import yzhkof.tiff.TiffDecoder;

	public class TiffReader extends BasicAsProject
	{
		private var loader:URLLoader; 
		public function TiffReader()
		{
			//loader=new URLLoader(new URLRequest("real.tiff"));
			//loader=new URLLoader(new URLRequest("photo.tif"));
			//loader=new URLLoader(new URLRequest("test.tif"));
			//loader=new URLLoader(new URLRequest("testTXD.tif"));
			loader=new URLLoader(new URLRequest("g:\aa.tiff"));//读取图片
			//loader=new URLLoader(new URLRequest("g3.tif"));
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			//loader.load();
			//loader.addEventListener(Event.COMPLETE,complete);
			loader.addEventListener(Event.COMPLETE,shownew);
		}
		private function shownew(e:Event):void{
			
			var byte:ByteArray=loader.data;
			var t:Tiff=new Tiff;
			t.read(byte);
			//trace(t.getImage(0));
			var d:DisplayObject
			EfficiencyTestor.efficiencyOfFunctionTraceFormat(function():void{
				
				d=new Bitmap(t.getImage(1));//获得第二分页的图片
			
			});
			//d.scaleX=d.scaleY=0.2
			addChild(d);
		}
		private function onComplete(e:Event):void{
			
			var byte:ByteArray=loader.data;
			byte.endian=Endian.LITTLE_ENDIAN;
			//var order:String;	
			var byte_t:ByteArray=new ByteArray();
			
			//order=byte.readMultiByte(2,"utf-8");
			//1728*2352,582*516
			trace(byte.length,582*516)
			byte.position=8;
			byte.readBytes(byte_t,0,582*516);
			var b:BitmapData=new BitmapData(582,516);
			b.setPixels(new Rectangle(582,516),byte_t);
			addChild(new Bitmap(b));
			
			//trace(byte.readShort(),byte.position);
			//trace(byte.position=byte.readUnsignedInt(),byte.length);
			//trace(byte.readUnsignedShort());
			//byte.endian=Endian.BIG_ENDIAN;
			
			//trace(byte.readUnsignedShort(),byte.readUnsignedShort(),byte.readInt(),byte.readInt())
			/* var bytet:ByteArray=new ByteArray();
			bytet.writeShort(42);
			bytet.position=0;
			var a:ByteArray=new ByteArray();
			var b:ByteArray=new ByteArray();
			bytet.readBytes(b,0,1);
			bytet.readBytes(a,0,1);
			var r:ByteArray=new ByteArray();
			a.position=0;
			b.position=0;
			r.writeBytes(a,0,1);
			r.writeBytes(b,0,1);
			r.position=0;
			trace(r.readShort()); */
			//trace(bytet.readShort()); 
			//byte.readBytes(byte_version,0,2);
		}
		private function complete(e:Event):void{
			
			var byte:ByteArray=loader.data;
			var t:TiffAnalyser=new TiffAnalyser(byte);
			EfficiencyTestor.efficiencyOfFunctionTraceFormat(function():void{
			
			trace(t.compress,t.getIFDcount(3),t.stripOffsets,byte.length,t.IFDOffset,t.width*t.height,t.bitsPerSample,t.compress,"##",t.tagArray)}
			
			)
		
		}
		private function show(e:Event):void{
			
			var byte:ByteArray=loader.data;
			var de:TiffDecoder=new TiffDecoder(byte);
			addChild(new Bitmap(de.bitmapdata));
		
		}
	}
}
