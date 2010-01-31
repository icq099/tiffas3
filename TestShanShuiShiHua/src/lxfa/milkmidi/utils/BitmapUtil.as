package lxfa.milkmidi.utils
{	
	import flash.display.*
	import flash.errors.IllegalOperationError;
	import flash.geom.*;	
	public final class BitmapUtil extends Object
	{			
		public static const MERGE_POSITION_LEFT :String = "left";
		public static const MERGE_POSITION_TOP  :String = "top";
		public static const MERGE_POSITION_RIGHT:String = "right";
		public static const MERGE_POSITION_DOWN :String = "down";
		//  ____  ____  _    _  ____ _____ ____  _   _  ____ _____  ____  ____
		// / ___|/ _  \| \  | |/ ___|_   _|  _ \| | | |/ ___|_   _|/ _  \|  _ \
		//| |    || | ||  \ | |\___ \ | | | |_) | | | | |     | |  || | || |_)I
		//| |___ ||_| || | \| | ___) || | | _  /| |_| | |___  | |  ||_| || _  /
		// \____|\____/|_|\___||____/ |_| |_|\_\ \___/ \____| |_|  \____/|_|\_\
		//__________________________________________________________________________________ Constructor
		public function BitmapUtil() { 	throw new IllegalOperationError("BitmapUtil cannot be instantiated.");	};				
		/**
		 * 得到物件的BitmapData
		 * @param	pData
		 * @return BitmapData
		 */
		public static function getBitmapData(pData:*):BitmapData {
			if (pData == null)  return null;
			
			if (pData is Class) {				
				if (pData is Bitmap) {					
					
					var _bitmap:Bitmap = new pData() as Bitmap;					
					return _bitmap.bitmapData
					
				}else if (pData is BitmapData) {						
					
					try{
						pData = new pData;
					} catch (err:Error) {
						pData = new pData(0,0);
					}						
				
				}			
            }
			
			if (pData is BitmapData)  return pData;
			
			if (pData is DisplayObject) {
                var _ds   :DisplayObject = pData as DisplayObject;				
                var _bmd  :BitmapData = new BitmapData(_ds.width, _ds.height, true, 0x00FFFFFF);
                var _mat  :Matrix = _ds.transform.matrix.clone();
                _mat.tx = 0;
                _mat.ty = 0;
                _bmd.draw(_ds, _mat, _ds.transform.colorTransform, _ds.blendMode, _bmd.rect, true);				
                return _bmd;
            }
			
			throw new Error("Can't BitmapUtil.getBitmapData" + pData);								
		}
		
		/**
		 * 結合二個BitmapData物件
		 * @param	pBmp1 點陣圖物件1
		 * @param	pBmp2 點陣圖物件2
		 * @param	pMergePosition 結合的位置
		 * @param	pDispose 是否Dispose來源的BitmapData物件
		 * @return BitmapData
		 */
		public static function mergeBitmap(pBmp1:BitmapData, pBmp2:BitmapData, pMergePosition:String = BitmapUtil.MERGE_POSITION_DOWN ,pDispose:Boolean = true ):BitmapData {			
			var _bmp:BitmapData = new BitmapData(pBmp1.width, pBmp1.height + pBmp2.height, true, 0);
			_bmp.copyPixels( pBmp1 , pBmp1.rect , new Point());
			_bmp.copyPixels( pBmp2 , pBmp2.rect , new Point(0, pBmp1.height));			
			if (pDispose) {
                pBmp1.dispose();
                pBmp2.dispose();
            }
			return _bmp;			
		}
		/**
		 * 結合二個BitmapData物件
		 * @param	pSource
		 * @param	pAlpha
		 * @param	pDispose default = true
		 * @return BitmapData
		 */
		public static function mergeBitmapAlpha(pSource:BitmapData, pAlpha:BitmapData, pDispose:Boolean = true) : BitmapData {
			var _resultBmp:BitmapData = new BitmapData(pSource.width, pSource.height);
            _resultBmp.copyPixels(pSource, pSource.rect, new Point());			
            _resultBmp.copyChannel(pAlpha, pAlpha.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
            if (pDispose) {
                pSource.dispose();
                pAlpha.dispose();
            }
            return _resultBmp;
        }
		
		
		public static function reflect(pTarget:*, pAttach:Boolean = false, pRatioFade:Number = .6, pRatioEndFade:Number = 0, _numMidLoc:Number = .4 ):BitmapData {			
			if ( !(pTarget is BitmapData) && !(pTarget is DisplayObject)) throw new Error("error Type");	
			
			var _resultBmp	:BitmapData = new BitmapData(pTarget.width, pTarget.height, true, 0);				
            var _matSkew	:Matrix = new Matrix(1, 0, 0, -1, 0, pTarget.height);			
            var _recDraw	:Rectangle = new Rectangle(0, 0, pTarget.width, pTarget.height);			
            var _potSkew	:Point = _matSkew.transformPoint(new Point(0, pTarget.height));
            _matSkew.tx = _potSkew.x * -1;
            _matSkew.ty = (_potSkew.y - pTarget.height) * -1;			
            _resultBmp.draw(pTarget, _matSkew, null, null, _recDraw, true);
            
            var _gradientShape:Shape = new Shape();			
			var _fillType	  :String = GradientType.LINEAR;
		 	var _colorsArr	  :Array = [0, 0 , 0];
			var _alphasArr	  :Array = [pRatioFade, (pRatioFade - pRatioEndFade) / 2, pRatioEndFade];
            var _ratiosArr	  :Array = [0, 0xFF * _numMidLoc, 0xFF];
			var _gradientMat  :Matrix = new Matrix();
			var _spreadMethod :String = SpreadMethod.PAD;
			
			
            _gradientMat.createGradientBox(pTarget.width, pTarget.height / 2, Math.PI / 2);									
            _gradientShape.graphics.beginGradientFill(_fillType, _colorsArr, _alphasArr, _ratiosArr, _gradientMat, _spreadMethod)			
            _gradientShape.graphics.drawRect(0, 0, pTarget.width, pTarget.height);
            _gradientShape.graphics.endFill();
            _resultBmp.draw(_gradientShape, null, null, BlendMode.ALPHA);
			
			if (pAttach && pTarget is Sprite) {				
				var _bitmap:Bitmap = new Bitmap(_resultBmp);				
				_bitmap.y = pTarget.height;				
				Sprite(pTarget).addChild(_bitmap);				
			}		
			_gradientShape = null;
			return _resultBmp		
		}
		//  ____  ____  _____     ___  _____ _____
		// |  _ \|  _ \|_ _\ \   / / \|_   _| ____|
		// | |_) | |_) || | \ \ / / _ \ | | |  _|
		// |  __/|  _ < | |  \ V / ___ \| | | |___
		// |_|   |_| \_\___|  \_/_/   \_\_| |_____|
        //__________________________________________________________________________________ Private Function
		
		// _______     _______ _    _ _____
		//| ____\ \   / | ____| \  | |_   _|
		//|  _|  \ \ / /|  _| |  \ | | | |
		//| |___  \ V / | |___| | \| | | |
		//|_____|  \_/  |_____|_|\___| |_|
		//__________________________________________________________________________________ Event
		
		//  ____   _____ _____         ____  _____ _____
		// / __ \ | ____|_   _|       / ___|| ____|_   _|
		//||____  |  _|   | |     _   \___ \|  _|   | |
		//||_   _|| |___  | |    (_)   ___) | |___  | |
		// \_|_|  |_____| |_|         |____/|_____| |_|
		//__________________________________________________________________________________ Get Set
		
	}
}
