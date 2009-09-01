package view
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import gs.TweenLite;

	public class MapDirector extends Sprite
	{
		[Embed(source="asset/MapBack.png",scaleGridTop="40",scaleGridBottom="310",scaleGridLeft="13",scaleGridRight="277")]
		private static var MapBackGround:Class;
		[Embed (source="asset/Map.swf",symbol="ExhibitPoint")]
		private static var ExhibitPoint:Class;
		[Embed (source="asset/Map.swf",symbol="MapLookPoint")]
		private static var MapLookPoint:Class;
		
		private const offset_v:Number=50;
		private const offset_h:Number=15;
		private var right_bottom_button:RightBottomButton=new RightBottomButton();
		private var map_back:Sprite=new MapBackGround();
		private var map_container:Sprite=new Sprite;
		private var clickpoint_sprit:Sprite=new Sprite();
		private var exhibitpoint_sprite:Sprite=new Sprite();
		private var bitmap:DisplayObject;
		private var tool_tip:MapToolTip=new MapToolTip();
		private var look_point_container:Sprite=new Sprite();
		private var look_point:Sprite=new MapLookPoint();
		private var close_btn:Button_Close=new Button_Close();
		private var left_up_text:MapText=new MapText();
		
		private var d_width:Number;
		private var d_height:Number;
		
		private var m_loader:Loader;
		private var state:String=MAP_HIDE;
		
		private const MAP_HIDE:String="MAP_HIDE";
		private const MAP_SHOW:String="MAP_SHOW";
		
		private var _look_point_position:int;
		private var tool_tip_text:Object=new Object();
		public var click_points:Array=new Array();
		
		public function MapDirector()
		{
			init();
			initListener();
		}
		private function init():void{
			
			addChild(right_bottom_button)
			
			clickpoint_sprit.x=offset_h;
			clickpoint_sprit.y=offset_v;
			look_point_container.addChild(look_point);
			look_point_container.x=offset_h
			look_point_container.y=offset_v;
			exhibitpoint_sprite.x=offset_h
			exhibitpoint_sprite.y=offset_v;
			
			map_back.alpha=0;
			clickpoint_sprit.alpha=0;
			exhibitpoint_sprite.alpha=0;
			look_point_container.alpha=0;
			close_btn.alpha=0;
			left_up_text.alpha=0;
			
			addChild(map_container);
			
			tool_tip.mouseChildren=false;
			tool_tip.mouseEnabled=false;
			//设置效果
			look_point.blendMode=BlendMode.ADD;
			
		
		}
		private function initDisplayObject():void{
			
			bitmap.x=offset_h
			bitmap.y=offset_v;
			bitmap.alpha=0;
		
		}
		private function initListener():void{
			
			right_bottom_button.addEventListener("map_click",mapBtnClickHandler);
			right_bottom_button.addEventListener("help_click",function(e:Event):void{
				
				dispatchEvent(new Event("help_click"));
			
			});
			close_btn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			/* map_container.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				
				debugTrace("x=\""+bitmap.mouseX+"\"","y=\""+bitmap.mouseY+"\"")
			
			}) */
		
		}
		public function addClickPoint(x:Number,y:Number,tool_tip_text:String=""):Sprite{
			
			var point:Sprite=new ClickPoint();
			click_points.push(point);
			point.x=x;
			point.y=y;
			clickpoint_sprit.addChild(point);
			this.tool_tip_text[point.name]=tool_tip_text;
			point.addEventListener(MouseEvent.ROLL_OVER,exhibitPointMouseOverHandler);
			point.addEventListener(MouseEvent.ROLL_OUT,exhibitPointMouseOutHandler);
			
			return point;
			
		}
		public function setLookPosition(goto:int):void{
			
			if(click_points[goto]==null){
				
				look_point.visible=false;
			
			}else{
				
				look_point.visible=true;
				look_point.x=click_points[goto].x;
				look_point.y=click_points[goto].y;
				click_points[goto].gotoAndStop(2);
			
			}
		
		}
		public function set look_rotationX(value:Number):void{
			
			look_point.scaleX=1-Math.abs(value)/90;
		
		}
		public function set look_rotationY(value:Number):void{
			
			look_point.rotation=value;
			look_point.rotation-=180;
		
		}
		public function set text(value:String):void{
			
			left_up_text.text=value;
		
		}
		public function addExhibitPoint(x:Number,y:Number,tool_tip_text:String="展项"):void{
			
			var point:Sprite=new ExhibitPoint();
			point.x=x;
			point.y=y;
			exhibitpoint_sprite.addChild(point);
			this.tool_tip_text[point.name]=tool_tip_text;
			point.mouseChildren=false;
			point.addEventListener(MouseEvent.ROLL_OVER,exhibitPointMouseOverHandler);
			point.addEventListener(MouseEvent.ROLL_OUT,exhibitPointMouseOutHandler);
		
		}
		public function setMap(URL:String):void{
			
			m_loader=new Loader();
			m_loader.load(new URLRequest(URL));
			m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,mapCompleteHandler);
		
		}
		private function exhibitPointMouseOverHandler(e:Event):void{
			
			if(tool_tip_text[e.currentTarget.name]?tool_tip_text[e.currentTarget.name].length>0:false){
				addChild(tool_tip);
				tool_tip.alpha=0;
				tool_tip.x=mouseX-20;
				tool_tip.y=mouseY;
				tool_tip.text=tool_tip_text[e.currentTarget.name];
				
				TweenLite.to(tool_tip,0.4,{alpha:1,x:(stage.mouseX+tool_tip.width/2)>stage.stageWidth?globalToLocal(new Point(stage.stageWidth-tool_tip.width/2)).x:mouseX});
			}
		
		}
		private function exhibitPointMouseOutHandler(e:Event):void{
			
			TweenLite.to(tool_tip,0.4,{alpha:0,x:"-20",onComplete:function():void{
				
				if(tool_tip.stage!=null){
					
					removeChild(tool_tip);
					
				}
			
			}});
		
		}
		private function mapCompleteHandler(e:Event):void{
			
			//bitmap.bitmapData=m_loader.content as BitmapData;
			//map_container.addChild(m_loader.content);
			
			bitmap=m_loader.content;
			initDisplayObject();
			
			map_back.width=bitmap.width+offset_h*2;
			map_back.height=bitmap.height+offset_v+13;
			map_container.x=-map_back.width+130;
			map_container.y=-map_back.height+80;
			close_btn.x=map_back.width-35;
			close_btn.y=13;
			left_up_text.x=left_up_text.y=13;
			
		}
		private function mapBtnClickHandler(e:Event):void{
			
			if(state==MAP_HIDE){
								
				map_container.addChild(map_back);
				map_container.addChild(bitmap);
				map_container.addChild(exhibitpoint_sprite);
				map_container.addChild(look_point_container);
				map_container.addChild(clickpoint_sprit);
				map_container.addChild(close_btn);
				map_container.addChild(left_up_text);
				
				//new TweenGroup([{target:map_back,time:1,alpha:1,scaleX:t_scalex,ease:Strong.easeOut},{target:map_back,time:1,alpha:1,scaleY:t_scaley,ease:Strong.easeOut}],null,TweenGroup.ALIGN_SEQUENCE);
				TweenLite.to(map_back,0.7,{alpha:1});
				TweenLite.to(close_btn,0.7,{alpha:1,delay:1});
				TweenLite.to(left_up_text,0.7,{alpha:1,delay:1});
				TweenLite.to(clickpoint_sprit,1,{alpha:1,delay:1});
				TweenLite.to(bitmap,1,{alpha:1,delay:0.7});
				TweenLite.to(exhibitpoint_sprite,0.5,{alpha:1,delay:1.5});
				TweenLite.to(look_point_container,0.5,{alpha:1,delay:1.5});
				
				state=MAP_SHOW;
				
			}
		
		}
		private function closeClickHandler(e:Event):void{
			
			if(state==MAP_SHOW){
				
				TweenLite.to(map_back,0.7,{alpha:0,delay:0.9,onComplete:function():void{
					
					map_container.removeChild(clickpoint_sprit);
					map_container.removeChild(exhibitpoint_sprite);
					map_container.removeChild(map_back);
					map_container.removeChild(bitmap);
					map_container.removeChild(look_point_container);
					map_container.removeChild(close_btn);
					map_container.removeChild(left_up_text);
				
				}});
				TweenLite.to(close_btn,0.7,{alpha:0});
				TweenLite.to(left_up_text,0.7,{alpha:0});
				TweenLite.to(exhibitpoint_sprite,0.3,{alpha:0});
				TweenLite.to(clickpoint_sprit,0.6,{alpha:0});
				TweenLite.to(bitmap,0.6,{alpha:0,delay:0.3});
				TweenLite.to(look_point_container,0.6,{alpha:0});
				
				state=MAP_HIDE;
			
			}
		
		}
	}
}