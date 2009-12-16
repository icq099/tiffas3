package yzhkof.position
{
	import flash.display.Sprite;
	
	import gs.TweenLite;

	public class LabelsContainer extends Sprite
	{
		private var label1:PositionEffectContainer;
		private var label2:PositionEffectContainer;
		private var line:CutingLine=new CutingLine();
		private const label1_size:int=35;
		private const label2_size:int=15;
		//private var label1_text:String;
		//private var label2_text:String;
		public function LabelsContainer(label1_text:String,label2_text:String)
		{
			label1=new PositionEffectContainer(label1_text,PositionEffectContainer.TYPE_NORMAL,label1_size);
			label2=new PositionEffectContainer(label2_text,PositionEffectContainer.TYPE_REVERSE,label2_size);
			addChild(label1);
			addChild(label2);
			addChild(line);
			line.y=label1.height+5;
			line.width=label1.width+150;
			label1.x=30;
			label2.y=line.y+5;
			label2.x=line.width-label2.width-30;
			TweenLite.from(line,2,{alpha:0,x:-line.width});
		}
		public function dispose():void{
			label1.dispose();
			label2.dispose();
		}
		
	}
}