package  plugins.lxfa.shanshuishihua
{
	import core.manager.pluginManager.PluginManager;
	import core.manager.scriptManager.ScriptManager;
	import core.manager.scriptManager.ScriptName;
	
	import flash.events.MouseEvent;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import mx.core.UIComponent;
	
	import plugins.lxfa.chengshiguangying.FlatWall3D_Reflection;
	public class ShanShuiShiHua extends UIComponent
	{
		private var shanShuiShiHuaSwc:ShanShuiShiHuaSwc;
		private var flatWall3D_Reflection:FlatWall3D_Reflection;
		private var minMouseX:Number=256;//滑块的最小X坐标
		private var maxMouseX:Number=510;//滑块的最大X坐标
		private var offset:Number=5;    //点击左（右）按钮，滑块的偏移量
		public function ShanShuiShiHua()
		{
			init();
		}
		private function init():void
		{
			
			ScriptManager.getInstance().runScriptByName(ScriptName.STOPRENDER,[]);
			shanShuiShiHuaSwc=new ShanShuiShiHuaSwc();
			this.addChild(shanShuiShiHuaSwc);
			initFlatWall3D_Reflection();
		}
		private function initFlatWall3D_Reflection():void
		{
			flatWall3D_Reflection=new FlatWall3D_Reflection(51);
			flatWall3D_Reflection.x=14;
			flatWall3D_Reflection.y=80;
			this.addChild(flatWall3D_Reflection);
			shanShuiShiHuaSwc.close.addEventListener(MouseEvent.CLICK,onCloseClick);
		}
		//关闭按钮点击事件
		private function onCloseClick(e:MouseEvent):void
		{
			PluginManager.getInstance().removePluginById("ShanShuiShiHuaModule");
		}
		public function dispose():void
		{
			MemoryRecovery.getInstance().gcFun(shanShuiShiHuaSwc.close,MouseEvent.CLICK,onCloseClick);
			if(shanShuiShiHuaSwc.left!=null)
			{
				if(shanShuiShiHuaSwc.left.parent!=null)
				{
					shanShuiShiHuaSwc.left.parent.removeChild(shanShuiShiHuaSwc.left);
				}
				shanShuiShiHuaSwc.left=null;
			}
			if(shanShuiShiHuaSwc.right!=null)
			{
				if(shanShuiShiHuaSwc.right.parent!=null)
				{
					shanShuiShiHuaSwc.right.parent.removeChild(shanShuiShiHuaSwc.right);
				}
				shanShuiShiHuaSwc.right=null;
			}
			if(shanShuiShiHuaSwc.close!=null)
			{
				if(shanShuiShiHuaSwc.close.parent!=null)
				{
					shanShuiShiHuaSwc.close.parent.removeChild(shanShuiShiHuaSwc.close);
				}
				shanShuiShiHuaSwc.close=null;
			}
			if(flatWall3D_Reflection!=null)
			{
				if(flatWall3D_Reflection.parent!=null)
				{
					flatWall3D_Reflection.parent.removeChild(flatWall3D_Reflection);
				}
				flatWall3D_Reflection.dispose();
				flatWall3D_Reflection=null;
			}
			if(shanShuiShiHuaSwc!=null)
			{
				
				if(shanShuiShiHuaSwc.parent!=null)
				{
					shanShuiShiHuaSwc.parent.removeChild(shanShuiShiHuaSwc);
				}
				shanShuiShiHuaSwc=null;
			}
			ScriptManager.getInstance().runScriptByName(ScriptName.STARTRENDER,[]);
			MyGC.gc();
		}
	}
}