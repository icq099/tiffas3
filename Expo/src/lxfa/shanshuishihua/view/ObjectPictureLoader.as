package lxfa.shanshuishihua.view
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]

	public class ObjectPictureLoader extends EventDispatcher
	{
		private var v_name_unit:Number;
		private var picture_name_pre:String;
		private var picture_type:String;
		
		private var v_count:int;
		private var h_count:int;
		private var offset_v:int;
		
		private var loader:BulkLoader;
		private var _picture:Array=new Array();
		
		public function ObjectPictureLoader()
		{
			super();
		}
		public function load(i_picture_name_pre:String,i_v_count:int,i_h_count:int,i_picture_type:String="jpg",i_v_name_unit:Number=10000,offset_v:int=0):void{
			
			try{
				
				if(loader!=null){
					
					loader.clear();
					
				}
				loader=new BulkLoader(i_picture_name_pre);
				
				picture_name_pre=i_picture_name_pre;
				v_count=i_v_count;
				h_count=i_h_count;
				picture_type=i_picture_type;
				v_name_unit=i_v_name_unit;
				this.offset_v=offset_v;
				
				loadPicture();
				
			}catch(e:Error){
				
				
			
			}
		
		}
		public function get picture():Array{
			
			return _picture;
		
		}
		private function loadPicture():void{
						
			for(var i:int=0;i<v_count;i++){
				
				
				
				for(var j:int=0;j<h_count;j++){
					
					var p_num:Number=(i+1)*v_name_unit+j+offset_v;
					loader.add(picture_name_pre+p_num+"."+picture_type);
					
				}
			}
			loader.start();
			loader.addEventListener(BulkProgressEvent.COMPLETE,onCompleteHandler);
			loader.addEventListener(BulkProgressEvent.PROGRESS,onProgressHandler);
		
		}
		private function onCompleteHandler(e:BulkProgressEvent):void{
			
			for(var i:int=0;i<v_count;i++){
				
				var array:Array=new Array()
				
				for(var j:int=0;j<h_count;j++){
					
					var p_num:Number=(i+1)*v_name_unit+j+offset_v;
					array.push(loader.getBitmap(picture_name_pre+p_num+"."+picture_type));
					
				}
				_picture.push(array);
			
			}
			loader.clear();
			dispatchEvent(new Event(Event.COMPLETE));
		
		}
		private function onProgressHandler(e:BulkProgressEvent):void{
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,e.itemsLoaded,e.itemsTotal));
		
		}
		
	}
}