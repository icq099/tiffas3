package plugins.lxfa.gehaiqingyun.view
{
	import view.decorator.DoubleClickDecorator;
	import view.decorator.IDoubleClickDecorator;
	
	public class PlayListButton extends ListButton implements IDoubleClickDecorator
	{
		private var ctr:PlayListCtr
		private var ID:int;
		private var doubleClickDecorator:DoubleClickDecorator;
		public function PlayListButton(ID:int,name:String,ctr:PlayListCtr)
		{
			this.text.text=name;
			this.ctr=ctr;
			this.ID=ID;
			initListener();
		}
		private function initListener():void
		{
			doubleClickDecorator=new DoubleClickDecorator(this);
		}
		public function doubleClick():void
		{
			ctr.playMedia(ID);
			this.parent.visible=false;
		}
		public function dispose():void
		{
			doubleClickDecorator.dispose();
		}
	}
}