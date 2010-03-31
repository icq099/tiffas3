package lsd.CustomWindow
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import lxfa.normalWindow.SwfPlayer;
	import lxfa.utils.CollisionManager;
	import lxfa.utils.MemoryRecovery;
	import lxfa.view.loadings.LoadingWaveRota;
	
	import mx.core.UIComponent;
	
	import yzhkof.Toolyzhkof;
	
	public class CustomWindow extends UIComponent
	{
		private var swfPlayer:SwfPlayer;
		private var loading_mc:LoadingWaveRota;
		private var _text:String;
		private var textFiled:TextField;
		private var _url:String;
		public function CustomWindow(url:String,text:String)
		{  
			.
			if(url!=null&&text!=null&&url!=""&&text!=""){
				this._url=url;
				this._text=text;
				
			}
			//this._url="swf/mingzhubaimei.swf"
	        //this._text="广西壮族自治区地处祖国南疆,山水秀丽、四季如春、物产富饶,居住着壮、汉、瑶、苗、侗、仫佬、毛南、回、京、彝、水和仡佬等12个民族,是我国5个少数民族自治区之一.1997年末总人口4589万,少数民族人口占40%.他们世世代代在这块沃土上繁衍生息,辛勤耕耘,勇敢开拓,用自己非凡的智慧,描绘出一幅幅波澜壮阔的历史画卷.  广西少数民族有着悠久的历史,有着自己灿烂的文化艺术,并形成了自己独特的文化特点.如壮族的铜鼓、花山崖壁画早已闻名中外.各民族的民歌在全国也享有盛名.此外,包括织锦、刺绣、陶瓷、竹编和芒编在内的各色工艺品,具有民族特点的壮族干栏式建筑、侗族风雨桥、鼓楼等民族建筑,瑶、苗等民族的医药,以及丰富多采的民族民间文学、音乐、舞蹈等等,都是广西各少数民族文化艺术的瑰宝.至于壮族的三月三歌节、瑶族的达努节和盘王节、苗族的踩花山、仫佬族的走坡节、侗族的花炮节,以及别有风味的打油茶等充满着浓郁的民族风情的节日活动,更是深深地吸引着众多的游人."
		    loadSwf(_url);
		}
		
		public function loadSwf(url:String):void{
			
			swfPlayer=new SwfPlayer(url,820,403);
			initLoadingMc();
			swfPlayer.addEventListener(ProgressEvent.PROGRESS,on_flv_progress);
			swfPlayer.addEventListener(Event.COMPLETE,on_swf_complete);
			
			
		}
		public function loadText():void{
		   textFiled=new TextField();
		   textFiled.text=_text
		   textFiled.wordWrap=true;
		   textFiled.x=swfPlayer.x+300
		   textFiled.y=swfPlayer.y+30
           textFiled.width=423;
		   textFiled.height=58;
		   textFiled.textColor=0xFFFFFF;
		   textFiled.mouseEnabled=false;
		   textFiled.mouseWheelEnabled=false;
		   this.addChild(textFiled);
			
		}
		private function initLoadingMc():void
		{
			loading_mc=new LoadingWaveRota();
			loading_mc.x=swfPlayer.x+swfPlayer.width/2
			loading_mc.y=swfPlayer.y+swfPlayer.height/2
			this.addChild(Toolyzhkof.mcToUI(loading_mc));
			
		}
		
		private function on_flv_progress(e:ProgressEvent):void //FLV加载完毕
		{
			loading_mc.updateByProgressEvent(e);
		}
		private function on_swf_complete(e:Event):void
		{
			MemoryRecovery.getInstance().gcObj(loading_mc);
			this.addChild(swfPlayer);
			dispatchEvent(new CustomWindowEvent(CustomWindowEvent.SWF_COMPLETE));
			loadText();
			addAreas();	
		}
		private function addAreas():void{
			  
		    var upAreas:Array=[[[740+this.x, 100+this.y], [750+this.x, 110+this.y]]];
		    var downAreas:Array=[[[740+this.x, 146+this.y], [749+this.x, 155+this.y]]];
		    var closeArea:Array=[[[780+this.x, 88+this.y], [799+this.x, 104+this.y]]];
		    CollisionManager.getInstance().addCollision(closeArea,close_click,"close");
            CollisionManager.getInstance().addCollision(downAreas,down_click,"down");
		    CollisionManager.getInstance().addCollision(upAreas,up_click,"up");
		    
			CollisionManager.getInstance().showCollision();
		}
		
		private function up_click():void{
			
			if(textFiled.scrollV>1){
				
				textFiled.scrollV-=1;
			}
		
		}
		
	   private function down_click():void{
			if(textFiled.scrollV<textFiled.numLines){
				
				textFiled.scrollV+=1;
			}
		
		}

		private function close_click():void{
			
			 dispatchEvent(new CustomWindowEvent(CustomWindowEvent.WINDOW_CLOSE));			  
			 
		}
		
		private function removeAreas():void{
			
			CollisionManager.getInstance().removeCollision("close");
			CollisionManager.getInstance().removeCollision("down");
			CollisionManager.getInstance().removeCollision("up");
		}
		
		
		
		public function dispose():void{
			
			MemoryRecovery.getInstance().gcFun(swfPlayer,ProgressEvent.PROGRESS,on_flv_progress);
			MemoryRecovery.getInstance().gcFun(swfPlayer,Event.COMPLETE,on_swf_complete);
			MemoryRecovery.getInstance().gcObj(swfPlayer,true);
			MemoryRecovery.getInstance().gcObj(textFiled);
			removeAreas();
			
		}

	}
}