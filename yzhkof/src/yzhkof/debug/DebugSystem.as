package yzhkof.debug
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	public class DebugSystem
	{
		private static var _mainContainer:Sprite=new Sprite;
		private static var _stage:Stage;
		
		private static var displayObjectViewer:DebugDisplayObjectViewer; 
		public function DebugSystem()
		{
		}
		public static function init(stage:Stage):void
		{
			_stage=stage;
			stage.addChild(_mainContainer);
			
			_mainContainer.addEventListener(FocusEvent.FOCUS_IN,function(e:FocusEvent):void
			{
				stage.focus=e.relatedObject;
				e.preventDefault();			
			});
			_stage.addEventListener(Event.ADDED,onStageAdd)
			
			initDisplayObjectViewer();
			TextTrace.init(_mainContainer);
			
			_mainContainer.visible=false;
			
			TextTrace.view.y=200;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void
			{
				if((e.ctrlKey)&&(e.altKey))
				{
					switch(e.keyCode)
					{
						case 13:
							_mainContainer.visible=!_mainContainer.visible;
						break;
						case 84:
							TextTrace.visible=!TextTrace.visible;
						break;
						case 68:
							displayObjectViewer.visible=!displayObjectViewer.visible;
						break;
					}
				}
			});
		}
		private static function initDisplayObjectViewer():void
		{
			displayObjectViewer=new DebugDisplayObjectViewer(_stage);
			_mainContainer.addChild(displayObjectViewer);
			
		}
		private static function onStageAdd(e:Event):void
    	{
    		_stage.setChildIndex(_mainContainer,_stage.numChildren-1);
    	}

	}
}