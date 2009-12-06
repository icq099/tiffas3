package view.leftupmenu
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	import mx.containers.Canvas;

	public class LeftUpMenuContainer extends Canvas
	{
		private var menu_button:LeftUpMenuButton=new LeftUpMenuButton();
		private var menu_panel_array:Array;
		private var pop_up_sub_menu:SubMenu;
		private var is_pop_up:Boolean=false;
		
		private const offset_x:Number=60;
		private const offset_y:Number=70;
		private const gas_x:Number=20;
		
		private const arrow_position_array:Array=[120,200,280,360,430,510];
		
		public function LeftUpMenuContainer()
		{
			
			initDisplayObject();
			initListener();
		}
		public function constructByXml(xml:XML):void{
					
			var t_menu_panel:SubMenu;
			
			menu_panel_array=new Array();
			
			for(var i:int=0;i<6;i++){
				
				t_menu_panel=new SubMenu();
				t_menu_panel.initialize();
				t_menu_panel.constructByXml(xml.menu[i]);
				t_menu_panel.x=offset_x+i*gas_x;
				t_menu_panel.y=offset_y;
				t_menu_panel.container_skin.arrow.x=arrow_position_array[i];
				menu_panel_array.push(t_menu_panel);
				t_menu_panel.addEventListener(MouseEvent.ROLL_OUT,onSubMenuRollOutHandler);
			
			}
		
		}
		private function initDisplayObject():void{
			
			addChild(menu_button);
			/* menu_panel.initialize();
			
			AddToStageSetter.delayExcuteAfterAddToStage(this,function():void{
				
				new PositionSeter(menu_button,{left:100,top:0},false);
			
			}) */
		
		}
		private function initListener():void{
			
			menu_button.addEventListener(FlashEvent.DISPATCH,buttonBarClickHandler);
			menu_button.addEventListener("hide_btn_click",hideButtonClickHandler);
		
		}
		private function onSubMenuRollOutHandler(e:Event):void{
			
			if(is_pop_up){
					
				disablePopUpMenu();
				
			}
		
		}
		private function buttonBarClickHandler(e:FlashEvent):void{
			
			var is_same:Boolean=false;
			
			if(pop_up_sub_menu==menu_panel_array[int(e.obj)]){
				
				if(!is_pop_up){
					
					is_same=true;
					
				}
			
			}
			if(is_pop_up){
					
				disablePopUpMenu();
				
			}
			if(menu_panel_array[int(e.obj)]!=pop_up_sub_menu){
				
				enablePopUpMenu(int(e.obj));
				
			}else if(is_same){
				
				enablePopUpMenu(int(e.obj));
							
			}
			
		}
		private function hideButtonClickHandler(e:Event):void{
			try{
				
				disablePopUpMenu();
				
			}catch(e:Error){
			
			}
		
		}
		private function disablePopUpMenu():void{
		
			var remove_menu:SubMenu=menu_panel_array[menu_panel_array.indexOf(pop_up_sub_menu)];
			
			TweenLite.to(remove_menu,0.5,{alpha:0,onComplete:function():void{
				
				try{
					
					removeChild(remove_menu);
					
				}catch(e:Error){
				
				};
			
			}});
			
			is_pop_up=false;
		
		}
		private function enablePopUpMenu(id:int):void{
						
			pop_up_sub_menu=addChild(menu_panel_array[id]) as SubMenu;
			pop_up_sub_menu.alpha=0
			TweenLite.to(pop_up_sub_menu,0.5,{alpha:1});
			is_pop_up=true;
		
		}
	}
}