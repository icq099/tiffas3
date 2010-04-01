package lsd.SlidingPuzzle
{
	import flash.events.Event;

	public class SlidingEvent extends Event
	{
		public static const PUZZLE_CHANG:String="puzzle_change";
		public static const PUZZLE_END:String="puzzle_end";

 
		public function SlidingEvent(type:String)
		{
			super(type);
		}

	}
}