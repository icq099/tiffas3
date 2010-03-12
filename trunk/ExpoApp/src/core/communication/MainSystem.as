package core.communication
{
	import core.communication.Event.MainSystemEvent;
	import core.communication.Event.ScriptAPIAddEvent;
	import core.communication.Event.ScriptEvent;
	import core.communication.camera.CameraProxy;
	import core.scripsimple.ScripSimpleAPI;
	import core.scripsimple.ScriptSimple;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import util.HashMap;
	
	[Event(name="init", type="communication.Event.MainSystemEvent")]
/**
* 当显示初始化完成后发送此事件(360场景与插件容器) 
*/	
	[Event(name="init_display", type="communication.Event.MainSystemEvent")]
	[Event(name="on_plugin_ready", type="communication.Event.MainSystemEvent")]
	[Event(name="add_api", type="communication.Event.ScriptAPIAddEvent")]
	[Event(name="remove_api", type="communication.Event.ScriptAPIAddEvent")]
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
		private var _script_simple_api:ScripSimpleAPI;
		private var _currentScene:int;
		private var _plugin_map:HashMap=new HashMap();
				
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
			_script_simple_api=new ScripSimpleAPI();
			_script_runer=new ScriptSimple(_script_simple_api);
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
		 * 得到插件引用 
		 * @param id 插件的id名
		 * @return 
		 * 
		 */		
		public function getPlugin(id:String):DisplayObject{
			return _plugin_map.getValue(id) as DisplayObject;
		}
		main_system function addPlugin(name:String,plugin:DisplayObject):void{
			_plugin_map.put(name,plugin);
		}
		main_system function removePlugin(name:String):void{
			_plugin_map.remove(name);
		}
		/**
		 * 添加应用接口 
		 * @param fun_name 接口方法名
		 * @param fun 接口对应该方法
		 * 
		 */		
		public function addAPI(fun_name:String,fun:Function):void{
			_script_simple_api.addAPI(fun_name,fun);
		}
		/**
		 *	移除应用接口 
		 * @param fun_name 接口方法名
		 * 
		 */		
		public function removeAPI(fun_name:String):void{
			dispatchEvent(new ScriptAPIAddEvent(ScriptAPIAddEvent.REMOVE_API,fun_name));
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
		/**
		 * 开始渲染场景 
		 * 
		 */		
		public function startRender():void{
			runAPIDirect("startRender");
		}
		/**
		 * 停止渲染场景 
		 * 
		 */		
		public function stopRender():void{
			runAPIDirect("stopRender");
		}
		/**
		 * 更新单幅画面 
		 * 
		 */		
		public function updataScene():void{
			runAPIDirect("updataScene");
		}
		/**
		 * 启动全景系统； 
		 * 
		 */		
		public function enable360System():void{
			runAPIDirect("enable360System");
		}
		/**
		 * 关闭全景系统; 
		 * 
		 */		
		public function disable360System():void{
			runAPIDirect("disable360System");
		}
	}
}