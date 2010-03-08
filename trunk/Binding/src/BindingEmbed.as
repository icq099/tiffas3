package
{
	import mx.binding.utils.BindingUtils;
	import mx.events.FlexEvent;
	
	public class BindingEmbed
	{
		[Bindable]
		public var a:int;
		public function BindingEmbed()
		{
			BindingUtils.bindProperty(this,"a",this,"a");
		}
	}
}