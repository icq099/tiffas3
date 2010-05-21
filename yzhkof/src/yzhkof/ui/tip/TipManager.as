package yzhkof.ui.tip
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import yzhkof.core.StageManager;

	public class TipManager
	{
		private static var instance:TipManager;
		private static const tipContainer:Sprite=new Sprite;
		private static const tipMap:Dictionary=new Dictionary(true);
		private static const tipParamMap:Dictionary=new Dictionary(true);
		
		private static var currentTip:DisplayObject;
		private static var currentParam:Object;
		public function TipManager()
		{
			if(instance)
				throw new Error("error");
			instance = this;
			init();
		}
		public static function getInstance():TipManager
		{
			return instance||new TipManager();
		}
		private function init():void
		{
			StageManager.addChildToStageUpperDisplayList(tipContainer);
			tipContainer.mouseEnabled=false;
			tipContainer.mouseChildren=false;
		}
		/**
		 *  
		 * @param dobj
		 * @param tip
		 * @param tipParam {offsetX:X,offsetY:Y}
		 * 
		 */		
		public function addTipTo(dobj:InteractiveObject,tip:DisplayObject,tipParam:Object=null):void
		{
			setTip(dobj,tip,tipParam);
			dobj.addEventListener(MouseEvent.ROLL_OVER,__mouseOver);
			dobj.addEventListener(MouseEvent.ROLL_OUT,__mouseOut);
			dobj.addEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
		}
		public function removeTipFrom(dobj:InteractiveObject):void
		{
			removeTip(dobj);
			dobj.removeEventListener(MouseEvent.ROLL_OVER,__mouseOver);
			dobj.removeEventListener(MouseEvent.ROLL_OUT,__mouseOut);
			dobj.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
		}
		private function removeTip(dobj:Object):void
		{
			var tip:DisplayObject = getTip(dobj);
			if(tip.parent)
				tipContainer.removeChild(tip);
			delete tipMap[dobj];
			delete tipParamMap[dobj];
		}
		private function __mouseMove(e:MouseEvent):void
		{
			upDateTipPosition();
			e.updateAfterEvent();
		}
		private function upDateTipPosition():void
		{
			if(currentTip)
			{
				currentTip.x = StageManager.stage.mouseX+currentParam.offsetX;
				currentTip.y = StageManager.stage.mouseY+currentParam.offsetY;
			}
		}
		private function setCurrentTip(dobj:Object):void
		{
			if(dobj)
			{
				currentTip = getTip(dobj);
				currentParam = tipParamMap[dobj];
			}
			else
			{
				currentTip = null;
				currentParam = null;
			}
		}
		private function __mouseOver(e:Event):void
		{
			setCurrentTip(e.currentTarget);
			tipContainer.addChild(currentTip);
			upDateTipPosition()
		}
		private function __mouseOut(e:Event):void
		{
			tipContainer.removeChild(currentTip);
			setCurrentTip(null);
		}
		private function setTip(dobj:Object,tip:DisplayObject,tipParam:Object):void
		{
			tipMap[dobj] = tip;
			tipParamMap[dobj] = tipParam;
		}
		private function getTip(dobj:Object):DisplayObject
		{
			return tipMap[dobj];
		}
	}
}