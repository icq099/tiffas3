package proxys
{
	import facades.FacadePv;
	
	public class PScriptRuner extends PScriptRunerBase
	{
		public function PScriptRuner()
		{
			super();
		}
		protected override function init():void{
			addAPI("gotoScene",gotoScene);		
		} 
		private function gotoScene(scene:int):void{
			facade.sendNotification(FacadePv.GO_POSITION,scene);
		}
		private function popUpHotPoint(id:int):void{
			facade.sendNotification(FacadePv.POPUP_MENU_DIRECT,id);
		}
		
	}
}