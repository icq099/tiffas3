package util.menu.popumenu.model
{
	import core.manager.modelManager.ModelManager;
	
	public class PopupMenuModel
	{
		private var ID:int;
		private var xmlData:XML=ModelManager.getInstance().xmlPopumenu;
		public function PopupMenuModel(id:int)
		{
			this.ID=id;
		}
		public function getItems():Array
		{
			var temp:Array=new Array();
			for(var i:int=0;i<xmlData.PopMenu[ID].Item.length();i++)
			{
				temp.push({name:xmlData.PopMenu[ID].Item[i].@name,id:xmlData.PopMenu[ID].Item[i].@id});
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