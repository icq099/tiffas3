package lxfa.shanshuishihua.view
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class FLVPlayer extends Video
	{
		private var nc:NetConnection = null;
		private var ns:NetStream = null;
		public function FLVPlayer(url:String,width:int,height:int)
		{
			if(url!=null)
			{
			    nc = new NetConnection();
			    nc.connect(null);
			    ns = new NetStream(nc);
			    ns.client = new Object();
			    ns.play(url);//播放flv的路径，名称:./4.flv
			    ns.pause();
			    this.x=3;
			    this.y=3;
			    this.width=width;
			    this.height=height;
			    this.attachNetStream(ns);
			}
		}
		public function close():void
		{
			nc=null;
			ns=null;
		}
		public function pause():void
		{
			ns.pause();
		}
		public function play():void
		{
			ns.resume();
		}
	}
}