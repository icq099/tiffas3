﻿package view.debug.animate{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import gs.TweenLite;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	import org.papervision3d.view.stats.StatsView;
	
	import yzhkof.MovieCacheMaterial;
	import yzhkof.MyGC;
	import yzhkof.debug.debugTrace;

	public class Pv3d360Scene extends Sprite {
		
		[Embed(source="asset/compass.png")]
		private var CompassBitmapdata:Class;
		[Embed(source="asset/Hotpoint.png")]
		private var HotPointBitmapdata:Class;
		[Embed(source="asset/Arrow.png")]
		private var Arrow:Class;
		
		private var this_stage:Stage;
		private var URLpath:URLRequest;
		protected var pLoader:Loader;
		protected var czoom:Number;
		protected var pdetail:Number;
		
		protected var renderer:BasicRenderEngine;
		protected var material:BitmapMaterial=new BitmapMaterial();
		protected var hot_point_bitmap:Bitmap=new HotPointBitmapdata();
		protected var hot_point_material:BitmapMaterial=new BitmapMaterial(hot_point_bitmap.bitmapData);
		protected var scene:Scene3D;
		protected var viewport:Viewport3D;
		protected var layer_animate:ViewportLayer;
		protected var layer_arrows:ViewportLayer;
		protected var layer_hot_points:ViewportLayer;
		protected var layer_compass:ViewportLayer;
		protected var tip_sprite:MapToolTip=new MapToolTip();

		protected var pwidth:Number;
		protected var pheight:Number;
		protected var sphere:Sphere;
		protected var compass_plane:Plane;
		protected var onComplete:Function;
		protected var view_loader:LoadingLine;
		protected var renderable:Boolean=true;
		private var stats_view:StatsView;
		
		protected var state:String=INITING;
		
		protected const INITING:String="INITING";
		protected const LOADING_IMG:String="LOADING_IMG";
		protected const BROWSING:String="BROWSING";
		
		public static const  REND_ALL:String="REND_ALL";
		public static const  REND_ANIMATE:String="REND_ANIMATE";
		
		public var animates:Array=new Array();
		public var arrows:Array=new Array();
		public var hot_points:Array=new Array();
		public var camera:FreeCamera3D;
		public var render_type:String=REND_ALL;
		
		private var _mouse3D:Mouse3D;
		
		private var debug_plane:Plane;

		public function Pv3d360Scene(czoom:Number=11,pdetail:Number=50){
			
			this.pdetail=pdetail;
			this.czoom=czoom;
			init();
			initListener();
		}
		protected function init():void {
			
			renderer = new BasicRenderEngine();
			scene = new Scene3D();
			camera = new FreeCamera3D();
			viewport=new Viewport3D(0,0,true,true);
			stats_view=new StatsView(renderer);
			pLoader=new Loader();
			
			pLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,chageCompleteHandler);
			pLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgessHandler);			
			
			addChild(viewport);

			camera.z=0;
			
			sphere=new Sphere(material,5000,pdetail,pdetail/2);
			sphere.scaleX*=-1
			
			//设置罗盘
			var compass_bitmap:Bitmap=new CompassBitmapdata();
			var material_compass:BitmapMaterial=new BitmapMaterial(compass_bitmap.bitmapData);
			//material_compass.smooth=true;
			material_compass.doubleSided=true;
			compass_plane=new Plane(material_compass,40,40,5,5);
			compass_plane.rotationX=-90;
			compass_plane.y=-30;
			compass_plane.z=1;
			layer_compass=viewport.getChildLayer(compass_plane);
			
			
			/* var plane:Plane=new Plane(new ColorMaterial(),100,100)
			plane.z=500
			scene.addChild(plane); */
			
			hot_point_material.interactive=true;
			hot_point_material.smooth=true;
			//设置viewportlayer
			viewport.containerSprite.sortMode=ViewportLayerSortMode.INDEX_SORT;
			
			layer_animate=viewport.getChildLayer(new DisplayObject3D());
			layer_hot_points=viewport.getChildLayer(new DisplayObject3D());
			layer_arrows=viewport.getChildLayer(new DisplayObject3D());
			layer_arrows.buttonMode=true;
			layer_hot_points.buttonMode=true;
			
			layer_animate.layerIndex=0;
			layer_hot_points.layerIndex=1;
			layer_compass.layerIndex=2;
			layer_arrows.layerIndex=3;
			
			scene.addChild(compass_plane);
			scene.addChild(sphere);
			
			state=BROWSING;
			
			Mouse3D.enabled=true;
			
			_mouse3D = viewport.interactiveSceneManager.mouse3D;
			TweenLite.delayedCall(8,function():void{
			
			debug_plane=addAminate("animate/A.swf",{width:1000,height:1000,x:0,y:0,z:1000});
			
			})
			
			//提示文字
			addEventListener(Event.ENTER_FRAME,function(e:Event):void{
				
				tip_sprite.x=mouseX;
				tip_sprite.y=mouseY;
			
			})
			
		}
		//添加点击热点
		public function addHotPoint(init_obj:Object,tip_text:String=""):Plane{
			
			var width:Number=init_obj["width"]?init_obj["width"]:100;
			var height:Number=init_obj["height"]?init_obj["height"]:100;
			var segmentsW:Number=init_obj["segmentsW"]?init_obj["segmentsW"]:0;
			var segmentsH:Number=init_obj["segmentsH"]?init_obj["segmentsH"]:0;
			
			var hot_point_plane:Plane=new Plane(hot_point_material,width,height,segmentsW,segmentsH,init_obj);
			
			hot_points.push(hot_point_plane);
			
			scene.addChild(hot_point_plane);
			
			layer_hot_points.addDisplayObject3D(hot_point_plane);
			
			if(tip_text!=""){
				
				tip_sprite.text=tip_text;
				
				hot_point_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER,function(e:Event):void{
					
					addChild(tip_sprite);
				
				});
				hot_point_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT,function(e:Event):void{
					
					removeChild(tip_sprite);
				
				});
			
			}
			
			return hot_point_plane;
		
		}
		//清除所有点击热点
		public function cleanAllHotPoints():void{
			
			if(hot_points.length>0){
				for each(var item:Plane in hot_points){
					
					layer_hot_points.removeDisplayObject3D(item)
					scene.removeChild(item)
					
				}
				hot_points=new Array();
			}
		
		}
		//更改场景全景
		public function changeBitmap(URL:String,onComplete:Function=null):void{
			
			if(state!=LOADING_IMG){
				
				state=LOADING_IMG;
				
				this.onComplete=onComplete;
				
				if(view_loader!=null){
					
					view_loader.removeEventListener(Event.ENTER_FRAME,loadEnterFrameHandler);
				
				}
				view_loader=new LoadingLine();
				view_loader.addEventListener(Event.ENTER_FRAME,loadEnterFrameHandler);
				view_loader.percent_text.text="0%"
				view_loader.percent_text.selectable=false;
				this_stage.addChild(view_loader);
				/* 
				if(pLoader!=null){
					
					pLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,chageCompleteHandler);
					pLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgessHandler);
				
				}
				 */
				pLoader.load(new URLRequest(URL));
			}
		}
		public function setCompassRotation(rota:Number):void{
			
			compass_plane.rotationY=rota;
			
		}
		public function addArrow(rota:Number=0):Plane{
			
			var arrow_bitmap:Bitmap=new Arrow();
			var material_arrow:BitmapMaterial=new BitmapMaterial(arrow_bitmap.bitmapData);
			material_arrow.smooth=true;
			material_arrow.doubleSided=true;
			material_arrow.interactive=true;
			var plane:Plane=new Plane(material_arrow,4,9,2,4)
			arrows.push(plane);
			plane.rotationX=-90;
			plane.rotationY=rota;
			plane.moveUp(8);
			plane.y=-29
			scene.addChild(plane);
			layer_arrows.addDisplayObject3D(plane);
			draw();
			return plane;
		
		}
		public function cleanAllArrow():void{
			
			if(arrows.length>0){
				for each(var item:Plane in arrows){
					
					layer_arrows.removeDisplayObject3D(item)
					scene.removeChild(item)
					item.material.destroy();
				}
				arrows=new Array();
			}
		
		}
		//增加动画
		public function addAminate(URL:String,init_obj:Object,cache:Boolean=false):Plane{
			
			/* var x:Number=init_obj["x"]?init_obj["x"]:0;
			var y:Number=init_obj["y"]?init_obj["y"]:0;
			var z:Number=init_obj["z"]?init_obj["z"]:0;
			var rotationX:Number=init_obj["rotationX"]?init_obj["rotationX"]:0;
			var rotationY:Number=init_obj["rotationY"]?init_obj["rotationY"]:0;
			var rotationZ:Number=init_obj["rotationZ"]?init_obj["rotationZ"]:0; */
			var width:Number=init_obj["width"]?init_obj["width"]:100;
			var height:Number=init_obj["height"]?init_obj["height"]:100;
			var segmentsW:Number=init_obj["segmentsW"]?init_obj["segmentsW"]:2;
			var segmentsH:Number=init_obj["segmentsH"]?init_obj["segmentsH"]:2;
			
			
			var plane_animate:Plane=new Plane(new ColorMaterial(0xffffff),width,height,segmentsW,segmentsH,init_obj);
			
			/* plane_animate.x=x;
			plane_animate.y=y;
			plane_animate.z=z;
			plane_animate.rotationX=rotationX;			
			plane_animate.rotationY=rotationY;
			plane_animate.rotationZ=rotationZ; */			
			
			animates.push(plane_animate);
			
			scene.addChild(plane_animate);
				
			layer_animate.addDisplayObject3D(plane_animate);
			
			var loader:Loader=new Loader();
			loader.load(new URLRequest(URL));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
				
				if(animates.indexOf(plane_animate)>-1){
					
					var content:MovieClip=e.currentTarget.content
					var material:MovieMaterial;
					if(cache){
						
						material=new MovieCacheMaterial(content,true,true,true,new Rectangle(0,0,content.width,content.height));					
					
					}else{
						
						material=new MovieMaterial(content,true,true,true,new Rectangle(0,0,content.width,content.height));
					
					}
					material.allowAutoResize=false;
					material.smooth=true;
					plane_animate.material=material;
				
				}
			});
			
			return plane_animate;
		
		}
		public function cleanAllAnimate():void{
			
			if(animates.length>0){
				for each(var item:Plane in animates){
					
					layer_animate.removeDisplayObject3D(item);
					scene.removeChild(item)
					if(item.material!=null){
						item.material.destroy();
					}
				}
				
				animates=new Array();
			}
		
		}
		private function addToStageHandler(e:Event):void{
			
			this_stage=this.stage;
			this_stage.addChild(stats_view);
			this_stage.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler,false,0,true);
			this_stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler,false,0,true);
		
		}
		private function mouseLeaveHandler(e:Event):void{
			
			_stopRend();
		
		}
		private function mouseMoveHandler(e:MouseEvent):void{
			
			_startRend();
		
		}
		private function loadProgessHandler(e:ProgressEvent):void{
			
			view_loader.percent_text.text=Math.round((e.bytesLoaded/e.bytesTotal)*100)+"%";
		
		}
		private function chageCompleteHandler(e:Event):void{
			
			TweenLite.to(view_loader,0.5,{alpha:0,onCompleteParams:[view_loader],onComplete:function(...arg):void{
				
				arg[0].removeEventListener(Event.ENTER_FRAME,loadEnterFrameHandler);
				this_stage.removeChild(arg[0]);
				arg[0]=null;
			
			}});
			
			if(material!=null){
			
				material.destroy();
			
			}
			//手动回收
			MyGC.gc();
			
			material=new BitmapMaterial(Bitmap(pLoader.content).bitmapData,true);
			material.smooth=true;
			material.interactive=true;
			//material.opposite=true;
			//material.doubleSided=true;
			
			sphere.material=material;
			
			sphere.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK,function(e:Event):void{
				
				debug_plane.x=_mouse3D.x;
				debug_plane.y=_mouse3D.y;
				debug_plane.z=_mouse3D.z;				
			
			})
			stage.addEventListener(KeyboardEvent.KEY_DOWN,function(e:KeyboardEvent):void{
				
				if(e.keyCode==Keyboard.LEFT){
					
					debug_plane.scaleX+=0.01;
				
				}
				if(e.keyCode==Keyboard.RIGHT){
					
					debug_plane.scaleX-=0.01;
				
				}
				if(e.keyCode==Keyboard.UP){
					
					debug_plane.scaleY+=0.01;
				
				}
				if(e.keyCode==Keyboard.DOWN){
					
					debug_plane.scaleY-=0.01;
				
				}
				if(e.keyCode==87){
					
					debug_plane.rotationX+=0.3;
				
				}
				if(e.keyCode==83){
					
					debug_plane.rotationX-=0.3;
				
				}
				if(e.keyCode==65){
					
					debug_plane.rotationY+=0.3;
				
				}
				if(e.keyCode==68){
					
					debug_plane.rotationY-=0.3;
				
				}
				if(e.keyCode==103){
					
					debug_plane.x+=0.5;
				
				}
				if(e.keyCode==104){
					
					debug_plane.x-=0.5;
				
				}
				if(e.keyCode==100){
					
					debug_plane.y+=0.5;
				
				}
				if(e.keyCode==101){
					
					debug_plane.y-=0.5;
				
				}
				if(e.keyCode==97){
					
					debug_plane.z+=0.5;
				
				}
				if(e.keyCode==98){
					
					debug_plane.z-=0.5;
				
				}
				
				if(e.keyCode==Keyboard.ENTER){
					
					draw();
				
				}
				
				if(e.keyCode==Keyboard.SPACE){
										
					debugTrace("x=\""+debug_plane.x+"\"",
					"y=\""+debug_plane.y+"\"",
					"z=\""+debug_plane.z+"\"",
					"width=\""+debug_plane.scaleX*1000+"\"",
					"height=\""+debug_plane.scaleY*1000+"\"",
					"rotationX=\""+debug_plane.rotationX+"\"",
					"rotationY=\""+debug_plane.rotationY+"\"");
				
				}
			
			})
			
			//回调
			onComplete();
			state=BROWSING;
			
		}
		private function updateHotpoints():void{
			
			if(hot_points.length>0){
				for each(var item:Plane in hot_points){
					
					item.lookAt(camera);
					item.yaw(180);
					
				}
			}
		
		} 
		private function loadEnterFrameHandler(e:Event):void{
			
			e.currentTarget.x=this_stage.mouseX;
			e.currentTarget.y=this_stage.mouseY;
		
		}
		private function initListener():void{
			
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			_startRend();
		
		}
		private function onEnterFrameHandler(e:Event):void{
			
			switch (render_type){
			
			case REND_ALL: 
					draw();
			break;
			case REND_ANIMATE:
				 	draw_layer();
			break;
			}
		
		}
		private function _startRend():void{
			
			if(renderable){
				addEventListener(Event.ENTER_FRAME,onEnterFrameHandler)
			}
		
		}
		private function _stopRend():void{
			
			removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler)
		
		}
		public function startRend():void{
			
			renderable=true;
			_startRend();
		
		}
		public function stopRend():void{
			
			renderable=false;
			_stopRend();
		
		}
		public function draw():void {
			
			renderer.renderScene(scene, camera, viewport);
			updateHotpoints();

		}
		public function draw_layer():void{
			
			renderer.renderLayers(scene,camera,viewport,[layer_arrows,layer_animate,layer_hot_points]);	
			
		}
	}
}