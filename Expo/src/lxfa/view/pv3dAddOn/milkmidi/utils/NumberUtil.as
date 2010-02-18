package lxfa.view.pv3dAddOn.milkmidi.utils
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	/** 	 
	 * @author milkmidi
	 * @version 1.0
	 */
	public final class NumberUtil
	{		
		public function NumberUtil() { 	throw new IllegalOperationError("NetUtil cannot be instantiated.");	}
		
		/**
		 * 回傳1或是-1的整數
		 * @param pValue Number
		 * @return Number
		 */
		public static function getCoin(pValue:Number = 1):Number {			
			return ( Math.random() < 0.5 ) ? 1 * pValue : -1 * pValue; 			
		}		
		/**
		 * 回傳true或是false
		 * @return
		 */
		public static function randomBoolean():Boolean {					
			return ( Math.random() < 0.5 ) ? true : false; 			
		}	
		/**
		 * Brown運動。
		 * @return Number
		 */
		public static function getBrown():Number {			
			return (Math.random() * 20 - 10) * .02;			
		};
		
		
		/**
		 * 亂數範圍取整數或是浮點值。
		 * @param	pMin 最小值。
		 * @param	pMax 最大值。
		 * @param	pRound default true 是否是取整數值。
		 * 
		 * @return Number。
		 */
		public static function random(pMin:Number, pMax:Number , pRound:Boolean = true):Number	{				
			var _number:Number = Math.random() * (pMax - pMin) + pMin;			
			return pRound ?  int(_number) : _number;						
		}			
		public static function radian2Degree(pRadian:Number):Number{
			return pRadian * (180 / Math.PI);
		}
		public static function degree2Radian(pDegree:Number):Number{
			return pDegree * (Math.PI / 180);
		}		
		
		public static function getPositionFromAngle(pDegree:Number, pPosition:Number) : Point  {
            return new Point(deghyp2X(pDegree, pPosition), deghyp2Y(pDegree, pPosition));
        }		
        public static function getAngleFromPosition(p0:Point, p1:Point) : Number   {
            var _disX:Number = p0.x - p1.x;
            var _dixY:Number = p0.y - p1.y;
            return Math.atan2(_dixY, _disX) * 180 / Math.PI;
        }
        public static function deghyp2X(pDegree:Number, pX:Number) : Number  {
            return Math.cos(degree2Radian(pDegree)) * pX;
        }
		public static function deghyp2Y(pDegree:Number, pY:Number) : Number {
            return Math.sin(degree2Radian(pDegree)) * pY;
        }
		public static function addComma(pNum:Number):String {						
			var _str:String = String(Math.abs(Math.floor(pNum)));			
			var _len:int = _str.length;
			if (_len <= 3) 
				return _str;			
			var _tmp:String="";
			for (var i:int = 0; i < _len; i++) {
				_tmp += (_len - i) % 3 == 0 ? "," + _str.charAt(i) : _str.charAt(i);			
			}
			return _tmp;
		}
		
	}
}
