package lxfa.view.menu.popumenu.model
{
	import lxfa.model.XmlLoaderModel;
	
	public class PopupMenuModel extends XmlLoaderModel
	{
		private var ID:int;
		public function PopupMenuModel(id:int)
		{
			this.ID=id;
			super("xml/popumenu.xml");
		}
		public function getItems():Array
		{
			var temp:Array=new Array();
			for(var i:int=0;i<xmlData.PopMenu[ID].Item.length();i++)
			{
				temp.push({name:xmlData.PopMenu[ID].Item[i].@name,id:xmlData.PopMenu.Item[i].@id});
			}
			return temp;
		}
		public function getMenuItems():Array
		{
			var temp1:Array=new Array();
			for(var i:int=0;i<xmlData.PopMenu[ID].MenuItem.length();i++)
			{
				var temp:Array=new Array();
				for(var j:int=0;j<xmlData.PopMenu[ID].MenuItem[i].Item.length();j++)
				{
					temp.push({name:xmlData.PopMenu[ID].MenuItem[i].Item[j].@name,id:xmlData.PopMenu[ID].MenuItem[i].Item[j].@id});
				}
				temp1.push({name:xmlData.PopMenu[ID].MenuItem[i].@name,detail:temp});
			}
			return temp1;
		}
	}
}