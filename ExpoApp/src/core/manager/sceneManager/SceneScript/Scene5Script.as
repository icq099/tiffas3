package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene5Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				case 4:
				ScriptManager.getInstance().runScriptByName(ScriptName.CLEAR_YES_CLICK_SCRIPT,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_YES_CLICK_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/4_zonghengsihai.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["showSwf(swf/zongHengSiHai.swf);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["showInquire(8);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_CONTROLER_COMPLETE_SCRIPT,["stopRender();"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SET_CAMERA,[0.3,80]);
				break;
				case 7:
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_FLV,["http://flv.pavilion.expo.cn/p5006/flv/scene_scene/fz_gx1.flv"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["showSwf(swf/zongHengSiHai.swf);"]);
				break;
				case 8:
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_FLV,["http://flv.pavilion.expo.cn/p5006/flv/scene_scene/mgh_gx1.flv"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["showSwf(swf/zongHengSiHai.swf);"]);
				break;
				case 9:
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_FLV,["http://flv.pavilion.expo.cn/p5006/flv/scene_scene/dm_gx1.flv"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["showSwf(swf/zongHengSiHai.swf);"]);
				break;
				default:
				PluginManager.getInstance().showSinglePluginById("SwfModule");
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_SWF,["swf/zongHengSiHai.swf"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.LOAD_BACKGROUND_MUSIC,["http://audio.pavilion.expo.cn/p5006/audio/backgroundmusic/bg3.mp3"]);
				break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				case 4:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[9]);
				break;
				case 7:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[9]);
				break;
				case 8:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[9]);
				break;
				case 9:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[9]);
				break;
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[9]);
				break;
			}
		}
	}
}