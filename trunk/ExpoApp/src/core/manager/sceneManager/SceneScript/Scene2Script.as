package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene2Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				//锦绣华章-->美冠天下
				case 3:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/3_2.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,-820]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(2);"]);
				break;
		        //蓝色梦想-->美冠天下
				case 1:
				ScriptManager.getInstance().runScriptByName(ScriptName.CLEAR_YES_CLICK_SCRIPT,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_YES_CLICK_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/1_2.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["goto3DScene(2);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showInquire(4);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,125]);
				break;
			    //其他场景-->美冠天下
				default:
				PluginManager.getInstance().showSinglePluginById("Pv3dModule");
				ScriptManager.getInstance().runScriptUntilScriptExist("goto3DScene(2);");
				break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				//锦绣华章-->美冠天下
				case 3:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[5]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				break;
				//蓝色梦想-->美冠天下
				case 1:
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[77.3192146134986]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_X,[0.8]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[5]);
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg2.mp3"]);
				break;
				//其他场景-->美冠天下
				default:ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_Y,[77.3192146134986]);
				        ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_ROTATION_X,[0.8]);
				        ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA_FOCUS,[375]);
				        ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[5]);
				        ScriptManager.getInstance().runScriptByName(ScriptName.START_RENDER,[]);
				        ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				        ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg2.mp3"]);
				       break;
			}
		}
	}
}