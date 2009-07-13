package yzhkof
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public final class FPSfromA3d extends Sprite
    {
        private var currentY:int;
        private var diagramTimer:int;
        private var tfTimer:int;
        private var downloadedBytes:uint = 0;
        private var maxMemory:uint = 0;
        private var socketOutBytes:uint = 0;
        private var socketOutLast:uint = 0;
        private var socketInBytes:uint = 0;
        private var mem:TextField;
        private var skn:TextField;
        private var diagram:BitmapData;
        private var socketOut:TextField;
        private var skins:int = -1;
        private var fps:TextField;
        private var socketInLast:uint = 0;
        private var tfDelay:int = 0;
        private var socketIn:TextField;
        private var dwl:TextField;
        private var skinsChanged:int = 0;
        static private const diagramWidth:uint = 60;
        static private const tfDelayMax:int = 10;
        static private var instance:FPSfromA3d;
        static private const maxSocket:uint = 4200;
        static private const diagramHeight:uint = 40;

        public function FPSfromA3d(stg:DisplayObjectContainer)
        {
			var _loc_2:Bitmap;
            fps = new TextField();
            mem = new TextField();
            skn = new TextField();
            dwl = new TextField();
            socketIn = new TextField();
            socketOut = new TextField();
            if (instance == null)
            {
                mouseEnabled = false;
                mouseChildren = false;
                stg.addChild(this);
                fps.defaultTextFormat = new TextFormat("Tahoma", 10, 13421772);
                fps.autoSize = TextFieldAutoSize.LEFT;
                fps.text = "FPS: " + Number(stage.frameRate).toFixed(2);
                fps.selectable = false;
                fps.x = -diagramWidth - 2;
                addChild(fps);
                mem.defaultTextFormat = new TextFormat("Tahoma", 10, 13421568);
                mem.autoSize = TextFieldAutoSize.LEFT;
                mem.text = "MEM: " + bytesToString(System.totalMemory);
                mem.selectable = false;
                mem.x = -diagramWidth - 2;
                mem.y = 10;
                addChild(mem);
                currentY = 20;
                skn.defaultTextFormat = new TextFormat("Tahoma", 10, 16737792);
                skn.autoSize = TextFieldAutoSize.LEFT;
                skn.text = "MEM: " + bytesToString(System.totalMemory);
                skn.selectable = false;
                skn.x = -diagramWidth - 2;
                dwl.defaultTextFormat = new TextFormat("Tahoma", 10, 13369548);
                dwl.autoSize = TextFieldAutoSize.LEFT;
                dwl.selectable = false;
                dwl.x = -diagramWidth - 2;
                socketIn.defaultTextFormat = new TextFormat("Tahoma", 10, 65280);
                socketIn.autoSize = TextFieldAutoSize.LEFT;
                socketIn.selectable = false;
                socketIn.x = -diagramWidth - 2;
                socketOut.defaultTextFormat = new TextFormat("Tahoma", 10, 26367);
                socketOut.autoSize = TextFieldAutoSize.LEFT;
                socketOut.selectable = false;
                socketOut.x = -diagramWidth - 2;
                diagram = new BitmapData(diagramWidth, diagramHeight, true, 553648127);
                _loc_2 = new Bitmap(diagram);
                _loc_2.y = currentY + 4;
                _loc_2.x = -diagramWidth;
                addChildAt(_loc_2, 0);
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
                stage.addEventListener(Event.RESIZE, onResize);
                onResize();
                diagramTimer = getTimer();
                tfTimer = getTimer();
            }
            else
            {
            }// end else if
            return;
        }

        private function bytesToString(mouseChildren:uint) : String
        {
            var _loc_2:String;
            if (mouseChildren < 1024)
            {
                _loc_2 = String(mouseChildren) + "b";
            }
            else if (mouseChildren < 10240)
            {
                _loc_2 = Number(mouseChildren / 1024).toFixed(2) + "kb";
            }
            else if (mouseChildren < 102400)
            {
                _loc_2 = Number(mouseChildren / 1024).toFixed(1) + "kb";
            }
            else if (mouseChildren < 1048576)
            {
                _loc_2 = (mouseChildren >> 10) + "kb";
            }
            else if (mouseChildren < 10485760)
            {
                _loc_2 = Number(mouseChildren / 1048576).toFixed(2) + "mb";
            }
            else if (mouseChildren < 104857600)
            {
                _loc_2 = Number(mouseChildren / 1048576).toFixed(1) + "mb";
            }
            else
            {
                _loc_2 = (mouseChildren >> 20) + "mb";
            }// end else if
            return _loc_2;
        }

        private function onEnterFrame(e:Event): void
        {
            tfDelay++;
            if (tfDelay >= tfDelayMax)
            {
                tfDelay = 0;
                fps.text = "FPS: " + Number(1000 * tfDelayMax / (getTimer() - tfTimer)).toFixed(2);
                tfTimer = getTimer();
            }// end if
            var _loc_2:* = 1000 / (getTimer() - diagramTimer);
            var _loc_3:* = _loc_2 > stage.frameRate ? (1) : (_loc_2 / stage.frameRate);
            diagramTimer = getTimer();
            diagram.scroll(1, 0);
            diagram.fillRect(new Rectangle(0, 0, 1, diagram.height), 553648127);
            diagram.setPixel32(0, diagramHeight * (1 - _loc_3), 4291611852);
            var _loc_4:* = System.totalMemory;
            mem.text = "MEM: " + bytesToString(_loc_4);
            var _loc_5:* = skins == 0 ? (0) : (skinsChanged / skins);
            diagram.setPixel32(0, diagramHeight * (1 - _loc_5), 4294927872);
            if (_loc_4 > maxMemory)
            {
                maxMemory = _loc_4;
            }// end if
            var _loc_6:* = _loc_4 / maxMemory;
            diagram.setPixel32(0, diagramHeight * (1 - _loc_6), 4291611648);
            var _loc_7:* = (socketInBytes - socketInLast) / maxSocket;
            socketInLast = socketInBytes;
            diagram.setPixel32(0, diagramHeight * (1 - _loc_7), 4278255360);
            var _loc_8:* = (socketOutBytes - socketOutLast) / maxSocket;
            socketOutLast = socketOutBytes;
            diagram.setPixel32(0, diagramHeight * (1 - _loc_8), 4278216447);
            return;
        }

        private function onResize(e:Event = null) : void{
        	
            var _loc_2:* = parent.globalToLocal(new Point(stage.stageWidth - 2, -3));
            x = _loc_2.x;
            y = _loc_2.y;
            return;
        }

        static public function addDownloadBytes(mouseChildren:uint) : void
        {
            if (instance.downloadedBytes == 0)
            {
                instance.dwl.y = instance.currentY;
                instance.currentY = instance.currentY + 10;
                instance.addChild(instance.dwl);
                instance.getChildAt(0).y = instance.currentY + 4;
            }// end if
            instance.downloadedBytes = instance.downloadedBytes + mouseChildren;
            instance.dwl.text = "DWL: " + instance.bytesToString(instance.downloadedBytes);
            return;
        }

        static public function init(skn:DisplayObjectContainer) : void
        {
            instance = new FPSfromA3d(skn);
            return;
        }

        static public function addSocketOutBytes(mouseChildren:uint) : void
        {
            if (instance.socketOutBytes == 0)
            {
                instance.socketOut.y = instance.currentY;
                instance.currentY = instance.currentY + 10;
                instance.addChild(instance.socketOut);
                instance.getChildAt(0).y = instance.currentY + 4;
            }// end if
            instance.socketOutBytes = instance.socketOutBytes + mouseChildren;
            instance.socketOut.text = "OUT: " + instance.bytesToString(instance.socketOutBytes);
            return;
        }

        static public function addSocketInBytes(mouseChildren:uint) : void
        {
            if (instance.socketInBytes == 0)
            {
                instance.socketIn.y = instance.currentY;
                instance.currentY = instance.currentY + 10;
                instance.addChild(instance.socketIn);
                instance.getChildAt(0).y = instance.currentY + 4;
            }// end if
            instance.socketInBytes = instance.socketInBytes + mouseChildren;
            instance.socketIn.text = "IN: " + instance.bytesToString(instance.socketInBytes);
            return;
        }

        static public function addSkins(skinsChanged:uint, toString:uint) : void
        {
            if (instance.skins < 0)
            {
                instance.skn.y = instance.currentY;
                instance.currentY = instance.currentY + 10;
                instance.addChild(instance.skn);
                instance.getChildAt(0).y = instance.currentY + 4;
            }// end if
            instance.skins = skinsChanged;
            instance.skinsChanged = toString;
            instance.skn.text = "SKN: " + (toString > 0 ? (skinsChanged.toString() + "-" + toString.toString()) : (skinsChanged.toString()));
            return;
        }
    }
}
