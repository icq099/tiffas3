package yzhkof.demo
{
	import mx.modules.Module;
	
	import yzhkof.Toolyzhkof;
  
	public class DemoSpriteModule extends Module 
	{
		public function DemoSpriteModule()  
		{   
			addChild(Toolyzhkof.mcToUI(new DemoSprite())); 
		} 
		
	}
}