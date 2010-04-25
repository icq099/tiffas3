package core.manager.scriptManager
{
	public class ScriptName
	{
		public static const START_RENDER:String="startRender";                  //3D全景开始渲染
		public static const STOP_RENDER:String="stopRender";                    //3D全景停止渲染
		public static const DISABLE_360_SYSTEM:String="disable360System";        //关闭3D全景
		public static const ENABLE_360_SYSTEM:String="enable360System";          //开启3D全景
		public static const GOTO_3D_SCENE:String="goto3DScene";                  //去到指定的3D全景
		public static const GET_CAMERA:String="getCamera";                      //获取3D全景的镜头
		public static const GO_TO_SCENE:String="gotoScene";                      //去到指定的场景，可能是2D，也可能是3D
		public static const SET_CAMERA:String="setCamera";                      //设置镜头的角度和聚焦
		public static const SET_CAMERA_ROTATION_X:String="setCameraRotationX";                      //设置镜头的RotationX
		public static const SET_CAMERA_ROTATION_Y:String="setCameraRotationY";                      //设置镜头的RotationY
		public static const SET_CAMERA_FOCUS:String="setCameraFocus";                      //设置镜头的聚焦
		public static const SET_GOTO_ROTATION:String="setGotoRotation";                      //设置让镜头旋转(有缓动)
		public static const ADD_CONTROLER_COMPLETE_SCRIPT:String="addControlerCompleteScript"; 
		//以下API名字在plugins/lxfa/flvModule/FlvBase里面初始化
		public static const SHOW_FLV:String="showFlv";                          //显示flv
		public static const REMOVE_FLV:String="removeFlv";                      //删除flv
		public static const INIT_ON_FLV_PLAY_COMPLETE_SCRIPT:String="initOnFlvPlayCompleteScript";      //flv播放完毕
		//core/manager/pluginManager/PluginManager
		public static const SHOW_PLUGIN_BY_ID:String="showPluginById";                        //添加插件
		public static const SHOW_SINGLE_PLUGIN_BY_ID:String="showSinglePluginById";           //添加唯一的插件，插件不能重复
		public static const POPUP_PLUGIN_BY_ID:String="popupPluginById";                       //用PopupManager显示指定的插件
		//core/manager/scriptManager/ScriptManager
		public static const RUN_SCRIPT_UNTIL_SCRIPT_EXIST:String="runScriptUntilScriptExist";
		//plugins/lsd/AnimataPlayer/AnimatePlayerCtr
		public static const ADD_ANIMATE:String="addAnimate";                    //添加精灵
		public static const REMOVE_ANIMATE:String="removeAnimate";              //删除精灵
		//plugins/lxfa/inquire/InquireBase
		public static const SHOW_INQUIRE:String="showInquire";              //显示询问是否前进的窗口
		public static const ADD_YES_CLICK_SCRIPT:String="addYesClickScript";              //添加点击了yes按钮之后，要触发的脚本
		public static const CLEAR_YES_CLICK_SCRIPT:String="clearYesClickScript"; 
		//plugins/lxfa/chengshiguangying/ChengShiGuangYingBase
		public static const SHOW_CHENG_SHI_GUANG_YING:String="showChengShiGuangYing";              //显示城市光影
		//plugins/lsd/swfModule/SwfModuleBase
		public static const SHOW_SWF:String="showSwf";                                          //显示SWF
		public static const ADD_SWF_INIT_SCRIPT:String="addSwfInitScript";                        //添加swf刚开始载入的时的脚本
		public static const ADD_SWF_COMPLETE_SCRIPT:String="addSwfCompleteScript";                //添加SWF载入完毕时的脚本
		//plugins/lxfa/normalWindow/NormalWindowBase
		public static const SHOW_NORMAL_WINDOW:String="showNormalWindow";                        //显示指定的标准窗
		public static const REMOVE_NORMAL_WINDOW:String="removeNormalWindow";                    //删除指定的标准窗
		//core/manager/scriptManager/ScriptManager
		public static const LOAD_BACKGROUND_MUSIC:String="loadBackGroundMusic";                    //加载背景音乐
		public static const DISPOSE_BACKGROUND_MUSIC:String="disposeBackGroundMusic";                    //加载背景音乐
	}
}