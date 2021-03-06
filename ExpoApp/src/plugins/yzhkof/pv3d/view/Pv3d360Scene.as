﻿package plugins.yzhkof.pv3d.view
{
	import core.manager.MainSystem;
	import core.manager.sceneManager.SceneManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
	import loaders.SerialCacheMovieClipLoader;
	import loaders.item.SerialCacheMovieClipItem;
	
	import memory.MemoryRecovery;
	import memory.MyGC;
	
	import movement.UpDownMovement;
	
	import mx.core.Application;
	
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	
	import plugins.yzhkof.view.MapToolTip;
	
	import structure.AddavanceArray;
	
	import view.ToolBitmapData;
	import view.fl2mx.Fl2Mx;
	
	import yzhkof.MovieCacheMaterial;

	public class Pv3d360Scene extends Sprite
	{

		private var compassBitmapdata:BitmapData=ToolBitmapData.getInstance().drawDisplayObject(new CompassSkin);
		private var arrow_bitmapdata:BitmapData=ToolBitmapData.getInstance().drawDisplayObject(new ArrowSkin);

		private var this_stage:Stage;
		private var URLpath:URLRequest;
		protected var pLoader:Loader;
		protected var czoom:Number;
		protected var pdetail:Number;
		protected var tip_sprite:MapToolTip=new MapToolTip();

		protected var renderer:BasicRenderEngine;
		protected var material:MaterialObject3D;
		protected var scene:Scene3D;
		protected var viewport:Viewport3D;

		protected var pwidth:Number;
		protected var pheight:Number;
		protected var sphere:Sphere;
		protected var compass_plane:Plane;
		protected var onComplete:Function;
		protected var view_loader:LoadingLine;
		protected var renderable:Boolean=false;
		protected var url_type:String;

		private var stats_view:StatsView;

		protected var state:String=INITING;

		protected const INITING:String="INITING";
		protected const LOADING_IMG:String="LOADING_IMG";
		protected const BROWSING:String="BROWSING";

		public static const REND_ALL:String="REND_ALL";
		public static const REND_ANIMATE:String="REND_ANIMATE";

		public var animates:Array=new Array();
		public var arrows:Array=new Array();
		private var movements:Array=new Array();
		public var camera:FreeCamera3D;
		public var render_type:String=REND_ALL;
		private var addonLoader:SerialCacheMovieClipLoader=new SerialCacheMovieClipLoader();
		public function Pv3d360Scene(czoom:Number=11, pdetail:Number=50)
		{

			this.pdetail=pdetail;
			this.czoom=czoom;
			init();
			initListener();
		}

		protected function init():void
		{

			renderer=new BasicRenderEngine();
			scene=new Scene3D();
			camera=new FreeCamera3D();
			camera.focus=100;
			viewport=new Viewport3D(900, 600, false, true);
			pLoader=new Loader();

			pLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, chageCompleteHandler);
			pLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgessHandler);

			addChild(viewport);
			camera.z=1;
			sphere=new Sphere(material, 5000, 40, 20);
			sphere.scaleX*=-1
			//设置罗盘
			var material_compass:BitmapMaterial=new BitmapMaterial(compassBitmapdata.clone());
			material_compass.doubleSided=true;
			compass_plane=new Plane(material_compass, 75, 75, 5, 5);
			compass_plane.rotationX=-90;
			compass_plane.y=-80;
			compass_plane.z=1;


			scene.addChild(compass_plane);
			scene.addChild(sphere);

			state=BROWSING;
		}
		//更改场景全景
		public function changeBitmap(URL:String, type:String="", onComplete:Function=null):void
		{
			if (state != LOADING_IMG)
			{
				state=LOADING_IMG;

				this.url_type=type;

				this.onComplete=onComplete;

				if (view_loader != null)
				{
					view_loader.removeEventListener(Event.ENTER_FRAME, loadEnterFrameHandler);
				}
				view_loader=new LoadingLine();
				view_loader.addEventListener(Event.ENTER_FRAME, loadEnterFrameHandler);
				view_loader.percent_text.text="0%"
				view_loader.percent_text.selectable=false;
				Application.application.addChild(Fl2Mx.fl2Mx(view_loader));
				pLoader.load(new URLRequest(URL));
			}
		}
		public function setCompassRotation(rota:Number):void
		{
			compass_plane.rotationY=rota;
		}
		public function addArrow(destination:int,rota:Number=0, tip_text:String=""):Plane
		{
			var material_arrow:BitmapMaterial=new BitmapMaterial(arrow_bitmapdata.clone());
			material_arrow.smooth=true;
			material_arrow.doubleSided=true;
			material_arrow.interactive=true;
			var plane:Plane=new Plane(material_arrow, 4.2, 25.2, 2, 4)
			arrows.push(plane);
			plane.rotationX=-90;
			plane.rotationY=rota;
			plane.moveUp(14);
			plane.y=-80;
			scene.addChild(plane);
			plane.useOwnContainer=true;
			var glowFilter:GlowFilter=new GlowFilter(0x000055, 1, 16, 16, 2, 1, false, false);
			if (tip_text.length > 0)
			{

				plane.extra={text: tip_text};
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, function(e:Event):void
					{
						addChild(tip_sprite);
						tip_sprite.text=e.currentTarget.extra.text;
						plane.filters=[glowFilter];
					});
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, function(e:Event):void
					{
						removeChild(tip_sprite);
						plane.filters=[];
					});
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,function(e:InteractiveScene3DEvent):void{
					SceneManager.getInstance().gotoScene(destination);
				})
			}
			draw();
			return plane;
		}

		public function cleanAllArrow():void
		{

			if (arrows.length > 0)
			{
				for each (var plane:Plane in arrows)
				{
					if(plane.parent!=null)
					{
						plane.parent.removeChild(plane);
					}
					if(plane.material!=null)
					{
						if(plane.material.bitmap!=null)
						{
							plane.material.bitmap.dispose();
						}
						plane.material.destroy();
					}
					plane=null;
				}
				arrows=new Array();
			}
		}
		private var distance:int=10;
		//增加动画
		public function addAminate(URL:String, init_obj:Object, cache:Boolean=false):Plane
		{
			var width:Number=init_obj["width"] ? init_obj["width"] : 100;
			var height:Number=init_obj["height"] ? init_obj["height"] : 100;
			var segmentsW:Number=init_obj["segmentsW"] ? init_obj["segmentsW"] : 2;
			var segmentsH:Number=init_obj["segmentsH"] ? init_obj["segmentsH"] : 2;
			var visible:Number=init_obj["visible"] ? init_obj["visible"] : 1;
			var tip:String=init_obj["tip"] ? init_obj["tip"] : "";
			var movement:int=init_obj["movement"] ? init_obj["movement"] : 0;
			var maxHeight:Number=init_obj["maxHeight"] ? init_obj["maxHeight"] : 0;
			var minHeight:Number=init_obj["minHeight"] ? init_obj["minHeight"] : 0;
			var speed:Number=init_obj["speed"] ? init_obj["speed"] : 0;
			var filter:int=init_obj["filter"] ? init_obj["filter"] : 0;
			var sign:int=init_obj["sign"] ? init_obj["sign"] : 0;
			var debuge:int=init_obj["debuge"] ? init_obj["debuge"] : 0;
			var plane_animate:BendPlane=new BendPlane(new ColorMaterial(0xffffff, 0), width, height, segmentsW, segmentsH, init_obj);
			plane_animate.offset=init_obj["offset"] ? init_obj["offset"] : 0;
			plane_animate.angle=init_obj["angle"] ? init_obj["angle"] : 0;
			plane_animate.force=init_obj["force"] ? init_obj["force"] : 0;
			var autoKeep:Number=init_obj["autoKeep"]?init_obj["autoKeep"]:0;
			if (Number(init_obj["scaleX"]) == 0 || Number(init_obj["scaleX"]) < 0)
			{
				plane_animate.scaleX=1;
			}
			else
			{
				plane_animate.scaleX=Number(init_obj["scaleX"]);
			}
			if (Number(init_obj["scaleY"]) == 0 || Number(init_obj["scaleY"]) < 0)
			{
				plane_animate.scaleY=1;
			}
			else
			{
				plane_animate.scaleY=Number(init_obj["scaleY"]);
			}
			plane_animate.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS,function(e:InteractiveScene3DEvent):void{
				MainSystem.getInstance().runScript(init_obj["onClick"]);
				if(sign==1)
				{
					plane_animate.alpha=0.5;
				}
				if(autoKeep==1)//如果要自动保存当前的对象
				{
					plane_animate.material.interactive=false;
				}
			});
			//添加运动
			if (movement == 1)
			{
				var m:UpDownMovement=new UpDownMovement(plane_animate, maxHeight, minHeight, speed);
				movements.push(m);
			}
			animates.push(plane_animate);
			scene.addChild(plane_animate);
			var loader:Loader=new Loader();
			loader.load(new URLRequest(URL));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					if (animates.indexOf(plane_animate) > -1)
					{
						var content:MovieClip=e.currentTarget.content
						if (visible == 1) //如果是可见的就是LED墙
						{
							var material:MovieMaterial;
							if (cache)
							{
								material=new MovieCacheMaterial(content, true, true, true, new Rectangle(0, 0, content.width, content.height));
							}
							else
							{
								material=new MovieMaterial(content, true, true, true, new Rectangle(0, 0, content.width, content.height));
							}
							material.allowAutoResize=false;
							material.smooth=true;
							material.interactive=true;
							plane_animate.material=material;
						}
						else //不可见就是透明可点击的区域
						{
							var colorMat:ColorMaterial=new ColorMaterial(0xA7C520, 0);
							colorMat.doubleSided=true;
							colorMat.interactive=true;
							//開啟材質的互動模式。
							plane_animate.material=colorMat;
						}
					}
				});
			if (filter == 1)
			{
				var glowFilter:GlowFilter=new GlowFilter(0x009900, 1, 16, 16, 1, 1, false, false);
				plane_animate.useOwnContainer=true; //一定要为true才能发光
			}
