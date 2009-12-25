package effect
{
	import mx.effects.Effect;
	import mx.effects.IEffectInstance;

	public class TestEffect extends Effect
	{
		public function TestEffect(target:Object=null)
		{
			super(target);
			instanceClass=TestInstance;
		}
		protected override function initInstance(instance:IEffectInstance):void{
			super.initInstance(instance);	
		}
	}
}