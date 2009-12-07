package assets
{
	import assets.model.HotPointStructManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.core.Application;
	public class Panel1Handler
	{
		private var spbgHandler:SamplePanelBackGround;//界面句柄
		private var hpsm:HotPointStructManager;
		public function Panel1Handler(p1h:SamplePanelBackGround,hpsm:HotPointStructManager)
		{
			this.hpsm=hpsm;
			spbgHandler=p1h;
			p1h.panel1.addPicture.addEventListener(MouseEvent.CLICK,panel1AddPictureButtonClickEvent);
			p1h.panel1.deletePicture.addEventListener(MouseEvent.CLICK,panel1DeletePictureButtonClickEvent);
			p1h.panel1.addMusic.addEventListener(MouseEvent.CLICK,panel1AddMusicButtonClickEvent);
			p1h.panel1.title.addEventListener(Event.CHANGE,titleChanged);
			p1h.panel1.detail.addEventListener(Event.CHANGE,detailChanged);
		}
		//标题改变的事件
		private function titleChanged(e:Event):void
		{
			this.hpsm.setTextName(spbgHandler.panel1.title.text);
		}
		//详细描述的改变事件
		private function detailChanged(e:Event):void
		{
			this.hpsm.setText(spbgHandler.panel1.detail.text);
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
			for(var i:int=0;i<spbgHandler.panel1.pictureList.length;i++)
			{
				if(pictureName==spbgHandler.panel1.pictureList.getItemAt(i).label)
				{
					isDouble=true;
				}
			}
			if(isDouble==false)
			{
				spbgHandler.panel1.pictureList.addItem({label:pictureName,icon:""});
			}
			pictureFileReference.addEventListener(Event.COMPLETE,pictureLoaded);
			pictureFileReference.load();
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
			spbgHandler.panel1.musicName.text=FileReference(e.currentTarget).name;
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
			if(spbgHandler.panel1.pictureList.selectedIndex==-1)
			{
				
			}else
			{
				this.hpsm.deleteImageByName(spbgHandler.panel1.pictureList.getItemAt(spbgHandler.panel1.pictureList.selectedIndex).label)//删除图片数据
				spbgHandler.panel1.pictureList.removeItemAt(spbgHandler.panel1.pictureList.selectedIndex);
			}
		}
	}
}