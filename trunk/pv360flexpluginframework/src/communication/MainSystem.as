package communication
{
	import communication.Event.MainSystemEvent;
	import communication.Event.SceneChangeEvent;
	import communication.Event.ScriptAPIAddEvent;
	import communication.Event.ScriptEvent;
	import communication.camera.CameraProxy;
	
	import flash.events.EventDispatcher;
	
	import scripsimple.ScriptSimple;
	
	[Event(name="init", type="communication.Event.MainSystemEvent")]
	[Event(name="on_plugin_ready", type="communication.Event.MainSystemEvent")]
	[Event(name="add_api", type="communication.Event.ScriptAPIAddEvent")]
	[Event(name="run", type="communication.Event.ScriptEvent")]
/**
* 当场景切换完毕时发送此事件
*/	
	[Event(name="change", type="communication.Event.SceneChangeEvent")]
	[Event(name="run_by_function", type="communication.Event.ScriptEvent")]
	/**
	 * 此类封装对全景主系统的所有操作
	 * @author yzhkof
	 * 
	 */	
	public class MainSystem extends EventDispatcher
	{
		private static var instance:MainSystem;
		private var _camera:CameraProxy;
		private var _script_runer:ScriptSimple;
		private var _currentScene:int;
		
		public function MainSystem()
		{
			if(instance==null){
				super(this);
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
			init();
		}
		private function init():void{
			addEventListener(SceneChangeEvent.CHANGE,onSceneChange);	
			addEventListener(MainSystemEvent.INIT,onSystemInit);
		}
		private function onSystemInit(e:MainSystemEvent):void{
			_camera=e.camera;
			_script_runer=e.script_runer;
		}
		private function onSceneChange(e:SceneChangeEvent):void{
			_currentScene=e.id;
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
		 * 设置相机focus（不推荐使用，应该使用camera属性）
		 * @param value
		 * 
		 */		
		public function setCameraFocus(value:Number):void{
			runAPIDirect("setCameraFocus",[value]);
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
		public function runAPIDirect(function_name:String,parm:Array=null):*{
			return _script_runer.runFunctionDirect(function_name,parm);
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
		public function showPluginById(id:String):void{
			runAPIDirect("showPluginById",[id]);
		}
		/**
		 * 删除指定插件
		 * @param id 插件索引值
		 * 
		 */
		public function removePluginById(id:String):void{
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
		/**
		 * 当前场景索引值 
		 * @return 
		 * 
		 */		
		public function get currentScene():int{
			return _currentScene;
		}
	}
}