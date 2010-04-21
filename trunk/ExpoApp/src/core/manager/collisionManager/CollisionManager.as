package core.manager.collisionManager
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import memory.MemoryRecovery;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	
	public class CollisionManager extends UIComponent
	{
		private static var instance:CollisionManager;
		private var rootAr:Array=new Array();//一种以数组进行存储
		private var rootObj:Object=new Object();//一种以对象的属性进行存储，用于删除
		private var container:*;
		public function CollisionManager()
		{
			if(instance==null){
				instance=this;
			}else{
				throw new Error("Cann't be new!");
			}
			container=DisplayObject(Application.application);
			Application.application.addEventListener(MouseEvent.CLICK,onClick);
		}
		public function init(dis:DisplayObject):void
		{
			if(dis!=null)
			{
				MemoryRecovery.getInstance().gcFun(container,MouseEvent.CLICK,onClick);
				container=dis;
				container.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		public function onClick(e:MouseEvent):Boolean
		{
			var obj:Object;//节点
			var array:Array;
			var pointLeftTop:Array;//左上角的点
			var pointRightBottom:Array;//右下角的点
			for(var i:int=0;i<rootAr.length;i++)
			{
				obj=rootAr[i];
				if(obj!=null)
				{
					array=obj.areas;
					for(var j:int=0;j<array.length;j++)
					{
						pointLeftTop=array[j][0];
						pointRightBottom=array[j][1];
						if(pointLeftTop==null || pointLeftTop.length<2 || pointRightBottom==null || pointRightBottom.length<2)
						{
							trace("区域节点数组的长度必需为2");
							break;
						}
						if(pointLeftTop[0]==pointRightBottom[0] || pointLeftTop[1]==pointRightBottom[1])
						{
							trace("区域节点的坐标重叠");
						}
						else if(pointLeftTop[0]<pointRightBottom[0])
						{
							if((e.stageX>pointLeftTop[0] && e.stageX<pointRightBottom[0]) && (e.stageY>pointLeftTop[1]&&e.stageY<pointRightBottom[1]))
							{
								excuteFunction(obj);
								break;//点到了，就开始检测其他区域
							}
						}
						else if(pointLeftTop[0]>pointRightBottom[0])
						{
							if((e.stageX<pointLeftTop[0] && e.stageX>pointRightBottom[0]) && (e.stageY<pointLeftTop[1]&&e.stageY>pointRightBottom[1]))
							{
								excuteFunction(obj);
								break;//点到了，就开始检测其他区域
							}
						}
					}
				}
			}
			return false;
		}
		private function excuteFunction(obj:Object):void
		{
			var fun:Function=obj.fun;
			if(fun==null){
				trace(fun+"碰撞体方法当前为空！");
			}
			var re:*;
			re=fun.apply(NaN,[]);
		}
		public static function getInstance():CollisionManager
		{
			if(instance==null) instance=new CollisionManager();
			return instance;
		}
		public function addCollision(array:Array,f:Function,ID:String):void
		{
			if(ID==null) throw new Error("碰撞体的名字不能为空");
			var obj:Object={areas:array,fun:f,id:rootAr.length,name:ID};
			rootObj[ID]=obj;//以OBJ的形式存储，用于索引
			rootAr.push(obj);//以数组的形式存储，用于遍历
		}
		public function removeAllCollision():void
		{
			rootAr=new Array();
			clearAllText();
			graphics.clear();
			showCollision();
		}
		public function removeCollision(id:String):void
		{
			if(rootObj[id]!=null)
			{
				rootAr[rootObj[id].id]=null;
			}
			graphics.clear();
		}
		private function clearAllText():void
		{
			if(textFieldArr!=null)
			{
				for each(var t:TextField in textFieldArr)
				{
					if(t!=null)
					{
						t.parent.removeChild(t);
						t=null;
					}
				}
			}
			textFieldArr=new Array();
		}
		private var textFieldArr:Array=new Array();
		public function showCollision():void
		{
			clearAllText();
			var obj:Object;//节点
			var array:Array;
			var pointLeftTop:Array;//左上角的点
			var pointRightBottom:Array;//右下角的点
			graphics.clear();
			graphics.lineStyle(1,0,100);
			for(var i:int=0;i<rootAr.length;i++)
			{
				obj=rootAr[i];
				if(obj!=null)
				{
					array=obj.areas;
					for(var j:int=0;j<array.length;j++)
					{
						pointLeftTop=array[j][0];
						pointRightBottom=array[j][1];
						var width:int=pointRightBottom[0]-pointLeftTop[0];
						var height:int=pointRightBottom[1]-pointLeftTop[1];
						graphics.drawRect(pointLeftTop[0],pointLeftTop[1],width,height);
						var t:TextField=new TextField();
						textFieldArr.push(t);
						t.mouseEnabled=false;
						if(obj.name==null)
						{
							t.text="";
						}
						else
						{
							t.text=obj.name;
						}
						this.addChild(t);
						t.x=pointLeftTop[0]+width/2;
						t.y=pointLeftTop[1]+height/2;
					}
				}
			}
			container.addChild(this);
		}
	}
}