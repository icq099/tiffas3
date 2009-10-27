package lxf.SamplePanel
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class SampleList extends Sprite
	{
		private var myXML:XML = new XML();
		private var myXMLURL:URLRequest = new URLRequest(XML_URL);
		private var myLoader:URLLoader = new URLLoader(myXMLURL);
		private var XML_URL:String = "menu.xml";
		private var sceneNum:int=-1;
		private var list:Array=new Array();		
		public function SampleList()
		{
			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		private function xmlLoaded(event:Event):void
		{
		    myXML = XML(myLoader.data);
		    this.dispatchEvent(new SampleLoadedEvent(SampleLoadedEvent.sampleLoaded));
		}
		public function readSampleList(num:int):Array
		{
		    for(var i:int=0;i<myXML.Scene.length();i++)
		    {
		    	if(myXML.Scene[i].@sceneID==num)
		    	{
		    		num=i;
		    	}
		    }
		    for(i=0;i<myXML.Scene[num].sample.length();i++)
		    {
		    	list.push(myXML.Scene[num].sample[i]);
		    }
		    return list;
		}
	}
}