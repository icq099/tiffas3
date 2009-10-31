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
			//api.addAPI("aa",aa);
			//api.addAPI("trace",bb);
			//api.addAPI("plus",cc);
			api.addAPI("cc",cc);
			runer.run("cc(cc(1));");
			trace(runer.runFunctionDirect("cc",[1]));
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
		private function setCameraRotaion(rotaX:Number=0,rotaY:Number=0,tween:Boolean=true):void{
			trace(rotaX,rotaY,tween);
		}
		
	}
}