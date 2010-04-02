package lxfa.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ModelManager extends EventDispatcher
	{
		private static var instance:ModelManager;
		private var _xmlData:XML;
		private var xmlLoader:URLLoader;
		private var xmlRequest:URLRequest;
		public function ModelManager()
		{
			if(instance==null){
				super(this);
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
			init();
		}
		private function init():void
		{
			xmlRequest=new URLRequest("xml/item.xml");
			xmlLoader=new URLLoader(xmlRequest);
			xmlLoader.addEventListener(Event.COMPLETE,function(e:Event):void{
				_xmlData=XML(URLLoader(e.currentTarget).data);
				ModelManager.getInstance().dispatchEvent(e);
			});
		}
		public function xmlData():XML
		{
			return _xmlData;
		}
		public static function getInstance():ModelManager{
			if(instance==null) instance=new ModelManager();
			return instance;
		}
	}
}