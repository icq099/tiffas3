package yzhkof.ui.tip
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import yzhkof.core.StageManager;
	import yzhkof.util.Helpers;
	
	public class TipManager
	{
		private static var instance:TipManager;
		private static const tipContainer:Sprite=new Sprite;
		private static const tipMap:Dictionary=new Dictionary();
		private static const tipParamMap:Dictionary=new Dictionary();
		
		private static var currentInteractiveObj:InteractiveObject;
		private static var currentTip:DisplayObject;
		private static var currentParam:Object;
		private static var distanceX:Number=0;
		private static var distanceY:Number=0;		
		private static var _stage:Stage=StageManager.stage;
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
		 *  给目标对象添加tips
		 *  需要手动移除
		 *  
		 * @param dobj
		 * @param tip 可以为DisplayObject,Function,Class。当此属性为Function时，应传入的Function结构为：
		 * 
		 * 				function(view:InteractiveObject):DisplayObject
		 * 				
		 * 				此Function在鼠标经过时回调，其中参数view为当前Tip的宿主，返回的为你希望显示的Tips显示对象。
		 * 			
		 * @param tipParam {distance:Number,onRemove:function(tip),onAdd:function(tip),offsetX:Number,offsetY:Number}
		 * 					此为Tip的设置参数，distance为Tips距离鼠标的距离，onAdd,onRemove分别为Tips在添加至舞台与移除至舞台时的回调
		 * 					，同时还会为它们传入要显示Tips本身。
		 * 
		 */	
		public function addTipTo(dobj:InteractiveObject,tip:Object,tipParam:Object=null):void
		{
			Helpers.objectParamCheck(tipParam,[
				"offsetX",
				"offsetY",
				"distance",
				"onRemove",
				"onAdd",
			])
			setTip(dobj,tip,tipParam);
			dobj.addEventListener(MouseEvent.ROLL_OVER,__mouseOver);
			dobj.addEventListener(MouseEvent.ROLL_OUT,__mouseOut);
			
		}
		public function removeTipFrom(dobj:InteractiveObject):void
		{
			removeTip(dobj);
			dobj.removeEventListener(MouseEvent.ROLL_OVER,__mouseOver);
			dobj.removeEventListener(MouseEvent.ROLL_OUT,__mouseOut);
			dobj.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
			dobj.removeEventListener(MouseEvent.CLICK,__mouseClick);
		}
		public function refreshTip():void
		{
			setCurrentTip(currentInteractiveObj);
			upDateTipPosition();
		}
		private function removeTip(dobj:Object):void
		{
			var tip:DisplayObject = currentTip;
			if(tip&&tip.parent)
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
				currentTip.x = _stage.mouseX+(currentParam.offsetX||0)+distanceX;
				currentTip.y = _stage.mouseY+(currentParam.offsetY||0)+distanceY;
				var rectangle:Rectangle = currentTip.getBounds(_stage);
				if(rectangle.bottom>_stage.stageHeight) currentTip.y -= rectangle.bottom-_stage.stageHeight+distanceY;
				if(rectangle.right>_stage.stageWidth) currentTip.x -= rectangle.width+distanceY*2;
			}
		}
		private function setCurrentTip(dobj:Object):void
		{
			if(currentInteractiveObj&&dobj)
				setCurrentTip(null);
			if(dobj)
			{
				currentInteractiveObj = dobj as InteractiveObject;
				currentTip = getTip(dobj);
				currentParam = tipParamMap[dobj];
				distanceX = currentParam.distance?currentParam.distance/Math.SQRT2:0;
				distanceY = distanceX;
				if(currentTip)
				{
					tipContainer.addChild(currentTip);
					//					currentTip.alpha = 0;
					//					GTweener.to(currentTip,0.1,{alpha:1});
					if(currentParam["onAdd"]) currentParam["onAdd"](currentTip);
				}
			}
			else
			{
				if(currentTip&&currentTip.parent)
				{
					//					var gt:GTween = GTweener.to(currentTip,0.1,{alpha:0});
					//					gt.data = currentParam;
					//					gt.onComplete = function(g:GTween):void
					//					{
					//						tipContainer.removeChild(DisplayObject(g.target));
					//						if(gt.data["onRemove"]) gt.data["onRemove"](g.target);
					//					};
					tipContainer.removeChild(currentTip);
					if(currentParam["onRemove"]) currentParam["onRemove"](currentTip);
				}
				currentInteractiveObj = null;
				currentTip = null;
				currentParam = null;
			}
		}
		private function __mouseOver(e:Event):void
		{
			setCurrentTip(e.currentTarget);	
			upDateTipPosition();
			currentInteractiveObj.addEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
			currentInteractiveObj.addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		private function __mouseClick(e:Event):void
		{
			refreshTip();
		}
		private function __mouseOut(e:Event):void
		{
			currentInteractiveObj.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
			currentInteractiveObj.removeEventListener(MouseEvent.CLICK,__mouseClick);
			setCurrentTip(null);			
		}
		private function setTip(dobj:Object,tip:Object,tipParam:Object):void
		{
			tipMap[dobj] = tip;
			tipParamMap[dobj] = tipParam||{offsetX:0,offsetY:0};
		}
		private function getTip(dobj:Object):DisplayObject
		{
			var tipobj:Object = tipMap[dobj];
			if(tipobj == null)
				return null;
			if(tipobj is DisplayObject)
				return tipobj as DisplayObject;
			if(tipobj is Function)
				return tipobj(currentInteractiveObj);
			if(tipobj is Class)
				return tipobj();
			throw new Error("不支持的Tip方式");
			return null;
		}
	}
}