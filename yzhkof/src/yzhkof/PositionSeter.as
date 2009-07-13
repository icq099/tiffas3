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
		
		public function PositionSeter(obj:InteractiveObject,position_obj:Object,use_basiceasproject:Boolean=false){
			
			if(position_obj!=null){
				
				this.obj=obj;
					
				left=position_obj["left"];
				right=position_obj["right"];
				top=position_obj["top"];
				bottom=position_obj["bottom"];
				
				onReSize();
				
				var stage_obj:Stage=use_basiceasproject?BasicAsProject.mainStage:obj.stage;
				
				stage_obj.removeEventListener(Event.RESIZE,onReSize)
				stage_obj.addEventListener(Event.RESIZE,onReSize,false,0,false);
				
			}
		
		}
		private function onReSize(e:Event=null):void{
			
			var point:Point
			
			if(left){
				
				point=obj.parent.globalToLocal(new Point(left,0));
				obj.x=point.x;
			
			}else if(right){
				
				point=obj.parent.globalToLocal(new Point(obj.stage.stageWidth-right,0));
				obj.x=point.x;
			}
			if(top){
				
				point=obj.parent.globalToLocal(new Point(0,top));
				obj.y=point.y;
			
			}else if(bottom){
				
				point=obj.parent.globalToLocal(new Point(0,obj.stage.stageHeight-bottom));
				obj.y=point.y;
			
			}
		}

	}
}