package
{
	import flash.display.Sprite;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;

	public class SoundTest extends Sprite
	{
		private var mySound:Sound = new Sound();
		public function SoundTest()
		{
			
			mySound.addEventListener(SampleDataEvent.SAMPLE_DATA,sineWaveGenerator);
			mySound.play();
			trace(mySound.length)
		}
		private function sineWaveGenerator(event:SampleDataEvent):void {
		    for ( var c:int=0; c<8000; c++ ) {
		        
		        event.data.writeFloat(1.1);
		        event.data.writeFloat(Math.sin((Number(c+event.position)/Math.PI/2))*0.25);
		    }
		    trace(mySound.length)
		}
		
	}
}