package lxfa.step10
{
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	
	import flash.events.NetStatusEvent;
	
	import lxfa.view.player.FLVPlayer;
	
	import mx.core.UIComponent;
	
	public class Step10Base extends UIComponent
	{
		private var flvPlayer:FLVPlayer;
		public function Step10Base()
		{
			MainSystem.getInstance().gotoScene(4);//前进到美冠天下
		}
		private function flvPlayer_NetStatusHandler(e:NetStatusEvent):void
		{
			MainSystem.getInstance().gotoScene(4);//前进到美冠天下
			MainSystem.getInstance().addEventListener(SceneChangeEvent.CHANGED,function(e:SceneChangeEvent):void{
				dispose();
			});
		}
		public function dispose():void
		{
			if(flvPlayer!=null)
			{
				flvPlayer.parent.removeChild(flvPlayer);
				flvPlayer.dispose();
				flvPlayer=null;
			}
		}
	}
}