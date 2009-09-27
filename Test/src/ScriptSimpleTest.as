package
{
	import flash.display.Sprite;
	
	import scripsimple.ScripSimpleAPI;
	import scripsimple.ScriptSimple;

	public class ScriptSimpleTest extends Sprite
	{
		public function ScriptSimpleTest()
		{
			var api:ScripSimpleAPI=new ScripSimpleAPI();
			var runer:ScriptSimple=new ScriptSimple(api);
			api.addAPI("aa",aa);
			api.addAPI("trace",bb);
			api.addAPI("plus",cc);
			runer.run("trace(aa(1,aa(1,1)),aa(2,1),3,yzhkof);trace(fuck,shit);trace(yzhkof);");
		} 
		private function cc(num:Number):Number{
			
			return num+1;
		
		}
		private function aa(num:Number,num2:Number):Number{
			//trace(num+num2);
			return num+num2;		
		}
		private function bb(...content):void{
			trace(content);		
		}
		
	}
}