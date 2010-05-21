package yzhkof.ui.mouse
{
	import com.hurlant.eval.gen.CodeGeneration;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import yzhkof.core.StageManager;

	public class MouseManager
	{
		private static var instance:MouseManager;
		private var cursorContainer:Sprite=new Sprite;
		private var _cursor:DisplayObject;
		
		public function MouseManager()
		{
			if(instance)
				throw new Error("error");
			instance = this;
			init();
		}
		private function init():void
		{
			StageManager.addChildToStageUpperDisplayList(cursorContainer);
			
			cursorContainer.mouseChildren=false;
			cursorContainer.mouseEnabled=false;
		}
		public static function getInstance():MouseManager
		{
			return instance||new MouseManager();
		}
		public static function set cursor(value:DisplayObject):void
		{
			MouseManager.getInstance().cursor = value;
		}
		public static function get cursor():DisplayObject
		{
			return MouseManager.getInstance().cursor;
		}
		public function get cursor():DisplayObject
		{
			return _cursor;
		}
		private function setCursor():void
		{
			cursorContainer.addChild(cursor);
			StageManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
			cursor.x = StageManager.stage.mouseX;
			cursor.y = StageManager.stage.mouseY;
		}
		private function unSetCursor():void
		{
			if(cursor&&cursor.parent)
				cursorContainer.removeChild(cursor);
			Mouse.show();
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMove);
		}
		private function __mouseMove(e:MouseEvent):void
		{
			cursor.x = e.stageX;
			cursor.y = e.stageY;
			e.updateAfterEvent();
		}
		public function set cursor(value:DisplayObject):void
		{
			if(value == null)
			{
				unSetCursor();
			}
			
			_cursor = value;
			
			if(_cursor)
			{
				Mouse.hide();
				if(_cursor is InteractiveObject)
					InteractiveObject(_cursor).mouseEnabled=false;
				if(_cursor is DisplayObjectContainer)
					DisplayObjectContainer(_cursor).mouseChildren=false;
				setCursor();
			}else
			{
				Mouse.show();
			}
			
		}
	}
}