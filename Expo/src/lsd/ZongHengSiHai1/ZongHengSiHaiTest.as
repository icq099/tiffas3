package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	

	public class ZongHengSiHaiTest extends Sprite
	{
		private var zongHengSiHaiSwc:ZongHengSiHaiSwc;
		
		public function ZongHengSiHaiTest()
		{
			init();
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
		}
		
		private function init():void{
			
			zongHengSiHaiSwc=new ZongHengSiHaiSwc();
			addChild(zongHengSiHaiSwc);
			zongHengSiHaiSwc.x=100
			zongHengSiHaiSwc.y=100
			
		    zongHengSiHaiSwc.gomghButton.buttonMode=true;
		    zongHengSiHaiSwc.dmButton.buttonMode = true;
		    zongHengSiHaiSwc.fzButton.buttonMode = true;
		    zongHengSiHaiSwc.BBWButton.buttonMode = true;
		    zongHengSiHaiSwc.xjButon.buttonMode = true;
		    
			zongHengSiHaiSwc.clound.mouseEnabled=false;
			
			zongHengSiHaiSwc.gomghjj.stop();
			zongHengSiHaiSwc.godmjj.stop();
			zongHengSiHaiSwc.gofzjj.stop();
			zongHengSiHaiSwc.xijiang.stop();
			zongHengSiHaiSwc.BBW.stop();
			zongHengSiHaiSwc.xijiang.gotoAndStop(1);
			zongHengSiHaiSwc.HuangJing.stop();
			
			
			zongHengSiHaiSwc.gomghButton.addEventListener(MouseEvent.MOUSE_OVER,gomOV);
			zongHengSiHaiSwc.gomghButton.addEventListener(MouseEvent.MOUSE_OUT,gomOU);
            zongHengSiHaiSwc.gomghButton.addEventListener(MouseEvent.CLICK,gomCL);
  
            zongHengSiHaiSwc.dmButton.addEventListener(MouseEvent.MOUSE_OVER,dmOV);
            zongHengSiHaiSwc.dmButton.addEventListener(MouseEvent.MOUSE_OUT,dmOU);
            zongHengSiHaiSwc.dmButton.addEventListener(MouseEvent.CLICK,dmCL);
            
            zongHengSiHaiSwc.fzButton.addEventListener(MouseEvent.MOUSE_OVER,fzOV);
            zongHengSiHaiSwc.fzButton.addEventListener(MouseEvent.MOUSE_OUT,fzOU);
            zongHengSiHaiSwc.fzButton.addEventListener(MouseEvent.CLICK,fzCL);
            
            zongHengSiHaiSwc.BBWButton.addEventListener(MouseEvent.MOUSE_OVER,BBWOV);
            zongHengSiHaiSwc.BBWButton.addEventListener(MouseEvent.MOUSE_OUT,BBWOU);
            zongHengSiHaiSwc.BBWButton.addEventListener(MouseEvent.CLICK,BBWCL);
            
            zongHengSiHaiSwc.xjButon.addEventListener(MouseEvent.MOUSE_OVER,xjOV);
            zongHengSiHaiSwc.xjButon.addEventListener(MouseEvent.MOUSE_OUT,xjOU);
            zongHengSiHaiSwc.xjButon.addEventListener(MouseEvent.CLICK,xjCL);
            
            zongHengSiHaiSwc.nnButton.addEventListener(MouseEvent.MOUSE_OVER,nnOV);
            zongHengSiHaiSwc.nnButton.addEventListener(MouseEvent.MOUSE_OUT,nnOU);
            
       
            zongHengSiHaiSwc.czButton.addEventListener(MouseEvent.MOUSE_OVER,czOV);
            zongHengSiHaiSwc.czButton.addEventListener(MouseEvent.MOUSE_OUT,czOU);
            
            zongHengSiHaiSwc.fcgButton.addEventListener(MouseEvent.MOUSE_OVER,fcgOV);
            zongHengSiHaiSwc.fcgButton.addEventListener(MouseEvent.MOUSE_OUT,fcgOU);
            
            zongHengSiHaiSwc.ggButton.addEventListener(MouseEvent.MOUSE_OVER,ggOV);
            zongHengSiHaiSwc.ggButton.addEventListener(MouseEvent.MOUSE_OUT,ggOU);
            
            zongHengSiHaiSwc.glButton.addEventListener(MouseEvent.MOUSE_OVER,glOV);
            zongHengSiHaiSwc.glButton.addEventListener(MouseEvent.MOUSE_OUT,glOU);
            
            zongHengSiHaiSwc.hcButton.addEventListener(MouseEvent.MOUSE_OVER,hcOV);
            zongHengSiHaiSwc.hcButton.addEventListener(MouseEvent.MOUSE_OUT,hcOU);
            
            zongHengSiHaiSwc.hzButton.addEventListener(MouseEvent.MOUSE_OVER,hzOV);
            zongHengSiHaiSwc.hzButton.addEventListener(MouseEvent.MOUSE_OUT,hzOU);
            
            zongHengSiHaiSwc.lbButton.addEventListener(MouseEvent.MOUSE_OVER,lbOV);
            zongHengSiHaiSwc.lbButton.addEventListener(MouseEvent.MOUSE_OUT,lbOU);
            
            zongHengSiHaiSwc.lzButton.addEventListener(MouseEvent.MOUSE_OVER,lzOV);
            zongHengSiHaiSwc.lzButton.addEventListener(MouseEvent.MOUSE_OUT,lzOU);
            
            zongHengSiHaiSwc.qzButton.addEventListener(MouseEvent.MOUSE_OVER,qzOV);
            zongHengSiHaiSwc.qzButton.addEventListener(MouseEvent.MOUSE_OUT,qzOU);
            
            zongHengSiHaiSwc.wzButton.addEventListener(MouseEvent.MOUSE_OVER,wzOV);
            zongHengSiHaiSwc.wzButton.addEventListener(MouseEvent.MOUSE_OUT,wzOU);
            
            zongHengSiHaiSwc.ylButton.addEventListener(MouseEvent.MOUSE_OVER,ylOV);
            zongHengSiHaiSwc.ylButton.addEventListener(MouseEvent.MOUSE_OUT,ylOU);
            
            zongHengSiHaiSwc.bsButton.addEventListener(MouseEvent.MOUSE_OVER,bsOV);
            zongHengSiHaiSwc.bsButton.addEventListener(MouseEvent.MOUSE_OUT,bsOU);
            
            zongHengSiHaiSwc.bhButton.addEventListener(MouseEvent.MOUSE_OVER,bhOV);
            zongHengSiHaiSwc.bhButton.addEventListener(MouseEvent.MOUSE_OUT,bhOU);
            
		}
		
		
		private function gomOV(e:MouseEvent):void{
		
			zongHengSiHaiSwc.gomghjj.gotoAndPlay(2);
		}
		
		
		private function gomOU(e:MouseEvent):void{
			zongHengSiHaiSwc.gomghjj.gotoAndPlay(1);
		}
		
		
		private function gomCL(e:MouseEvent):void{
			trace("去湄公河");
		}
		
		private function dmOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.godmjj.gotoAndPlay(2);
		}
		
			
		private function dmOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.godmjj.gotoAndPlay(1);
		}
		
		private function dmCL(e:MouseEvent):void{
			trace("去东盟");
			
		}
		
		private function fzOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.gofzjj.gotoAndPlay(2);
			
		}
		
		private function fzOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.gofzjj.gotoAndPlay(1);
			zongHengSiHaiSwc.gofzjj.stop();
		}
		
		private function fzCL(e:MouseEvent):void{
			trace("去泛珠");
			
		}
		
		private function BBWOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.BBW.gotoAndPlay(3);
			
		}
		
		private function BBWOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.BBW.gotoAndPlay(6);
			zongHengSiHaiSwc.BBW.stop();
		}
		
		private function BBWCL(e:MouseEvent):void{
			trace("弹北部湾窗口");
			
		}
		
		private function xjOV(e:MouseEvent):void{
			
            zongHengSiHaiSwc.xijiang.gotoAndStop(2);
			zongHengSiHaiSwc.HuangJing.gotoAndPlay(1);
			zongHengSiHaiSwc.HuangJing.stop();
			zongHengSiHaiSwc.HuangJing.gotoAndPlay(6);
		}
		
		private function xjOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.HuangJing.gotoAndPlay(6);
			zongHengSiHaiSwc.HuangJing.stop();
			zongHengSiHaiSwc.HuangJing.gotoAndStop(1);
		    zongHengSiHaiSwc.xijiang.gotoAndStop(3);
			zongHengSiHaiSwc.xijiang.gotoAndStop(1);
		}
		
		private function xjCL(e:MouseEvent):void{
			trace("黄金水道");
			
		}
		
		private function nnOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.nnguang.gotoAndPlay(2);
			zongHengSiHaiSwc.quan.visible=false;
			
		}
		
		private function nnOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.nnguang.gotoAndPlay(5);
			zongHengSiHaiSwc.quan.visible=true;
		
		}
		
		private function czOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.czguang.gotoAndPlay(2);
			
		}
		
		private function czOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.czguang.gotoAndPlay(5);
		
		}
		
		private function fcgOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.fcgguang.gotoAndPlay(2);
			
		}
		
		private function fcgOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.fcgguang.gotoAndPlay(5);
		
		}
		
		private function ggOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.ggguang.gotoAndPlay(2);
			
		}
		
		private function ggOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.ggguang.gotoAndPlay(5);
		
		}
		
		private function glOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.glguang.gotoAndPlay(2);
       }
		
		private function glOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.glguang.gotoAndPlay(5);
       }
		
		private function hcOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.hcguang.gotoAndPlay(2);
			
		}
		
		private function hcOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.hcguang.gotoAndPlay(5);
		
		}
		
		private function hzOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.hzguang.gotoAndPlay(2);
     	}
		
		private function hzOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.hzguang.gotoAndPlay(5);
         }
         private function lbOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.lbguang.gotoAndPlay(2);
     	}
		
		private function lbOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.lbguang.gotoAndPlay(5);
         }
         private function lzOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.lzguang.gotoAndPlay(2);
     	}
		
		private function lzOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.lzguang.gotoAndPlay(5);
         }
         private function qzOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.qzguang.gotoAndPlay(2);
     	}
		
		private function qzOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.qzguang.gotoAndPlay(5);
         }
         private function wzOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.wzguang.gotoAndPlay(2);
     	}
		
		private function wzOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.wzguang.gotoAndPlay(5);
         }
          private function ylOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.ylguang.gotoAndPlay(2);
     	}
		
		private function ylOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.ylguang.gotoAndPlay(5);
         }
          private function bsOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.bsguang.gotoAndPlay(2);
     	}
		
		private function bsOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.bsguang.gotoAndPlay(5);
         }
         private function bhOV(e:MouseEvent):void{
			
			zongHengSiHaiSwc.bhguang.gotoAndPlay(2);
     	}
		
		private function bhOU(e:MouseEvent):void{
			
			zongHengSiHaiSwc.bhguang.gotoAndPlay(5);
         }
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
