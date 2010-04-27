package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene4Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				case 3:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/3_4.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,-995]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(4);"]);
				break;
				default:
				PluginManager.getInstance().showSinglePluginById("Pv3dModule");
				ScriptManager.getInstance().runScriptUntilScriptExist("goto3DScene(4);");
				break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				case 3:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[7]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				break;
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[45]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_X,[0.8]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[7]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg2.mp3"]);
				break;
			}
		}
	}
}