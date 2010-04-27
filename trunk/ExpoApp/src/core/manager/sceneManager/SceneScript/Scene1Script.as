package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene1Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				//绿色家园-->蓝色梦想
				case 0:ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/0_1.flv);"]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,100]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(1);"]);
				       break;
				//美冠天下-->蓝色梦想
				case 2:ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["goto3DScene(1);"]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,260.68719476736166]);
				       break;
				//其他场景-->蓝色梦想
				default:PluginManager.getInstance().showSinglePluginById("Pv3dModule");
				        ScriptManager.getInstance().runScriptUntilScriptExist("goto3DScene(1);");
				        break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				//绿色家园-->蓝色梦想
				case 0:ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[122.49997387278513]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[3]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				       break;
				//美冠天下-->蓝色梦想
				case 2:ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[122.49997387278513]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[3]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				       ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg1.mp3"]);
                       break;
                //其他场景-->蓝色梦想
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[62.49997387278513]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_X,[0.8]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[3]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg1.mp3"]);
				break;
			}
		}
	}
}