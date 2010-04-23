package core.manager.scriptManager
{
	public class ScriptName
	{
		public static const STARTRENDER:String="startRender";                  //3D全景开始渲染
		public static const STOPRENDER:String="stopRender";                    //3D全景停止渲染
		public static const DISABLE360SYSTEM:String="disable360System";        //关闭3D全景
		public static const ENABLE360SYSTEM:String="enable360System";          //开启3D全景
		public static const GOTO3DSCENE:String="goto3DScene";                  //去到指定的3D全景
		public static const GETCAMERA:String="getCamera";                      //获取3D全景的镜头
		public static const GOTOSCENE:String="gotoScene";                      //去到指定的场景，可能是2D，也可能是3D
		public static const SETCAMERA:String="setCamera";                      //设置镜头的角度和聚焦
		public static const SETCAMERAROTATIONX:String="setCameraRotationX";                      //设置镜头的RotationX
		public static const SETCAMERAROTATIONY:String="setCameraRotationY";                      //设置镜头的RotationY
		public static const SETCAMERAFOCUS:String="setCameraFocus";                      //设置镜头的聚焦
		public static const SETGOTOROTATION:String="setGotoRotation";                      //设置让镜头旋转(有缓动)
		public static const ADDCONTROLERCOMPLETESCRIPT:String="addControlerCompleteScript"; 
		//以下API名字在plugins/lxfa/flvModule/FlvBase里面初始化
		public static const SHOWFLV:String="showFlv";                          //显示flv
		public static const REMOVEFLV:String="removeFlv";                      //删除flv
		public static const INITONFLVPLAYCOMPLETESCRIPT:String="initOnFlvPlayCompleteScript";      //flv播放完毕
		//core/manager/pluginManager/PluginManager
		public static const SHOWPLUGINBYID:String="showPluginById";
		public static const SHOWSINGLEPLUGINBYID:String="showSinglePluginById";
		//core/manager/scriptManager/ScriptManager
		public static const RUNSCRIPTUNTILSCRIPTEXIST:String="runScriptUntilScriptExist";
		//plugins/lsd/AnimataPlayer/AnimatePlayerCtr
		public static const ADDANIMATE:String="addAnimate";                    //添加精灵
		public static const REMOVEANIMATE:String="removeAnimate";              //删除精灵
		//plugins/lxfa/inquire/InquireBase
		public static const SHOWINQUIRE:String="showInquire";              //显示询问是否前进的窗口
		//plugins/lxfa/chengshiguangying/ChengShiGuangYingBase
		public static const SHOWCHENGSHIGUANGYING:String="showChengShiGuangYing";              //显示城市光影
		//plugins/lsd/swfModule/SwfModuleBase
		public static const SHOWSWF:String="showSwf";                                          //显示SWF
		public static const ADDSWFINITSCRIPT:String="addSwfInitScript";                        //添加swf刚开始载入的时的脚本
		public static const ADDSWFCOMPLETESCRIPT:String="addSwfCompleteScript";                //添加SWF载入完毕时的脚本
		//plugins/lxfa/normalWindow/NormalWindowBase
		public static const SHOWNORMALWINDOW:String="showNormalWindow";                        //显示指定的标准窗
		public static const REMOVENORMALWINDOW:String="removeNormalWindow";                    //删除指定的标准窗
	}
}