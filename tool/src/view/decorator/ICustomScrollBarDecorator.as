package view.decorator
{
	import flash.geom.Point;
	import flash.text.TextField;
	
	public interface ICustomScrollBarDecorator
	{
		function get sideButton1():*;
		function get centerButton():*;
		function get sideButton2():*;
		function get point1():Point;
		function get point2():Point;
		function get textField():TextField;
	}
}