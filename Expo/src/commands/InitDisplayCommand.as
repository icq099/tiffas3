package commands
{
	import communication.Event.MainSystemEvent;
	import communication.MainSystem;
	
	import facades.FacadePv;
	
	import flash.display.Sprite;
	
	import mediators.AppMediator;
	import mediators.MovieMediator;
	import mediators.PluginMediator;
	import mediators.PvSceneMediator;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxys.PScriptRuner;
	import proxys.PScriptRunerBase;
	import proxys.PTravel;
	import proxys.PXml;
	
	import view.MovieViewer;
	import view.Pv3d360Scene;
	import view.Pv3d360SceneCompass;
	
	import yzhkof.Toolyzhkof;

	public class InitDisplayCommand extends SimpleCommand
	{
		public function InitDisplayCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void{
			
			var app:Sprite=AppMediator(facade.retrieveMediator(AppMediator.NAME)).getViewComponent() as Sprite;
			var p_xml:PXml=facade.retrieveProxy(PXml.NAME) as PXml;
			while(app.numChildren>0){
				
				app.removeChildAt(0);
			
			}
			//debug设置
			var main_scene:Pv3d360Scene=new Pv3d360SceneCompass();
			main_scene.stopRend();
			//
			//var main_map:MapDirector=new MapDirector();
			//var main_animate_player:AnimatePlayer=new AnimatePlayer();
			//var main_control_bar:CameraControlBar=new CameraControlBar();
			//var main_left_up_menu:LeftUpMenuContainer=new LeftUpMenuContainer();
			//var main_sound_player:ExhibitSound=new ExhibitSound();
			//var main_sub_title:SubTitle=new SubTitle();
			//var main_popup_menu:Canvas=new Canvas();
			var main_movie:MovieViewer=new MovieViewer();
			var main_plugin:Canvas=new Canvas();
			
			//app.addChild(Toolyzhkof.mcToUI(main_scene));
			
			//app.addChild(Toolyzhkof.mcToUI(main_animate_player));
			//app.addChild(Toolyzhkof.mcToUI(main_map));
			//app.addChild(Toolyzhkof.mcToUI(main_control_bar));
			//app.addChild(Toolyzhkof.mcToUI(main_sound_player));
			//app.addChild(Toolyzhkof.mcToUI(main_sub_title));
			//app.addChild(main_left_up_menu);
			//app.addChild(main_popup_menu);
			app.addChild(main_plugin);
			app.addChild(Toolyzhkof.mcToUI(main_movie));
			
			//facade.registerCommand(FacadePv.LOAD_XML_COMPLETE,InitDisplayObjectCommand);
			facade.registerMediator(new PvSceneMediator(main_scene));
			//facade.registerMediator(new MapMediator(main_map));
			//facade.registerMediator(new AnimatePlayerMediator(main_animate_player));
			//facade.registerMediator(new ControlBarMediator(main_control_bar));
			//facade.registerMediator(new LeftUpMenuMediator(main_left_up_menu));
			//facade.registerMediator(new SoundPlayerMediator(main_sound_player));
			//facade.registerMediator(new SubTitleMediator(main_sub_title));
			//facade.registerMediator(new PopUpMenusMediator(main_popup_menu));
			facade.registerMediator(new MovieMediator(main_movie));
			facade.registerMediator(new PluginMediator(main_plugin));
			
			//new PositionSeter(main_map,{right:130,bottom:100});
			//new PositionSeter(main_control_bar,{left:0,bottom:100});
			//new PositionSeter(main_sound_player,{right:50,top:30});
			//new PositionSeter(main_animate_player,{right:30,bottom:300});
			//main_sub_title.x=10;
			//main_sub_title.y=50;
			
			//显示plugin
			for each(var i:XML in p_xml.getPluginXml().plugin){
				if(i.@visible==1){
					facade.sendNotification(PluginMediator.SHOW_PLUGIN,i);
				}
			}
			var scene:Pv3d360Scene=facade.retrieveMediator(PvSceneMediator.NAME).getViewComponent() as Pv3d360Scene;
			scene.camera=PTravel(facade.retrieveProxy(PTravel.NAME)).getCamera();
			facade.sendNotification(FacadePv.COVER_ENABLE);
			
			var p_script:PScriptRuner=PScriptRuner(facade.retrieveProxy(PScriptRunerBase.NAME));
			var uicom:UIComponent=Toolyzhkof.mcToUI(main_scene);
			p_script.addAPI("enable360System",function():void{
				app.addChild(uicom);
				main_scene.startRend();	
			});
			p_script.addAPI("disable360System",function():void{
				app.removeChild(uicom);
				main_scene.stopDrag();	
			});
			
			MainSystem.getInstance().dispatchEvent(new MainSystemEvent(MainSystemEvent.INIT_DISPLAY));
			facade.removeCommand(FacadePv.INIT_DISPLAY);
		
		}
	}
}