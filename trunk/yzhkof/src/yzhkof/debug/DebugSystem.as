package yzhkof.debug
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.sampler.startSampling;
	
	import yzhkof.KeyMy;
	import yzhkof.ui.TextPanel;
	
	public class DebugSystem
	{
		internal static var _mainContainer:Sprite;
		private static var _stage:Stage;
		
		internal static var displayObjectViewer:DebugDisplayObjectViewer;
		internal static var scriptViewer:ScriptViewer;
		internal static var logViewer:DebugLogViewer;
		
		public function DebugSystem()
		{
			
		}
		public static function init(stage:Stage,useSample:Boolean=false):void
		{
			if(useSample)
			{
				startSampling();
			}
			_mainContainer=new Sprite;
			_stage=stage;
			stage.addChild(_mainContainer);
			
			KeyMy.setStage(stage);
			KeyMy.startListener(stage);
			
			_stage.addEventListener(Event.ADDED,onStageAdd)
			
			logViewer = new DebugLogViewer();
			_mainContainer.addChild(logViewer);
			logViewer.y = 100;
			
			initDisplayObjectViewer();
			scriptViewer=new ScriptViewer();
			_mainContainer.addChild(scriptViewer);
			scriptViewer.x=420;
			TextTrace.init(_mainContainer);
			
			_mainContainer.visible=false;
			logViewer.visible =false;
			TextTrace.visible=false;
//			displayObjectViewer.visible=false;
			scriptViewer.visible=false;
			
			TextTrace.view.y=200;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void
			{
				if((e.ctrlKey)&&(e.altKey))
				{
					switch(e.keyCode)
					{
//						case 13:
//							_mainContainer.visible=!_mainContainer.visible;
//						break;
						case 84:
							TextTrace.visible=!TextTrace.visible;
						break;
						case 68:
							displayObjectViewer.visible=!displayObjectViewer.visible;
						break;
						case 65:
							scriptViewer.visible=!scriptViewer.visible;
						break;
					}
				}
				
				switch(e.keyCode)
				{
					case 192:
						_mainContainer.visible=!_mainContainer.visible;
					break;
				}
			});
		}
		internal static function getDebugTextButton(obj:*,text:String):TextPanel
		{
			return displayObjectViewer.getDebugTextButton(obj,text);
		}
		private static function initDisplayObjectViewer():void
		{
			displayObjectViewer=new DebugDisplayObjectViewer(_stage);
			displayObjectViewer.goto(_stage);
			_mainContainer.addChild(displayObjectViewer);
			displayObjectViewer.addEventListener(FocusEvent.FOCUS_IN,function(e:FocusEvent):void
			{
				_stage.focus=e.relatedObject;
				e.preventDefault();			
			});
			
		}
		private static function onStageAdd(e:Event):void
    	{
    		_stage.setChildIndex(_mainContainer,_stage.numChildren-1);
    	}

	}
}