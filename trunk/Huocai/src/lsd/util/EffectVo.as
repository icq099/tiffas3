package lsd.util
{
	public class EffectVo
	{
		private static var instance:EffectVo
		
		private var effect_add:String;
		public function EffectVo()
		{
			if(instance==null)
			{
				instance=this;
			}else
			{
				throw new Error("不能实例化");
			}
		}
		
		public static function getInstance():EffectVo
		{
			if(instance==null) return new EffectVo();
			return instance;
		}
		
		public  function setEffect(value:String):void{
				
				effect_add=value;
				 
			}
			
		public function getEffect():String{
				return effect_add;
			}
			

	}
}