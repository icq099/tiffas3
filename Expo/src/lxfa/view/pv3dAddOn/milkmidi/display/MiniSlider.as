
package lxfa.view.pv3dAddOn.milkmidi.display{	
	import flash.display.Sprite;	
	import flash.geom.Rectangle;	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;		
	public class MiniSlider extends Sprite {
		public static const SLIDER:String = "slider";		
		private var _lineLength	:Number;
		private var _maxValue	:Number;
		private var _minValue	:Number;
		private var _len		:Number;
		private var _thumbMC	:Sprite;
		private var _label		:String = "";
		private var _labelTXT	:TextField;
		
		/**
		 * 
		 * @param	pMin
		 * @param	pMax
		 * @param	pDisplayLength
		 * @param	pDirection
		 */
		public function MiniSlider(pMin:Number = 0, pMax:Number = 100, pDisplayLength:Number = 100, pDirection:String = "v"){
			_maxValue = pMax;
			_minValue = pMin;
			_len = pDisplayLength;
			
			this.graphics.lineStyle(1, 0x555577);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(_len, 0);
				
			
			_thumbMC = createDisplayBox();
			_thumbMC.buttonMode=true;
			addChild(_thumbMC);
			
			_thumbMC.addEventListener(MouseEvent.MOUSE_DOWN, onEventMouseDown, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			if(pDirection != "v"){
				this.rotation = 90;
			}
		}	
		private function createDisplayBox():Sprite{
			var _sp:Sprite = new Sprite();
			_sp.graphics.lineStyle(1, 0x999999, 1);
			_sp.graphics.beginFill(0xffffff)
			_sp.graphics.drawRect(-6, -10, 12, 20);
			_sp.graphics.endFill();
			return _sp;
		}
		private function onEventMouseDown(e:MouseEvent):void{
			var _rect:Rectangle = new Rectangle(0, 0, _len, 0);
			_thumbMC.startDrag(false, _rect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onEventMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onEventMouseUp, false, 0, true);
			onEventMouseMove();
		}
		private function onEventMouseMove(e:MouseEvent = null):void {			
			var _value:Number = int(_thumbMC.x/100*(100/(_len / (_maxValue - _minValue))) + _minValue);			
			this.dispatchEvent(new Event(MiniSlider.SLIDER));
		}
		private function onEventMouseUp(e:MouseEvent):void{
			_thumbMC.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onEventMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onEventMouseMove);
		}		
		public function set toolTip(pBol:Boolean):void {
		}
		public function get label():String { return _label; }
		public function set label(pLabel:String):void {
			_label = pLabel;
			if(!_labelTXT) _labelTXT = new TextField();
			_labelTXT.text = _label;
			_labelTXT.mouseEnabled = false;
			_labelTXT.x = -_labelTXT.textWidth - 10;
			_labelTXT.y = int(-_labelTXT.textHeight / 2);
			this.addChild(_labelTXT);
		}
		public function get value():Number{
			return (_thumbMC.x/100*(100/(_len / (_maxValue - _minValue))) + _minValue);
		}
		public function set value(pValue:Number):void {
			var _percentage:Number = pValue / (_maxValue - _minValue);
			percentage = _percentage;
		}
		public function set percentage(pPercentage:Number):void{
			pPercentage = Math.min(pPercentage, 1);
			_thumbMC.x = _len * pPercentage;
		}
		public function get percentage():Number {
			return  this.value / (_maxValue - _minValue);
		}
		protected function onRemoveFromStage(e:Event = null):void{			
			_thumbMC.removeEventListener(MouseEvent.MOUSE_DOWN, onEventMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onEventMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onEventMouseMove);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
	}
}
