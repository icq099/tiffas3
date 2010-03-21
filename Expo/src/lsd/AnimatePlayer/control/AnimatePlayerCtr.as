package lsd.AnimatePlayer.control
{
	import communication.Event.PluginEvent;
	import communication.MainSystem;
	
	import flash.events.Event;
	
	import lsd.AnimatePlayer.view.AnimatePlayer;
	
	import lxfa.model.XmlLoaderModel;
	import lxfa.utils.MemoryRecovery;
	
	import mx.core.UIComponent;
	
	public class AnimatePlayerCtr extends UIComponent
	{
		private var xml:XmlLoaderModel;
		private var animatePlayer:AnimatePlayer
		private var ID:int;
		private var isClose:Boolean=false;
		public function AnimatePlayerCtr()
		{
			MainSystem.getInstance().addAPI("addAnimate",init);
			MainSystem.getInstance().addAPI("removeAnimate",dispose);
		}
		private function init(id:int,controlRender:Boolean=false):AnimatePlayer
		{
			MainSystem.getInstance().isBusy=true
			animatePlayer=new AnimatePlayer();
			isClose=false;
			if(id!=-1)//-1就不显示桂娃了
			{
				this.ID=id;
				this.addChild(animatePlayer);
				xml=new XmlLoaderModel("xml/animate.xml");
				xml.addEventListener(Event.COMPLETE,on_xml_loaded);
				MainSystem.getInstance().addEventListener(PluginEvent.UPDATE,on_update);
			}
			return animatePlayer;
		}
		private function on_update(e:PluginEvent):void
		{
			MainSystem.getInstance().removeEventListener(PluginEvent.UPDATE,on_update);
			MainSystem.getInstance().isBusy=false
			MainSystem.getInstance().runAPIDirect("removeAnimate",[]);
		}
		private function on_xml_loaded(e:Event):void
		{
			if(xml.xmlData!=null)
			{
				animatePlayer.load(xml.xmlData.Animate[ID].@url);
			}
		}
		public function dispose():void
		{
			if(!isClose)
			{
				isClose=true;
				MemoryRecovery.getInstance().gcObj(animatePlayer,true);
			}
		}
	}
}