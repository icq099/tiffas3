package view
{
	import lsd.IPlayerBasic;
	
	import mx.containers.TitleWindow;
	import mx.core.mx_internal;
	use namespace mx_internal;

	public class TitleWindowCustom extends TitleWindow
	{
		public function TitleWindowCustom()
		{
			super();
			
		}
		override protected function createChildren():void{
			
			super.createChildren();
			this.closeButton.explicitWidth = closeButton.explicitHeight = 23;
		}
	}
}