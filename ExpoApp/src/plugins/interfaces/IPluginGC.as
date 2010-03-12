package plugins.interfaces
{
	//插件删除的时候执行此接口，用于垃圾回收
	public interface IPluginGC
	{
		function dispose():void	//插件卸载时执行
	}
}