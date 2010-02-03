package lxfa.shanshuishihua.view
{
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class NormalWindow extends UIComponent
	{
		private var dp:DetailPreview;
		public function NormalWindow()
		{
			dp=new DetailPreview();
			dp.alpha=1;
			this.addChild(dp);
			dp.Btn_Close.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
			this=null;
			dp=null;
			nc=null;
			ns=null;
			video=null;
		}
		private var nc:NetConnection = null;
		private var ns:NetStream = null;
		private var video:Video;
		public function myPlay(url:String):void{
		    nc = new NetConnection();
		    nc.connect(null);
		    ns = new NetStream(nc);
		    ns.client = new Object();
		    ns.play(url);//播放flv的路径，名称:./4.flv
		    video=new Video();
		    video.width=320;
		    video.height=240;
		    video.x=30;
		    video.y=50;
		    video.attachNetStream(ns);
		    this.addChild(video);
		}
	}
}