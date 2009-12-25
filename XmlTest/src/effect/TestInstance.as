package effect
{
	import mx.core.UIComponent;
	import mx.effects.EffectInstance;
	
	import yzhkof.MyGraphy;
	import yzhkof.Toolyzhkof;

	public class TestInstance extends EffectInstance
	{
		public function TestInstance(target:Object)
		{
			super(target);
		}
		public override function play():void{ 
			super.play();
			var c:UIComponent=Toolyzhkof.mcToUI(MyGraphy.drawRectangle());
			UIComponent(target).addChild(c);
		}
		
	}
}