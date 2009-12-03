package yzhkof.position
{
	import communication.Event.SceneChangeEvent;
	import communication.MainSystem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import yzhkof.loader.CompatibleURLLoader;

	public class PositionMain extends Sprite
	{
		private var xml:XML;
		private var loader:CompatibleURLLoader=new CompatibleURLLoader();
		private var label:LabelsContainer;
		public function PositionMain()
		{
			loader.loadURL("xml/positionname.xml");
			loader.addEventListener(Event.COMPLETE,init);
		}
		private function init(e:Event):void{
			xml=XML(loader.data);
			changeLabel(String(MainSystem.getInstance().currentScene));
			MainSystem.getInstance().addEventListener(SceneChangeEvent.CHANGE,onPositionChange);
		}
		private function onPositionChange(e:SceneChangeEvent):void{
			changeLabel(String(e.id));
		}
		private function changeLabel(id:String):void{
			var scene_xml:XML=getSceneXmlById(id);
			try{
				removeChild(label);
				label.dispose();
			}catch(e:Error){
			}
			label=new LabelsContainer(scene_xml.@Label1,scene_xml.@Label2);
			addChild(label);
		}
		private function getSceneXmlById(id:String):XML{
			return new XML(xml.Name.(@sceneID==id).toXMLString());;
		}
		
	}
}