//			plane_animate.filters=[glowFilter];
			//添加事件
			plane_animate.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, function(e:InteractiveScene3DEvent):void
				{
					if(tip!="")
					{
						tip_sprite.text=tip
						addChild(tip_sprite);
					}
					plane_animate.filters=[glowFilter];
					MainSystem.getInstance().runScript(init_obj["onOver"]);
				});
			plane_animate.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, function(e:InteractiveScene3DEvent):void
				{
					if(tip!="")
					{
						removeChild(tip_sprite);
					}
					plane_animate.filters=[];
					MainSystem.getInstance().runScript(init_obj["onOut"]);
				});
			
			var rotateSpeed:int=5;
			var scaleSpeed:Number=0.1;
			if(debuge==1)
			{
//			Application.application.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
//				{
//					if (e.keyCode == 87)
//					{
//						plane_animate.z+=distance;
//					}
//					if (e.keyCode == 83)
//					{
//						plane_animate.z-=distance;
//					}
//					if (e.keyCode == 65)
//					{
//						plane_animate.x+=distance;
//					}
//					if (e.keyCode == 68)
//					{
//						plane_animate.x-=distance;
//					}
//					if (e.keyCode == 189)
//					{
//						plane_animate.y+=distance;
//					}
//					if (e.keyCode == 187)
//					{
//						plane_animate.y-=distance;
//					}
//					if (e.keyCode == 81)
//					{
//						plane_animate.rotationY+=rotateSpeed;
//					}
//					if (e.keyCode == 69)
//					{
//						plane_animate.rotationY-=rotateSpeed;
//					}
//					if (e.keyCode == 90)
//					{
//						plane_animate.scaleX+=scaleSpeed;
//					}
//					if (e.keyCode == 88)
//					{
//						plane_animate.scaleX-=scaleSpeed;
//					}
//					if (e.keyCode == 67)
//					{
//						plane_animate.scaleY+=scaleSpeed;
//					}
//					if (e.keyCode == 86)
//					{
//						plane_animate.scaleY-=scaleSpeed;
//					}
//					if(e.keyCode==73)
//					{
//						distance+=10;
//					}
//					if(e.keyCode==75)
//					{
//						distance-=10;
//					}
//					trace("x=\"" + plane_animate.x + "\" y=\"" + plane_animate.y + "\" z=\"" + plane_animate.z + "\" rotationY=\"" + plane_animate.rotationY + "\"" + " scaleX=\"" + plane_animate.scaleX + "\" scaleY=\"" + plane_animate.scaleY + "\"");
//				});
			}
			return plane_animate;
		}

		public function cleanAllAnimate():void
		{
			if(movements.length>0)
			{
				for each(var m:UpDownMovement in movements)
				{
					m.dispose();
					m=null;
				}
			}
			if (animates.length > 0)
			{
				for each (var plane:Plane in animates)
				{
					if(plane.parent!=null)
					{
						plane.parent.removeChild(plane);
					}
					if(plane.material!=null)
					{
						if(plane.material.bitmap!=null)
						{
							plane.material.bitmap.dispose();
						}
						plane.material.destroy();
					}
					plane=null;
				}
				animates=new Array();
			}
		}

		private function addToStageHandler(e:Event):void
		{
			this_stage=this.stage;
			this_stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			this_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
		}

		private function mouseLeaveHandler(e:Event):void
		{
			renderable=false;
		}

		private function mouseMoveHandler(e:MouseEvent):void
		{
			if(controlAble)
			{
				renderable=true;
			}
		}

		private function loadProgessHandler(e:ProgressEvent):void
		{
			view_loader.percent_text.text=Math.round((e.bytesLoaded / e.bytesTotal) * 100) + "%";
		}
		private static var cacheShpereBitmap:BitmapData;
		protected function chageCompleteHandler(e:Event):void
		{
			TweenLite.to(view_loader, 0.5, {alpha: 0, onCompleteParams: [view_loader], onComplete: function(... arg):void
				{
					view_loader.removeEventListener(Event.ENTER_FRAME, loadEnterFrameHandler);
					if(view_loader.parent!=null)
					{
						view_loader.parent.removeChild(view_loader);
					}
					view_loader=null;
				}});
			if(material!=null && material.bitmap!=null)
			{
				material.bitmap=null;
				material.destroy();
				material=null;
			}
			if(sphere.material!=null)
			{
				sphere.material=null;
			}
			if(cacheShpereBitmap!=null)
			{
				cacheShpereBitmap.dispose();
				cacheShpereBitmap=null;
			}
			switch (url_type)
			{
				case "movieclip":
					material=new MovieMaterial(MovieClip(pLoader.content), true, true,true);
					break;
				default:
				    cacheShpereBitmap=Bitmap(pLoader.content).bitmapData;
				    pLoader.unload();
					material=new BitmapMaterial(cacheShpereBitmap, true);
					cacheBitmap=cacheShpereBitmap.clone();
					break;
			}
			material.doubleSided=false;
			material.smooth=true;
			material.interactive=false;
			sphere.material=material;
			//手动回收
			MyGC.gc();

			//回调
			onComplete();
			state=BROWSING;
		}
		private var cache:Array=new Array();
		protected static var movieCache:Dictionary=new Dictionary();
		private var cacheBitmap:BitmapData;

		private function loadEnterFrameHandler(e:Event):void
		{
			if(e.currentTarget!=null && this_stage!=null)
			{
				e.currentTarget.x=this_stage.mouseX;
				e.currentTarget.y=this_stage.mouseY;
			}
		}

		private function initListener():void
		{

			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);

		}
		private function onEnterFrameHandler(e:Event):void
		{
			if(renderable)
			{
				draw();
			}
		}
		private var controlAble:Boolean=false;
		public function startRend():void
		{
			controlAble=true;
			renderable=true;
		}
		public function stopRend():void
		{
			controlAble=false;
			renderable=false;
		}
		private var loader:Loader;
		private var task:Array=new Array();
		private var index:int=0;
		public function updateAddons(xml_ShpereAddon:XMLList):void
		{
			loader=new Loader();
			var xml_ShpereAddon:XMLList=xml_ShpereAddon;
			for(var i:int=0;i<xml_ShpereAddon.length();i++)
			{
				var item:SerialCacheMovieClipItem=new SerialCacheMovieClipItem();
				item.id=xml_ShpereAddon[i].@url;
				item.url=xml_ShpereAddon[i].@url;
				item.x=xml_ShpereAddon[i].@x;
				item.y=xml_ShpereAddon[i].@y;
				task.push(item);
			}
			if(xml_ShpereAddon[0]!=null)
			{
				loader.load(new URLRequest(xml_ShpereAddon[0].@url));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCacheMovieClipLoaded);
			}
		}
		public function disposeCacheBitMap():void
		{
				if(cacheBitmap!=null)
				{
					cacheBitmap.dispose();
					cacheBitmap=null;
				}
		}
		private function onCacheMovieClipLoaded(e:Event):void
		{
			MemoryRecovery.getInstance().gcFun(loader.contentLoaderInfo,Event.COMPLETE,onCacheMovieClipLoaded);
			var content:MovieClip=MovieClip(loader.content);
			var temp:BitmapData=new BitmapData(loader.width+1,loader.height+1);
			temp.copyPixels(cacheBitmap,new Rectangle(task[index].x,task[index].y,loader.width+1,loader.height+1),new Point(0,0));
			tempBitmaps.push(temp);
			var cache:AddavanceArray=new AddavanceArray();
			for(var i:int=0;i<content.totalFrames;i++)
			{
				content.gotoAndStop(i);
				cache.push(ToolBitmapData.getInstance().drawDisplayObject(content));
			}
			movieCache[task[index].id]=cache;
			index++;
			loader.unload();
			if(index==task.length)
			{
				SceneManager.getInstance().dispacherJustBeforeCompleteEvent(SceneManager.getInstance().currentSceneId);
				MemoryRecovery.getInstance().gcFun(Application.application,Event.ENTER_FRAME,refressAddon);
				Application.application.addEventListener(Event.ENTER_FRAME,refressAddon);
			}else
			{
				loader.load(new URLRequest(task[index].url));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCacheMovieClipLoaded);
			}
		}
		public function cleanAllAddon():void
		{
			addonLoader.clear();
			MemoryRecovery.getInstance().gcFun(Application.application,Event.ENTER_FRAME,refressAddon);
		}
		private var tempBitmaps:Array=new Array;
		private function refressAddon(e:Event):void
		{
			for(var i:int=0;i<tempBitmaps.length;i++)
			{
				var addvanceArray:AddavanceArray=movieCache[task[i].id];
				var currentBitmapData:BitmapData=BitmapData(addvanceArray.getValue(addvanceArray.index));
				var temp:BitmapData=tempBitmaps[i];
				material.bitmap.copyPixels(temp,new Rectangle(0,0,temp.width,temp.height),new Point(task[i].x,task[i].y));
//				material.bitmap.copyPixels(currentBitmapData,new Rectangle(0,0,currentBitmapData.width-1,currentBitmapData.height-1),new Point(task[i].x,task[i].y),null,null,true);
				var matrix:Matrix=new Matrix();
				matrix.tx=task[i].x;
				matrix.ty=task[i].y;
				material.bitmap.draw(currentBitmapData,matrix,null,null,null,false);
				addvanceArray.index++;
				if(addvanceArray.index==addvanceArray.length)
				{
					addvanceArray.index=0;
				}
			}
		}
		public function draw():void
		{
			if(tip_sprite!=null)
			{
				tip_sprite.x=mouseX;
				tip_sprite.y=mouseY;
			}
			renderer.renderScene(scene, camera, viewport);
		}
	}
}