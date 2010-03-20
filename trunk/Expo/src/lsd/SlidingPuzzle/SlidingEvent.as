package lsd.SlidingPuzzle
{
	import flash.events.Event;

	public class SlidingEvent extends Event
	{
		public static const PUZZLE_CHANG:String="SlidingEvent:puzzle_change";
		public static const PUZZLE_END:String="SlidingEvent:puzzle_end";


		public function SlidingEvent(type:String)
		{
			super(type);
		}

	}
}