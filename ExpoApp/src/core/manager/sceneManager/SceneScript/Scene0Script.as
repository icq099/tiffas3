package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene0Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				case -1:
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_FLV,["http://flv.pavilion.expo.cn/p5006/flv/scene_scene/_1_0.flv"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["showSinglePluginById(Pv3dModule);"]);
				ScriptManager.getInstance().runScriptUntilScriptExist("goto3DScene(0);");
				ScriptManager.getInstance().runScriptUntilScriptExist("setCameraRotationY(119.90);");
				ScriptManager.getInstance().runScriptUntilScriptExist("setCameraRotationX(0.8);");
				ScriptManager.getInstance().runScriptUntilScriptExist("setCameraFocus(375);");
                break;
				case 1:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/1_0.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.8,-65]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(0);"]);
				break;
				default:
				PluginManager.getInstance().showSinglePluginById("Pv3dModule");
				ScriptManager.getInstance().runScriptUntilScriptExist("setCameraRotationY(119.90);");
				ScriptManager.getInstance().runScriptUntilScriptExist("setCameraRotationX(0.8);");
				ScriptManager.getInstance().runScriptUntilScriptExist("setCameraFocus(375);");
				ScriptManager.getInstance().runScriptUntilScriptExist("goto3DScene(0);");
				break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				case -1:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[2]);//显示桂娃
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);//开始渲染
				break;
				case 1:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[2]);//显示桂娃
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);//开始渲染
                break;
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg1.mp3"]);
				break;
			}
		}
	}
}