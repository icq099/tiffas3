package core.manager.sceneManager.SceneScript
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	public class Scene6Script
	{
		public static function runSceneInitScript(fromId:int):void
		{
			switch(fromId)
			{
				case 5:
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.CLEAR_YES_CLICK_SCRIPT,[]);
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_YES_CLICK_SCRIPT,["showFlv(http://flv.pavilion.expo.cn/p5006/flv/scene_scene/zonghengsihai_yangmengbagui.flv);"]);
				ScriptManager.getInstance().runScriptByName(ScriptName.SHOW_INQUIRE,[10]);
				ScriptManager.getInstance().runScriptByName(ScriptName.INIT_ON_FLV_PLAY_COMPLETE_SCRIPT,["showPluginById(YangMengBaGuiModule);"]);
				break;
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.DISPOSE_BACKGROUND_MUSIC,[]);
				PluginManager.getInstance().showSinglePluginById("YangMengBaGuiModule");
				break;
			}
		}
		public static function runSceneJustCompleteScript(fromId:int):void
		{
			switch(fromId)
			{
				case 5:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[11]);
				break;
				default:
				ScriptManager.getInstance().runScriptByName(ScriptName.ADD_ANIMATE,[11]);
				break;
			}
		}
	}
}