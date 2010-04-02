package lxfa.gehaiqingyun.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import lxfa.utils.MemoryRecovery;
	
	public class PlayListButton extends ListButton
	{
		private var ctr:PlayListCtr
		private var ID:int;
		public function PlayListButton(ID:int,name:String,ctr:PlayListCtr)
		{
			this.text.text=name;
			this.ctr=ctr;
			this.ID=ID;
			initListener();
		}
		private function initListener():void
		{
			this.addEventListener(MouseEvent.CLICK,on_double_click);
		}
		public function on_double_click(e:MouseEvent):void
		{
			ctr.playMedia(ID);
			this.parent.visible=false;
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(this,MouseEvent.DOUBLE_CLICK,on_double_click);
		}
	}
}