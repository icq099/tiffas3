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
		private var obj:InteractiveObject;
		
		public function PositionSeter(obj:InteractiveObject,position_obj:Object,use_basiceasproject:Boolean=false,weak_reference:Boolean=false){
			
			if(position_obj!=null){
				
				this.obj=obj;
				
				left=String(position_obj["x"]).length>0?position_obj["x"]:NaN;
				top=String(position_obj["y"]).length>0?position_obj["y"]:NaN;
				left=String(position_obj["left"]).length>0?position_obj["left"]:isNaN(left)?NaN:left;
				right=String(position_obj["right"]).length>0?position_obj["right"]:NaN;
				top=String(position_obj["top"]).length>0?position_obj["top"]:isNaN(top)?NaN:top;
				bottom=String(position_obj["bottom"]).length>0?position_obj["bottom"]:NaN;
				
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
		}

	}
}