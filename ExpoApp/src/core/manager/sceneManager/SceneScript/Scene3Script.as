package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene3Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				//美冠天下-->锦绣华章
				case 2:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/2_3.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,77.3192146134986]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(3);"]);
				break;
				//盛世和韵-->锦绣华章
				case 4:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/4_3.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,-110.89836409391609]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(3);"]);
				break;
				//其他场景-->锦绣华章
				default:
				PluginManager.getInstance().showSinglePluginById("Pv3dModule");
				ScriptManager.getInstance().runScriptUntilScriptExist("goto3DScene(3);");
				break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				//美冠天下-->锦绣华章
				case 2:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[80.68719476736166]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[6]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				break;
				//盛世和韵-->锦绣华章
				case 4:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[-97.46941167807918]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[6]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				break;
				//其他场景-->锦绣华章
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[35.68719476736166]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_X,[0.8]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[6]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg2.mp3"]);
				break;
			}
		}
	}
}