package yzhkof
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PositionSeter
	{
		private var left:Number;
		private var right:Number;
		private var top:Number;
		private var bottom:Number;
		private var horizontalCenter:Number;
		private var verticalCenter:Number;
		private var obj:InteractiveObject;
		
		public function PositionSeter(obj:InteractiveObject,position_obj:Object,use_basiceasproject:Boolean=false,weak_reference:Boolean=false){
			
			if(position_obj!=null){
				
				this.obj=obj;
				
				left=position_obj["x"];
				top=position_obj["y"];
				left=!isNaN(position_obj["left"])?position_obj["left"]:isNaN(left)?NaN:left;
				right=position_obj["right"];
				top=!isNaN(position_obj["top"])?position_obj["top"]:isNaN(top)?NaN:top;
				bottom=position_obj["bottom"];
				horizontalCenter=position_obj["horizontalCenter"];
				verticalCenter=position_obj["verticalCenter"];
				
				onReSize();
				
				var stage_obj:Stage=use_basiceasproject?BasicAsProject.mainStage:obj.stage;
				
				stage_obj.removeEventListener(Event.RESIZE,onReSize)
				stage_obj.addEventListener(Event.RESIZE,onReSize,false,0,weak_reference);
				
			}
		
		}
		private function onReSize(e:Event=null):void{
			
			var point:Point
			
			if(!isNaN(left)){
				
				point=obj.parent.globalToLocal(new Point(left,0));
				obj.x=point.x;
			
			}
			if(!isNaN(right)){
				
				point=obj.parent.globalToLocal(new Point(obj.stage.stageWidth-right,0));
				obj.x=point.x;
			}
			if(!isNaN(top)){
				
				point=obj.parent.globalToLocal(new Point(0,top));
				obj.y=point.y;
			
			}
			if(!isNaN(bottom)){
				
				point=obj.parent.globalToLocal(new Point(0,obj.stage.stageHeight-bottom));
				obj.y=point.y;
			
			}
			if(!isNaN(verticalCenter)){
				obj.y=obj.stage.stageHeight/2+verticalCenter;
			}
			if(!isNaN(horizontalCenter)){
				obj.x=obj.stage.stageWidth/2+horizontalCenter;
			}
		}

	}
}