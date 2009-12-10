package lxf.SamplePanel{
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	
	import fl.controls.List;
	import fl.events.ListEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	
	import other.EffectPv3dRota;
	
	import yzhkof.effect.MyEffect;

	public class SamplePanel extends Sprite
	{
		private var fpp:FishPanelPlugin=null;
		private var defaultLocationX:int=5;
		private var defaultLocationY:int=48;
		private var test:SampleList;
		public function SamplePanel()
		{
			fpp=new FishPanelPlugin();
			fpp.close.addEventListener(MouseEvent.CLICK,fppCloseClickEvent);
			fpp.list.rowHeight=25;
			var format:TextFormat = new TextFormat();
			format.size = 16;
			fpp.list.setRendererStyle("textFormat", format);
//			//载入XML
			fpp.list.addEventListener(ListEvent.ITEM_CLICK,listClickEvent);
			this.filters=[new DropShadowFilter(10,45,0,0.5,10,10,1,3)];
			this.addEventListener(MouseEvent.MOUSE_DOWN, dragMovie);
			this..addEventListener(MouseEvent.MOUSE_UP, dropMovie);
			//添加API
			MainSystem.getInstance().addAPI("showFishPanel",showFishPanel);
			MainSystem.getInstance().addAPI("removeFishPanel",removefishPanel);
			MainSystem.getInstance().addEventListener(SceneChangeEvent.CHANGE,refreshFishPanel);
//			MainSystem.getInstance().addEventListener(MainSystemEvent.ON_PLUGIN_READY,function(e:MainSystemEvent):void{
//				trace(e.id);
//			})
//			MainSystem.getInstance().showPluginById("map");
		}
		private function dragMovie(event:MouseEvent):void
		{
			this.startDrag();
		}

		private function dropMovie(event:MouseEvent):void
		{
			this.stopDrag();
		}
		//API函数
		private function showFishPanel():void
		{
			test=new SampleList();
			test.addEventListener(SampleLoadedEvent.sampleLoaded,traceStr);
			MyEffect.addChild(new EffectPv3dRota(this,fpp,1,true,1));
			addChild(fpp);
		}
		private function refreshFishPanel(e:SceneChangeEvent):void
		{
			fpp.list.removeAll();
			addButtons();
		}
		private function removefishPanel():void
		{
			MyEffect.removeChild(new EffectPv3dRota(this,fpp,1,false,-0.8,0,-0.2));
		}
		//////////////
		private function traceStr(e:SampleLoadedEvent):void
		{
			fpp.list.removeAll();
			addButtons();
		}
		private function fppCloseClickEvent(e:MouseEvent):void
		{
			MainSystem.getInstance().runAPIDirect("removeFishPanel");
		}
		///添加和删除按钮
		private function addButtons():void
		{
			var sceneID:int=MainSystem.getInstance().currentScene;
			if(temp!=null)
			{
				var temp:Array=test.readSampleList(sceneID);
				for(var i:int;i<temp.length;i++)
				{
					fpp.list.addItem(new FishPanelButtons(temp[i]));
				}
			}
		}
		private function listClickEvent(e:ListEvent):void
		{
			FishPanelButtons(List(e.currentTarget).getItemAt(e.index)).clickEvent();
		}
	}
}
