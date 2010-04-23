package yzhkof.debug
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;
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
		private var import_btn:TextPanel=new TextPanel(0xffff00);
		private var import_text:TextField=new TextField();
		private const textWidth:Number=500;
		private const textHeight:Number=300;
		private var importCount:uint=0;
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
			btn_container.updataChildPosition();
		}
		private function init():void
		{
			_content.addChild(textField);
			_content.addChild(btn_container);
			
			btn_container.addChild(run_btn);
			btn_container.addChild(target_btn);
			btn_container.addChild(import_btn);
			btn_container.addChild(import_text);
			
			run_btn.text="run";
			import_btn.text="import";
			target_btn.text=getQualifiedClassName(ScriptRuner.target);
			run_btn.drawBackGround();
			
			import_text.border=true;
			import_text.type=TextFieldType.INPUT;
			import_text.height=20;
			textField.y=30;
			textField.type=TextFieldType.INPUT;
			textField.width=textWidth;
			textField.height=textHeight;
			textField.multiline=true;
			drawBackGround();
			
			run_btn.addEventListener(MouseEvent.CLICK,__onRunBtnClick);
			target_btn.addEventListener(MouseEvent.CLICK,__onTargetClick);
			import_btn.addEventListener(MouseEvent.CLICK,__onImportClick);
//			textField.addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
//		private function __onKeyDown(e:KeyboardEvent):void
//		{
//			if(e.ctrlKey&&KeyMy.isDown(13))
//			{
//				__onRunBtnClick(null);
//			}
//		}
		private function __onImportClick(e:Event):void
		{
			textField.text=StringUtil.addString(textField.text,"namespace n"+importCount+" = \""+getPackageName()+"\"; use namespace n"+importCount+";\n",0);
			importCount++;
		}
		private function getPackageName():String
		{
			if(import_text.text)
			{
//				var re_text:String="";
//				var class_string:String=getDefinitionByName(import_text.text);
//				re_text=class_string.split("::")[0];
				return import_text.text;
			}
			return "****";
		}
		private function __onTargetClick(e:Event):void
		{
			var text_content:String=textField.text;
			textField.text=StringUtil.replaceString(textField.text,"ScriptRuner.target",textField.selectionBeginIndex,textField.selectionEndIndex);
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