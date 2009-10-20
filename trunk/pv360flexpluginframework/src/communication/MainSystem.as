package communication
{
	import communication.Event.ScriptAPIAddEvent;
	import communication.Event.ScriptEvent;
	import communication.camera.CameraProxy;
	
	import flash.events.EventDispatcher;
	
	[Event(name="add_api", type="communication.Event.ScriptAPIAddEvent")]
	[Event(name="run", type="communication.Event.ScriptEvent")]
	[Event(name="change", type="communication.Event.SceneChangeEvent")]
	[Event(name="run_by_function", type="communication.Event.ScriptEvent")]
	
	public class MainSystem extends EventDispatcher
	{
		private static var instance:MainSystem;
		private var _camera:CameraProxy;
		public function MainSystem()
		{
			if(instance==null){
				super(this);
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
		}
		/**
		 * 获得主系统的操作接口实例 
		 * @return 
		 * 
		 */		
		public static function getInstance():MainSystem{
			if(instance==null) instance=new MainSystem();
			return instance;
		}
		/**
		 * 直接设置相机转动（不推荐使用，应该使用camera属性） 
		 * @param rotaX
		 * @param rotaY
		 * 
		 */		
		public function setCameraRotaion(rotaX:Number=0,rotaY:Number=0):void{
			runAPIDirect("setCameraRotaion",[rotaX,rotaY]);
		}
		/**
		 * 添加应用接口 
		 * @param fun_name 接口方法名
		 * @param fun 接口对应该方法
		 * 
		 */		
		public function addAPI(fun_name:String,fun:Function):void{
			dispatchEvent(new ScriptAPIAddEvent(ScriptAPIAddEvent.ADD_API,fun_name,fun));
		}
		/**
		 * 运行simple scrip代码 
		 * @param script
		 * 
		 */		
		public function runScript(script:String):void{
			dispatchEvent(new ScriptEvent(ScriptEvent.RUN,script));
		}
		/**
		 * 直接在actionScript3中调用API 
		 * @param function_name API方法名
		 * @param parm	API参数数组
		 * 
		 */		
		public function runAPIDirect(function_name:String,parm:Array=null):void{
			dispatchEvent(new ScriptEvent(ScriptEvent.RUN_BY_FUNCTION,null,function_name,parm));		
		}
		/**
		 * 转到指定场景 
		 * @param scene_id 场景索引值
		 * 
		 */		
		public function gotoScene(scene_id:int):void{
			runAPIDirect("gotoScene",[scene_id]);
		}
		/**
		 * 显示指定插件 
		 * @param id 插件索引值
		 * 
		 */		
		public function showPluginById(id:int):void{
			runAPIDirect("showPluginById",[id]);
		}
		/**
		 * 删除指定插件
		 * @param id 插件索引值
		 * 
		 */		
		public function removePluginById(id:int):void{
			runAPIDirect("removePluginById",[id]);
		}
		/**
		 * 得到主相机对象 
		 * @return 
		 * 
		 */		
		public function get camera():CameraProxy{
			return _camera;
		}
		/**
		 * 设置主相机对象 
		 * @param value
		 * 
		 */		
		public function set camera(value:CameraProxy):void{
			_camera=value;
		}
		/**
		 * 全屏显示 
		 * 
		 */		
		public function fullScreen():void{
			runAPIDirect("fullScreen");
		}
		/**
		 * 取消全屏 
		 * 
		 */		
		public function normalScreen():void{
			runAPIDirect("normalScreen");
		}
	}
}