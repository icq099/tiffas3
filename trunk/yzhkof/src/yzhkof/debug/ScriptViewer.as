package yzhkof.debug
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getQualifiedClassName;
	
	import yzhkof.ui.DragPanel;
	import yzhkof.ui.TextPanel;
	import yzhkof.ui.TileContainer;
	import yzhkof.util.StringUtil;

	public class ScriptViewer extends DragPanel
	{
		private var textField:TextField=new TextField;
		private var btn_container:TileContainer=new TileContainer();
		private var run_btn:TextPanel=new TextPanel(0xffff00);
		private var target_btn:TextPanel=new TextPanel(0xffff00);
		private const textWidth:Number=500;
		private const textHeight:Number=300;
		public function ScriptViewer()
		{
			super();
			init();
			ScriptRuner.init();
		}
		public function setTarget(target:Object):void
		{
			ScriptRuner.target=target;
			target_btn.text=getQualifiedClassName(target);
		}
		private function init():void
		{
			_content.addChild(textField);
			_content.addChild(btn_container);
			
			btn_container.addChild(run_btn);
			btn_container.addChild(target_btn);
			
			run_btn.text="run";
			target_btn.text=getQualifiedClassName(ScriptRuner.target);
			run_btn.drawBackGround();
			textField.y=30;
			textField.type=TextFieldType.INPUT;
			textField.width=textWidth;
			textField.height=textHeight;
			textField.multiline=true;
			drawBackGround();
			
			run_btn.addEventListener(MouseEvent.CLICK,__onRunBtnClick);
			target_btn.addEventListener(MouseEvent.CLICK,__onTargetClick);
//			textField.addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
//		private function __onKeyDown(e:KeyboardEvent):void
//		{
//			if(e.ctrlKey&&KeyMy.isDown(13))
//			{
//				__onRunBtnClick(null);
//			}
//		}
		private function __onTargetClick(e:Event):void
		{
			var text_content:String=textField.text;
			textField.text=StringUtil.addString(textField.text,"ScriptRuner.target",textField.caretIndex);
		}
		private function __onRunBtnClick(e:Event):void
		{
			if(textField.text)
			{
				ScriptRuner.run(textField.text);
			}
		}
		
		
	}
}