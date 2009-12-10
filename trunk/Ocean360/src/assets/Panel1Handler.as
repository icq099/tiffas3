package assets
{
	import assets.model.HotPointStructManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	public class Panel1Handler
	{
		private var sp:SamplePanelBackGround;//界面句柄
		private var hpsm:HotPointStructManager;
		public function Panel1Handler(sp:SamplePanelBackGround,hpsm:HotPointStructManager)
		{
			this.hpsm=hpsm;
			this.sp=sp;
			sp.panel1.detail.text="";
			sp.panel1.detail.wordWrap=true;
			sp.panel1.detail.addEventListener(Event.SCROLL,scroll);
			this.sp.panel1.addPicture.addEventListener(MouseEvent.CLICK,panel1AddPictureButtonClickEvent);
			this.sp.panel1.deletePicture.addEventListener(MouseEvent.CLICK,panel1DeletePictureButtonClickEvent);
			this.sp.panel1.addMusic.addEventListener(MouseEvent.CLICK,panel1AddMusicButtonClickEvent);
			this.sp.panel1.title.addEventListener(Event.CHANGE,titleChanged);
			this.sp.panel1.detail.addEventListener(Event.CHANGE,detailChanged);
		}
		private function scroll(e:Event):void
		{
			trace("滚动");
		}
		//标题改变的事件
		private function titleChanged(e:Event):void
		{
			this.hpsm.setTextName(sp.panel1.title.text);
		}
		//详细描述的改变事件
		private function detailChanged(e:Event):void
		{
			this.hpsm.setText(sp.panel1.detail.text);
		}
		private var pictureFileReference:FileReference;
		//打开图片文件
		private function panel1AddPictureButtonClickEvent(e:MouseEvent):void
		{
			pictureFileReference=new FileReference();
			var picFilter:FileFilter = new FileFilter("图片文件(jpg,png)", "*.jpg;*.png");
			pictureFileReference.browse([picFilter]);
			pictureFileReference.addEventListener(Event.SELECT,pictureSelect);
		}
		private function pictureSelect(e:Event):void
		{
			var pictureName:String=FileReference(e.currentTarget).name;
			var isDouble:Boolean=false;
			for(var i:int=0;i<sp.panel1.pictureList.length;i++)
			{
				if(pictureName==sp.panel1.pictureList.getItemAt(i).label)
				{
					isDouble=true;
				}
			}
			if(isDouble==false)
			{
				sp.panel1.pictureList.addItem({label:pictureName,icon:""});
				pictureFileReference.addEventListener(Event.COMPLETE,pictureLoaded);
				pictureFileReference.load();
			}
		}
		private function pictureLoaded(e:Event):void
		{
			this.hpsm.addImageByName(pictureFileReference.name,pictureFileReference.data);
		}
		private var musicFileReference:FileReference;
		//打开音乐文件
		private function panel1AddMusicButtonClickEvent(e:MouseEvent):void
		{
			musicFileReference=new FileReference();
			var musicFilter:FileFilter = new FileFilter("音乐文件(mp3)", "*.mp3;");
			musicFileReference.browse([musicFilter]);
			musicFileReference.addEventListener(Event.SELECT,musicSelect);
		}
		//设置音乐文件名
		private function musicSelect(e:Event):void
		{
			sp.panel1.musicName.text=FileReference(e.currentTarget).name;
			musicFileReference.addEventListener(Event.COMPLETE,musicLoaded);
			musicFileReference.load();
		}
		private function musicLoaded(e:Event):void
		{
			this.hpsm.setSound(musicFileReference.name,musicFileReference.data);
		}
		//删除图片的事件
		private function panel1DeletePictureButtonClickEvent(e:MouseEvent):void
		{
			if(sp.panel1.pictureList.selectedIndex==-1)
			{
				
			}else
			{
				this.hpsm.deleteImageByName(sp.panel1.pictureList.getItemAt(sp.panel1.pictureList.selectedIndex).label,sp.panel1.pictureList.selectedIndex)//删除图片数据
				sp.panel1.pictureList.removeItemAt(sp.panel1.pictureList.selectedIndex);
			}
		}
	}
}