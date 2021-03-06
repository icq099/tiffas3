package util.menu.popumenu.view
{
	import core.manager.scriptManager.ScriptManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.Application;
	
	import util.menu.popumenu.model.PopupMenuModel;
	
	public class PopupMenu extends Sprite
	{
		private var popupMenuModel:PopupMenuModel
		private var items:Array;
		private var menuItems:Array;
		private var currentHeight:int=0;
		private var secondPopupMenus:Array=new Array();
		private var tf:TextFormat=new TextFormat  
		public function PopupMenu(obj:*,id:int)
		{
			initModel(id);
			initLocation(obj);
			tf.kerning=true  //间距开启
			tf.letterSpacing=8  //间距大小
			obj.addEventListener(MouseEvent.CLICK,click);
			Application.application.addEventListener(MouseEvent.MOUSE_DOWN,on_click_others);
		}
		private function initLocation(obj:*):void
		{
			this.x=obj.x;
			this.y=obj.y+obj.height+80;
			if(this.x+245>900)
			{
				this.x=900-245;
			}
		}
		private function on_click_others(e:MouseEvent):void
		{
			if(e.target.parent!=null)
			{
				var name:String=getQualifiedClassName(e.target.parent);
				if(this.parent!=null && name!="util.menu.popumenu.view::PopupMenu" &&name!="MainMenuTopSwc" &&name!="util.menu.popumenu.view::SecondPopupMenu")
				{
					this.parent.removeChild(this);
				}
			}
		}
		private function click(e:MouseEvent):void
		{
			e.currentTarget.parent.addChild(this);
		}
		private function initModel(id:int):void
		{
			popupMenuModel=new PopupMenuModel(id);
			on_model_complete();
		}
		private function on_model_complete():void
		{
			items=popupMenuModel.getItems();
			menuItems=popupMenuModel.getMenuItems();
			createItems();
			createMenuItems();
			createSecondPopupMenus();
		}
		private function createItems():void
		{
			var pup:PopuMenuUp=new PopuMenuUp();
			this.addChild(pup);
			currentHeight+=pup.height;
			for(var i:int=0;i<items.length;i++)
			{
				this.addChild(createItem(items[i].name,items[i].script));
			}
		}
		private var filter:GlowFilter=new GlowFilter(0xffff3,1,30,30);
		private function createItem(name:String,script:String):PopuMenuRect
		{
			var popr:PopuMenuRect=new PopuMenuRect();
			popr.y=currentHeight;
			currentHeight+=popr.height;
			if(name!=null && name!="")
			{
				popr.text.text=name;
				popr.text.setTextFormat(tf,0,name.length);
			}
			popr.text.mouseEnabled=false;
			popr.buttonMode=true;
			popr.addEventListener(MouseEvent.CLICK,function():void{
				removeMyShelf();
				ScriptManager.getInstance().runScriptDirectly(script);
			});
			popr.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void{
				removeAllSecondPopupMenu();
				popr.text.filters=[filter];
			});
			popr.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void{
				popr.text.filters=[];
			});
			return popr;
		}
		private function createMenuItems():void
		{
			for(var i:int=0;i<menuItems.length;i++)
			{
				this.addChild(createMenuItem(menuItems[i].name,i));
			}
			var pup:PopuMenuDown=new PopuMenuDown();
			pup.y+=currentHeight;
			currentHeight+=pup.height;
			this.addChild(pup);
		}
		private function createMenuItem(name:String,id:int):PopuMenuV
		{
			var popv:PopuMenuV=new PopuMenuV();
			popv.y=currentHeight;
			currentHeight+=popv.height;
			if(name!=null && name!="")
			{
				popv.text.text=name;
				popv.text.setTextFormat(tf,0,name.length);
			}
			popv.name=String(id);//到时候以这个name去取2级菜单
			popv.text.mouseEnabled=false;
			popv.buttonMode=true;
			popv.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void{
				removeAllSecondPopupMenu();
				var dis:DisplayObject=secondPopupMenus[int(popv.name)];
				addChild(dis);
				dis.x=popv.x+popv.width;
				dis.y=popv.y;
				if(x+dis.x+172>900)
				{
					dis.x=popv.x-172;
				}
			});
			return popv;
		}
		private function removeAllSecondPopupMenu():void
		{
			for(var i:int=0;i<secondPopupMenus.length;i++)
			{
				var dis:DisplayObject=secondPopupMenus[i];
				if(dis!=null && dis.parent!=null)
				{
					dis.parent.removeChild(dis);
				}
			}
		}
		private function createSecondPopupMenus():void
		{
			for(var i:int=0;i<menuItems.length;i++)
			{
				secondPopupMenus.push(createSecondPopupMenu(i));
			}
		}
		private function createSecondPopupMenu(id:int):SecondPopupMenu
		{
			currentHeight=0;
			var container:SecondPopupMenu=new SecondPopupMenu();
			var up:PopuMenuUp1=new PopuMenuUp1();
			container.addChild(up);
			currentHeight+=up.height;
			for(var i:int=0;i<menuItems[id].detail.length;i++)
			{
				container.addChild(createSecondItem(menuItems[id].detail[i].name,menuItems[id].detail[i].script));
			}
			var down:PopuMenuDown1=new PopuMenuDown1();
			down.y=currentHeight;
			container.addChild(down);
			return container;
		}
		private function createSecondItem(name:String,script:String):PopuMenuMenuCenter1
		{
			var popr:PopuMenuMenuCenter1=new PopuMenuMenuCenter1();
			popr.y=currentHeight;
			currentHeight+=popr.height;
			if(name!=null && name!="")
			{
				popr.text.text=name;
				popr.text.setTextFormat(tf,0,name.length);
			}
			popr.text.mouseEnabled=false;
			popr.buttonMode=true;
			popr.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				removeMyShelf();
				ScriptManager.getInstance().runScriptDirectly(script);
			});
			popr.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void{
				popr.text.filters=[filter];
			});
			popr.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void{
				popr.text.filters=[];
			});
			return popr;
		}
		private function removeMyShelf():void
		{
			if(this.parent!=null)
			{
				this.parent.removeChild(this);
			}
		}
	}
}