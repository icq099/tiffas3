package yzhkof.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class CompatibleLoader extends Loader
	{
		protected var _content:DisplayObject;
		
		public function CompatibleLoader()
		{
			super();
		}
		protected function reInitLoader():void{
			try{
				removeChild(_content);
			}catch(e:Error){
			}
			_content=null;
		}
		public function loadUrl(url:Object):void{
			reInitLoader();			
			if(url is String){
				super.load(new URLRequest(String(url)));
			}else{
				if(url is DisplayObject){
					_content=url as DisplayObject;
					addChild(_content);
					contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
				}else if(url is BitmapData){
					_content=new Bitmap(BitmapData(url));
					addChild(_content);
					contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
				}else if(url is ByteArray){
					loadBytes(ByteArray(url));
				}else if(url is Loader){
					_content=url as Loader;
					addChild(_content);
					contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		public override function load(request:URLRequest, context:LoaderContext=null):void{
			reInitLoader();
			super.load(request,context);
		}
		public override function get contentLoaderInfo():LoaderInfo{
			return _content is Loader?Loader(_content).contentLoaderInfo:super.contentLoaderInfo;
		}
		public override function get content():DisplayObject{
			return _content==null?super.content:_content;
		}
	}
}